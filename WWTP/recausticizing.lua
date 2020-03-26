--[[-------------------------------------------------------------------------------------------------------------------
# TB CASE STUDY (RECAUSTICIZING SECTION)

# REFERENCE
  Kermani, M., Périn-Levasseur, Z., Benali, M., Savulescu, L., Maréchal, F., 2017. A novel MILP approach for simultaneous optimization of water and energy: Application to a Canadian softwood Kraft pulping mill. Computers & Chemical Engineering. doi:10.1016/j.compchemeng.2016.11.043
  + PhD thesis
--]]-------------------------------------------------------------------------------------------------------------------
--
local osmose  = require 'osmose'
local model   = osmose.Model 'recausticizing'
local cp      = require 'coolprop'
local layers  = require 'ET.pulp.layers'
setmetatable(model.layers,layers.layers_metatable)
-----------------------------------------------------------------------------------------------------------------------
--model.software = {'Ecoinvent'}
-----------------------------------------------------------------------------------------------------------------------
model.Class = {Group = 'recausticizing', Type = 'pulp&paper', SubType = 'recausticizing of pulp'}
-----------------------------------------------------------------------------------------------------------------------
model.Tagging = {TagName = 'recausticizing', DisplayName = 'recausticizing', Description = 'recausticizing'}
-----------------------------------------------------------------------------------------------------------------------
model.author = {{Id = 1, Author = 'MAZIAR KERMANI', Date = '10-FEB-2016', ChangeLog = ''}, {Id = 2, Author = 'MAZIAR KERMANI', Date = '23-MAR-2018', ChangeLog = 'check'}}
-----------------------------------------------------------------------------------------------------------------------
model.values = {}
-----------------------------------------------------------------------------------------------------------------------
model.inputs.cp_water      = {default = 4.2, unit = 'kJ/kg.K', description = 'cp of water'}
model.inputs.dtmin         = {default = 5, unit = 'oC', description = 'dt min of water'}
model.inputs.ht            = {default = 1, unit = 'kW/(m2K)', description = 'heat transfer coefficient of water'}
model.inputs.add_colds     = {default = 1, unit = '-', description = 'add to problem of cold streams'}
model.inputs.add_hots      = {default = 1, unit = '-', description = 'add to problem of hot streams'}
model.inputs.add_waste     = {default = 1, unit = '-', description = 'add to problem of waste streams'}
model.inputs.add_water     = {default = 1, unit = '-', description = 'add to problem of water streams'}
-----------------------------------------------------------------------------------------------------------------------
model.outputs = {}
-----------------------------------------------------------------------------------------------------------------------
--model:addLayers {water  = {type = 'MassBalanceQuality', unit = 'kg/s'}}
--model:addLayers {heat   = {type ='HeatCascade', unit ='kW'}}
-----------------------------------------------------------------------------------------------------------------------
model:addUnit ("gl_cooler", {type = 'Process', DisplayName = '', addToProblem  = 'add_hots'})
model["gl_cooler"]:addStreams {h = qt {tin = 93,  hin = 400/60*4.2*(33-20), tout = 30, hout = 0, dtmin = 5, alpha = 1, HC = 'heat'}}


model:addUnit ("d_pressure_filter_disc", {type = 'SOWE', DisplayName = '-', addToProblem  = 'add_water', Fmin = 1, Fmax = 1,
  ['SOWE'] = { water = {cp = 'cp_water', dtmin = 'dtmin', ht_coeff = 'ht', HClayer = 'heat', fmin = 0.05}}
})

model["d_pressure_filter_disc"]:addStreams {d = msq ({'water', 'in', 6.7, 1, {temp = {60,1}, rm1 = {0,1}} })}

model:addUnit ("d_vacuum_pump", {type = 'Process', DisplayName = 'demand of vacuum pump in recaust', addToProblem  = 'add_water', Fmin = 1, Fmax = 1})
model:addUnit ("s_vacuum_pump", {type = 'SOWE', DisplayName = 'source of vacuum pump in recaust', addToProblem  = 'add_water', Fmin = 1, Fmax = 1,
  ['SOWE'] = { water = {cp = 'cp_water', dtmin = 'dtmin', ht_coeff = 'ht', HClayer = 'heat', fmin = 0.05}}
  })
model:addUnit ("d_bearing_cooler", {type = 'Process', DisplayName = 'demand of bearing cooler in recaust', addToProblem  = 'add_water', Fmin = 1, Fmax = 1})
model:addUnit ("s_bearing_cooler", {type = 'Process', DisplayName = 'source of bearing cooler in recaust', addToProblem  = 'add_water', Fmin = 1, Fmax = 1})

model["d_vacuum_pump"]:addStreams {d = msq ({'water', 'in', 16.7, 1, {temp = {20,1}, rm1 = {1,1}} })}
model["s_vacuum_pump"]:addStreams {s = msq ({'water', 'out', 16.7, 1, {temp = {36,1}, rm1 = {1,1}} })}
model["d_bearing_cooler"]:addStreams {d = msq ({'water', 'in', 385/4.2/11, 1, {temp = {20,1}, rm1 = {1,1}} })}
model["s_bearing_cooler"]:addStreams {s = msq ({'water', 'out', 385/4.2/11, 1, {temp = {31,1}, rm1 = {1,1}} })}

model:addUnit ("s_cont_cond", {type = 'SOWE', DisplayName = '-', addToProblem  = 'add_water', Fmin = 1, Fmax = 1,
  ['SOWE'] = { water = {cp = 'cp_water', dtmin = 'dtmin', ht_coeff = 'ht', HClayer = 'heat', fmin = 0.05}}
})

model["s_cont_cond"]:addStreams {s = msq ({'water', 'out', 22, 1, {temp = {85,1}, rmcldg_lrc_rc_s_vacuum_pump1 = {0,1}} })}
-----------------------------------------------------------------------------------------------------------------------
return model