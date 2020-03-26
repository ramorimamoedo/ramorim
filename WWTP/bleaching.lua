--[[-------------------------------------------------------------------------------------------------------------------
# TB CASE STUDY (BLEACHING SECTION)

# REFERENCE
  Kermani, M., Périn-Levasseur, Z., Benali, M., Savulescu, L., Maréchal, F., 2017. A novel MILP approach for simultaneous optimization of water and energy: Application to a Canadian softwood Kraft pulping mill. Computers & Chemical Engineering. doi:10.1016/j.compchemeng.2016.11.043
  + PhD thesis
--]]-------------------------------------------------------------------------------------------------------------------
--
local osmose  = require 'osmose'
local model   = osmose.Model 'bleaching'
local cp      = require 'coolprop'
local layers  = require 'ET.pulp.layers'
setmetatable(model.layers,layers.layers_metatable)
-----------------------------------------------------------------------------------------------------------------------
--model.software = {'Ecoinvent'}
-----------------------------------------------------------------------------------------------------------------------
model.Class = {Group = 'process', Type = 'pulp&paper', SubType = 'bleaching of pulp'}
-----------------------------------------------------------------------------------------------------------------------
model.Tagging = {TagName = 'bleaching', DisplayName = 'bleaching', Description = 'bleaching'}
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
model:addUnit ("st_mixer_1", {type = 'Process', DisplayName = 'steam mixer 1, cold stream before T_20B in bleaching plant (SM_T20B)', addToProblem  = 'add_colds'})
model:addUnit ("st_mixer_2", {type = 'Process', DisplayName = 'steam mixer 2, cold stream before T_40B in bleaching plant (SM_T40B)', addToProblem  = 'add_colds'})
model:addUnit ("st_mixer_3", {type = 'Process', DisplayName = 'steam mixer 3, cold stream before T_50B in bleaching plant (SM_T50B)', addToProblem  = 'add_colds'})
model:addUnit ("pulp_heater",{type = 'Process', DisplayName = 'pulp heater', addToProblem  = 'add_colds'})
model:addUnit ("clo2_heater",{type = 'Process', DisplayName = 'clo2 heater', addToProblem  = 'add_colds'})
model:addUnit ("waste_base", {type = 'Utility', Fmin = 0.05, Fmax = 1, DisplayName = 'waste alkaline bleach effluent', addToProblem  = 'add_waste'})
model:addUnit ("waste_acid", {type = 'Utility', Fmin = 0.05, Fmax = 1, DisplayName = 'waste acidic bleach effluent', addToProblem  = 'add_waste'})

model["st_mixer_1"]:addStreams {c = qt {tin = 70, hin = 0,      tout = 75, hout = 1860, dtmin = 5, alpha = 1, HC = 'heat'}} -- '3' C6_SMT20B
model["st_mixer_2"]:addStreams {c = qt {tin = 72, hin = 0,      tout = 80, hout = 2630, dtmin = 5, alpha = 1, HC = 'heat'}} -- '3' C6_SMT30B
model["st_mixer_3"]:addStreams {c = qt {tin = 73, hin = 0,      tout = 87, hout = 3100, dtmin = 5, alpha = 1, HC = 'heat'}} -- '3' C6_SMT40B
model["clo2_heater"]:addStreams{c = qt {tin = 5,  hin = 0,      tout = 43, hout = 4183, dtmin = 3, alpha = 1, HC = 'heat'}} -- '3'
model["pulp_heater"]:addStreams{c = qt {tin = 75, hin = 0,      tout = 77, hout = 2520, dtmin = 5, alpha = 1, HC = 'heat'}} -- '3'
model["waste_base"]:addStreams {h = qt {tin = 82, hin = 14852,  tout = 35, hout = 0,    dtmin = 5, alpha = 1, HC = 'heat'}} -- '3' C6_SMT20B
model["waste_acid"]:addStreams {h = qt {tin = 71, hin = 11492,  tout = 35, hout = 0,    dtmin = 5, alpha = 1, HC = 'heat'}} -- '3' C6_SMT20B

model:addUnit ("d_bleaching", {type = 'SOWE', DisplayName = '-', addToProblem = 'add_water', Fmin = 1, Fmax = 1,
  ['SOWE'] = { water = {cp = 'cp_water', dtmin = 'dtmin', ht_coeff = 'ht', HClayer = 'heat', fmin = 0.05}}
  })
model["d_bleaching"]:addStreams {d = msq ({'water','in',69,1,{temp = {60,1}, rm1 = {0,1}} })}
-----------------------------------------------------------------------------------------------------------------------
return model