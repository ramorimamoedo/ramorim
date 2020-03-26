--[[-------------------------------------------------------------------------------------------------------------------
# TB CASE STUDY (EVAPORATOR and STRIPPING SECTION)

# REFERENCE
  Kermani, M., Périn-Levasseur, Z., Benali, M., Savulescu, L., Maréchal, F., 2017. A novel MILP approach for simultaneous optimization of water and energy: Application to a Canadian softwood Kraft pulping mill. Computers & Chemical Engineering. doi:10.1016/j.compchemeng.2016.11.043
  + PhD thesis
--]]-------------------------------------------------------------------------------------------------------------------
--
local osmose  = require 'osmose'
local model   = osmose.Model 'evaporator'
local cp      = require 'coolprop'
local layers  = require 'ET.pulp.layers'
setmetatable(model.layers,layers.layers_metatable)
-----------------------------------------------------------------------------------------------------------------------
--model.software = {'Ecoinvent'}
-----------------------------------------------------------------------------------------------------------------------
model.Class = {Group = 'process', Type = 'pulp&paper', SubType = 'evaporator and stripping of pulp'}
-----------------------------------------------------------------------------------------------------------------------
model.Tagging = {TagName = 'evaporator', DisplayName = 'evaporator', Description = 'evaporator'}
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
model.inputs.condenser_p   = {default = 1.9, unit = 'bar', description = 'pressure level of the condenser'}
model.inputs.condenser_m   = {default = 9.932, unit = 'kg/s', description = 'mass flow of the condenser - sum of 32968 and 3297'}
model.inputs.condenser_tout= {default = 30, unit = 'bar', description = 'pressure level of the condenser'}
model.inputs.reflux_p      = {default = 1, unit = 'bar', description = 'pressure level of the reflux'}
model.inputs.reflux_m      = {default = 1.983, unit = 'kg/s', description = 'mass flow of the reflux'}
model.inputs.reflux_tout   = {default = 81, unit = 'bar', description = 'pressure level of the reflux'}
-----------------------------------------------------------------------------------------------------------------------
model.outputs.condenser_t    = {job = function() return cp.PropsSI("T","P",condenser_p*100000,"Q",0,"Water") - 273 end, unit = 'oC', description = 'saturated temperature'}
model.outputs.condenser_hv   = {job = function() return cp.PropsSI("H","P",condenser_p*100000,"Q",1,"Water")/1000 end, unit = 'kJ/kg', description = 'vapor heat'}
model.outputs.condenser_hl   = {job = function() return cp.PropsSI("H","P",condenser_p*100000,"Q",0,"Water")/1000 end, unit = 'kJ/kg', description = 'liquid heat'}
model.outputs.condenser_ht   = {job = function() return cp.PropsSI("H","P",condenser_p*100000,"T",condenser_tout + 273,"Water")/1000 end, unit = 'kJ/kg', description = '-'}
model.outputs.condenser_hg   = {job = "condenser_m * (condenser_hv() - condenser_hl())", unit = 'kW', description = 'subcooling sensible heat'}
model.outputs.condenser_hsc  = {job = "condenser_m * (condenser_hl() - condenser_ht())", unit = 'kW', description = 'subcooling sensible heat'}
model.outputs.reflux_t       = {job = function() return cp.PropsSI("T","P",reflux_p*100000,"Q",0,"Water") - 273 end, unit = 'oC', description = 'saturated temperature'}
model.outputs.reflux_hv      = {job = function() return cp.PropsSI("H","P",reflux_p*100000,"Q",1,"Water")/1000 end, unit = 'kJ/kg', description = 'vapor heat'}
model.outputs.reflux_hl      = {job = function() return cp.PropsSI("H","P",reflux_p*100000,"Q",0,"Water")/1000 end, unit = 'kJ/kg', description = 'liquid heat'}
model.outputs.reflux_ht      = {job = function() return cp.PropsSI("H","P",reflux_p*100000,"T",reflux_tout + 273,"Water")/1000 end, unit = 'kJ/kg', description = '-'}
model.outputs.reflux_hg      = {job = "reflux_m * (reflux_hv() - reflux_hl())", unit = 'kW', description = 'subcooling sensible heat'}
model.outputs.reflux_hsc      = {job = "reflux_m * (reflux_hl() - reflux_ht())", unit = 'kW', description = 'subcooling sensible heat'}
-----------------------------------------------------------------------------------------------------------------------
--model:addLayers {water  = {type = 'ResourceBalanceQuality', unit = 'kg/s'}}
--model:addLayers {heat   = {type ='HeatCascade', unit ='kW'}}
-----------------------------------------------------------------------------------------------------------------------
model:addUnit ("evap_heater",      {type = 'Process', DisplayName = 'evaporator heater 1st effect', addToProblem  = 'add_colds'})
model:addUnit ("evap_condenser",   {type = 'Process', DisplayName = 'turpentine condenser',      addToProblem  = 'add_hots'})
model:addUnit ("waste_cond",       {type = 'Utility', DisplayName = 'waste combined condensate', addToProblem  = 'add_waste', Fmin = 0.05, Fmax = 1})
model:addUnit ("stripping_heater", {type = 'Process', DisplayName = 'stripping column heater', addToProblem  = 'add_colds'})
model:addUnit ("stripping_reflux", {type = 'Process', DisplayName = 'reflux condenser',      addToProblem  = 'add_hots'})

model["stripping_heater"]:addStreams {c =     qt {tin = 97, hin = 0, tout = 155, hout = 4457, dtmin = 5, alpha = 1, HC = 'heat'}}
model["stripping_reflux"]:addStreams {cond =  qt {tin = 'reflux_t', hin = 'reflux_hg',  tout = 'reflux_t',    hout = 0, dtmin = 3, alpha = 1, HC = 'heat'}}
model["stripping_reflux"]:addStreams {hsc =   qt {tin = 'reflux_t', hin = 'reflux_hsc', tout = 'reflux_tout', hout = 0, dtmin = 3, alpha = 1, HC = 'heat'}}
model["evap_heater"]:addStreams    {c =       qt {tin = 119, hin = 0, tout = 139, hout = 33390, dtmin = 5, alpha = 1, HC = 'heat'}}
model["evap_condenser"]:addStreams {cond =    qt {tin = 'condenser_t', hin = 'condenser_hg', tout = 'condenser_t', hout = 0, dtmin = 3, alpha = 1, HC = 'heat'}}
model["evap_condenser"]:addStreams {hsc =     qt {tin = 'condenser_t', hin = 'condenser_hsc', tout = 'condenser_tout', hout = 0, dtmin = 3, alpha = 1, HC = 'heat'}}
model["waste_cond"]:addStreams {h =           qt {tin = 89, hin = 4608, tout = 35, hout = 0, dtmin = 5, alpha = 1, HC = 'heat'}}
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
-- RETURN OUTPUT
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
return model