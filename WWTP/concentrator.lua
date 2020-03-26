--[[-------------------------------------------------------------------------------------------------------------------
# TB CASE STUDY (CONCENTRATOR SECTION)

# REFERENCE
  Kermani, M., Périn-Levasseur, Z., Benali, M., Savulescu, L., Maréchal, F., 2017. A novel MILP approach for simultaneous optimization of water and energy: Application to a Canadian softwood Kraft pulping mill. Computers & Chemical Engineering. doi:10.1016/j.compchemeng.2016.11.043
  + PhD thesis
--]]-------------------------------------------------------------------------------------------------------------------
--
local osmose  = require 'osmose'
local model   = osmose.Model 'concentrator'
local cp      = require 'coolprop'
local layers  = require 'ET.pulp.layers'
setmetatable(model.layers,layers.layers_metatable)
-----------------------------------------------------------------------------------------------------------------------
--model.software = {'Ecoinvent'}
-----------------------------------------------------------------------------------------------------------------------
model.Class = {Group = 'process', Type = 'pulp&paper', SubType = 'concentrator of pulp'}
-----------------------------------------------------------------------------------------------------------------------
model.Tagging = {TagName = 'concentrator', DisplayName = 'concentrator', Description = 'concentrator'}
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
model.inputs.condenser_p   = {default = 0.25, unit = 'bar', description = 'pressure level of the condenser'}
model.inputs.condenser_m   = {default = 4.628, unit = 'kg/s', description = 'mass flow of the condenser'}
-----------------------------------------------------------------------------------------------------------------------
model.outputs.condenser_t    = {job = function() return cp.PropsSI("T","P",condenser_p*100000,"Q",0,"Water") - 273 end, unit = 'oC', description = 'saturated temperature'}
model.outputs.condenser_hv   = {job = function() return cp.PropsSI("H","P",condenser_p*100000,"Q",1,"Water")/1000 end, unit = 'kJ/kg', description = 'vapor heat'}
model.outputs.condenser_hl   = {job = function() return cp.PropsSI("H","P",condenser_p*100000,"Q",0,"Water")/1000 end, unit = 'kJ/kg', description = 'liquid heat'}
model.outputs.condenser_hg   = {job = "condenser_m * (condenser_hv() - condenser_hl())", unit = 'kW', description = 'subcooling sensible heat'}
-----------------------------------------------------------------------------------------------------------------------
--model:addLayers {water  = {type = 'ResourceBalanceQuality', unit = 'kg/s'}}
--model:addLayers {heat   = {type ='HeatCascade', unit ='kW'}}
-----------------------------------------------------------------------------------------------------------------------
model:addUnit ("heater", {type = 'Process', DisplayName = 'concentrator heater 1st effect', addToProblem  = 'add_colds'})
model:addUnit ("fhd",    {type = 'Process', DisplayName = 'condenser', addToProblem  = 'add_hots'})

model["heater"]:addStreams{c = qt {tin = 106,  hin = 0, tout = 111, hout = 16220, dtmin = 5, alpha = 1, HC = 'heat'}}
model["fhd"]:addStreams   {h = qt {tin = 'condenser_t', hin = 'condenser_hg', tout = 'condenser_t', hout = 0, dtmin = 3, alpha = 1, HC = 'heat'}}
-----------------------------------------------------------------------------------------------------------------------
return model