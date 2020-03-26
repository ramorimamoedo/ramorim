--[[-------------------------------------------------------------------------------------------------------------------
# TB CASE STUDY (DIGESTER SECTION)

# REFERENCE
  Kermani, M., Périn-Levasseur, Z., Benali, M., Savulescu, L., Maréchal, F., 2017. A novel MILP approach for simultaneous optimization of water and energy: Application to a Canadian softwood Kraft pulping mill. Computers & Chemical Engineering. doi:10.1016/j.compchemeng.2016.11.043
  + PhD thesis
--]]-------------------------------------------------------------------------------------------------------------------
--
local osmose  = require 'osmose'
local model   = osmose.Model 'digester'
local cp      = require 'coolprop'
local layers  = require 'ET.pulp.layers'
setmetatable(model.layers,layers.layers_metatable)
-----------------------------------------------------------------------------------------------------------------------
--model.software = {'Ecoinvent'}
-----------------------------------------------------------------------------------------------------------------------
model.Class = {Group = 'process', Type = 'pulp&paper', SubType = 'digester of pulp'}
-----------------------------------------------------------------------------------------------------------------------
model.Tagging = {TagName = 'digester', DisplayName = 'digester', Description = 'digester'}
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
model.inputs.turpentine_p    = {default = 2.2, unit = 'bar', description = 'pressure level of the turpentine condenser'}
model.inputs.turpentine_m    = {default = 0.779, unit = 'kg/s', description = 'mass flow of the turpentine condenser'}
model.inputs.turpentine_tout = {default = 60, unit = 'bar', description = 'pressure level of the turpentine condenser'}
----model.inputs.chipbin_vent_p  = {default = 1, unit = 'bar', description = 'pressure level of the chib bin condenser'}
----model.inputs.chipbin_vent_m  = {default = 0.3451, unit = 'kg/s', description = 'mass flow of the chib bin condenser'}
-----------------------------------------------------------------------------------------------------------------------
model.outputs.turpentine_t    = {job = function() return cp.PropsSI("T","P",turpentine_p*100000,"Q",0,"Water") - 273 end, unit = 'oC', description = 'saturated temperature'}
model.outputs.turpentine_hv   = {job = function() return cp.PropsSI("H","P",turpentine_p*100000,"Q",1,"Water")/1000 end, unit = 'kJ/kg', description = 'vapor heat'}
model.outputs.turpentine_hl   = {job = function() return cp.PropsSI("H","P",turpentine_p*100000,"Q",0,"Water")/1000 end, unit = 'kJ/kg', description = 'liquid heat'}
model.outputs.turpentine_ht   = {job = function() return cp.PropsSI("H","P",turpentine_p*100000,"T",turpentine_tout + 273,"Water")/1000 end, unit = 'kJ/kg', description = '-'}
model.outputs.turpentine_hg   = {job = "turpentine_m * (turpentine_hv() - turpentine_hl())", unit = 'kW', description = 'subcooling sensible heat'}
model.outputs.turpentine_hsc  = {job = "turpentine_m * (turpentine_hl() - turpentine_ht())", unit = 'kW', description = 'subcooling sensible heat'}
-----------------------------------------------------------------------------------------------------------------------
--model:addLayers {water  = {type = 'MassBalanceQuality', unit = 'kg/s'}}
--model:addLayers {heat   = {type ='HeatCascade', unit ='kW'}}
-----------------------------------------------------------------------------------------------------------------------
model:addUnit ("chip_bin_preheater",  {type = 'Process', DisplayName = 'to warm up the chip bins at the beginning of the process', addToProblem  = 'add_colds'})
model:addUnit ("steaming_vessel",     {type = 'Process', DisplayName = 'steaming vessel', addToProblem  = 'add_colds'})
model:addUnit ("upper_liquor_heater", {type = 'Process', DisplayName = 'to heat up the liquor and recirculate it in the digester', addToProblem  = 'add_colds'})
model:addUnit ("lower_liquor_heater", {type = 'Process', DisplayName = 'to heat up the liquor and recirculate it in the digester', addToProblem  = 'add_colds'})
model:addUnit ("washer_liquor_heater",{type = 'Process', DisplayName = 'to heat up the liquor and recirculate it in the digester', addToProblem  = 'add_colds'})
model:addUnit ("black_liquor_flash1", {type = 'Process', DisplayName = 'black liquor flash tank 1 after digester', addToProblem  = 'add_hots'}) -- 'utility'
model:addUnit ("black_liquor_flash2", {type = 'Process', DisplayName = 'black liquor flash tank 2 after digester', addToProblem  = 'add_hots'}) -- in MATLAB 'utility'
model:addUnit ("turpentine",          {type = 'Process', DisplayName = 'turpentine condenser', addToProblem  = 'add_hots'})

model["chip_bin_preheater"]:addStreams    {c = qt {tin = 20,  hin = 0,    tout = 55,    hout = 3290,  dtmin = 3, alpha = 1, HC = 'heat'}}
model["steaming_vessel"]:addStreams       {c = qt {tin = 55,  hin = 0,    tout = 123,   hout = 13583, dtmin = 5, alpha = 1, HC = 'heat'}}
model["upper_liquor_heater"]:addStreams   {c = qt {tin = 122, hin = 0,    tout = 150,   hout = 4810,  dtmin = 5, alpha = 1, HC = 'heat'}}
model["lower_liquor_heater"]:addStreams   {c = qt {tin = 146, hin = 0,    tout = 160,   hout = 5750,  dtmin = 5, alpha = 1, HC = 'heat'}}
model["washer_liquor_heater"]:addStreams  {c = qt {tin = 126, hin = 0,    tout = 165,   hout = 4060,  dtmin = 5, alpha = 1, HC = 'heat'}}
model["black_liquor_flash1"]:addStreams   {h = qt {tin = 128, hin = 5350, tout = 128,   hout = 0,     dtmin = 3, alpha = 1, HC = 'heat'}}
model["black_liquor_flash2"]:addStreams   {h = qt {tin = 93,  hin = 9960, tout = 93,    hout = 0,     dtmin = 3, alpha = 1, HC = 'heat'}}
model["turpentine"]:addStreams            {cond = qt {tin = 'turpentine_t', hin = 'turpentine_hg',   tout = 'turpentine_t',     hout = 0, dtmin = 3, alpha = 1, HC = 'heat'}}
model["turpentine"]:addStreams            {hsc  = qt {tin = 'turpentine_t', hin = 'turpentine_hsc',  tout = 'turpentine_tout',  hout = 0, dtmin = 3, alpha = 1, HC = 'heat'}}
model["black_liquor_flash2"]:addStreams { ms({'black_liquor','out', 54.21  , AddToProblem=1})} -- Julia: added  to combine with hTG model

model:addUnit ("d_chipbin_vent", {type = 'Process', DisplayName = '-', addToProblem = 'add_water', Fmin = 1, Fmax = 1})
model["d_chipbin_vent"]:addStreams {d = msq ({'water','in',3.7,1,{temp = {20,1}, rm1 = {1,1}} }) }

model:addUnit ("s_chipbin_vent", {type = 'SOWE', DisplayName = '-', addToProblem = 'add_water', Fmin = 1, Fmax = 1,
  ['SOWE'] = { water = {cp = 'cp_water', dtmin = 'dtmin', ht_coeff = 'ht', HClayer = 'heat', fmin = 0.05}}
  })
model["s_chipbin_vent"]:addStreams {d = msq ({'water','out',3.7,1,{temp = {60,1}, rm1 = {1,1}} })}
-----------------------------------------------------------------------------------------------------------------------
return model