--[[-------------------------------------------------------------------------------------------------------------------
# TB CASE STUDY (WASHING SECTION)

# REFERENCE
  Kermani, M., Périn-Levasseur, Z., Benali, M., Savulescu, L., Maréchal, F., 2017. A novel MILP approach for simultaneous optimization of water and energy: Application to a Canadian softwood Kraft pulping mill. Computers & Chemical Engineering. doi:10.1016/j.compchemeng.2016.11.043
  + PhD thesis
--]]-------------------------------------------------------------------------------------------------------------------
--
local osmose  = require 'osmose'
local model   = osmose.Model 'washing'
local cp      = require 'coolprop'
local layers  = require 'ET.pulp.layers'
setmetatable(model.layers,layers.layers_metatable)
-----------------------------------------------------------------------------------------------------------------------
--model.software = {'Ecoinvent'}
-----------------------------------------------------------------------------------------------------------------------
model.Class = {Group = 'process', Type = 'pulp&paper', SubType = 'washing of pulp'}
-----------------------------------------------------------------------------------------------------------------------
model.Tagging = {TagName = 'washing', DisplayName = 'washing', Description = 'washing'}
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
model.inputs.fix_hen_cost  = {default = 8000, unit = '-', description = '-'}
model.inputs.var_hen_cost  = {default = 1200, unit = '-', description = '-'}
model.inputs.exp_hen_cost  = {default = 0.6, unit = '-', description = '-'}
-----------------------------------------------------------------------------------------------------------------------
model.outputs = {}
-----------------------------------------------------------------------------------------------------------------------
--model:addLayers {water  = {type = 'MassBalanceQuality', unit = 'kg/s'}}
--model:addLayers {heat   = {type ='HeatCascade', unit ='kW'}}
-----------------------------------------------------------------------------------------------------------------------
model:addUnit ("cold_blow_cooler", {type = 'Process', DisplayName = '-', addToProblem  = 'add_hots'})
model["cold_blow_cooler"]:addStreams {h = qt {tin = 77, hin = 2930, tout = 70, hout = 0, dtmin = 5, alpha = 1, HC = 'heat'}}

model:addUnit ("d_washing", {type = 'SOWE', DisplayName = '-', addToProblem = 'add_water', Fmin = 1, Fmax = 1,
  ['SOWE'] = { water = {cp = 'cp_water', dtmin = 'dtmin', ht_coeff = 'ht', HClayer = 'heat', fmin = 0.05}}
  })
model["d_washing"]:addStreams {d = msq ({'water','in',69,1,{temp = {60,1}, rm1 = {0,1}} })}

model:addUnit ("d_util_cooling", {type = 'Process', DisplayName = '-', addToProblem = 'add_water', Fmin = 1, Fmax = 1})
model["d_util_cooling"]:addStreams {d = msq ({'water','in',8000/60,1,{temp = {20,1}, rm1 = {1,1}} })}

model:addUnit ("s_util_cooling", {type = 'SOWE', DisplayName = '-', addToProblem = 'add_water', Fmin = 1, Fmax = 1,
  ['SOWE'] = { water = {cp = 'cp_water', dtmin = 'dtmin', ht_coeff = 'ht', HClayer = 'heat', fmin = 0.05}}
  })
model["s_util_cooling"]:addStreams {d = msq ({'water','out',8000/60,1,{temp = {26,1}, rm1 = {1,1}} })}
-----------------------------------------------------------------------------------------------------------------------
return model