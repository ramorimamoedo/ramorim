--[[-------------------------------------------------------------------------------------------------------------------
# TB CASE STUDY (RECOVERY BOILER AND ITS FURNACE)

# REFERENCE
  Kermani, M., Périn-Levasseur, Z., Benali, M., Savulescu, L., Maréchal, F., 2017. A novel MILP approach for simultaneous optimization of water and energy: Application to a Canadian softwood Kraft pulping mill. Computers & Chemical Engineering. doi:10.1016/j.compchemeng.2016.11.043
  
  Vakkilainen, E., 2005. Kraft recovery boilers – Principles and practice. Suomen Soodakattilayhdistys r.y.
--]]-------------------------------------------------------------------------------------------------------------------
--
local osmose  = require 'osmose'
local model   = osmose.Model 'bark_boiler'
local cp      = require 'coolprop'
local layers  = require 'ET.pulp.layers'
setmetatable(model.layers,layers.layers_metatable)
-----------------------------------------------------------------------------------------------------------------------
--model.software = {'Ecoinvent'}
-----------------------------------------------------------------------------------------------------------------------
model.Class = {Group = 'recovery_boiler', Type = 'pulp&paper', SubType = 'bark_boiler of kraft pulp mill'}
-----------------------------------------------------------------------------------------------------------------------
model.Tagging = {TagName = 'bark_boiler', DisplayName = 'brak_boiler', Description = 'bark_boiler'}
-----------------------------------------------------------------------------------------------------------------------
model.author = {{Id = 1, Author = 'JULIA GRANACHER', Date = '08-JUL-2019', ChangeLog = ''}, {Id = 2, Author = 'JULIA GRANACHER', Date = '08-JUL-2019', ChangeLog = ''}}
-----------------------------------------------------------------------------------------------------------------------
model.values = {}
-----------------------------------------------------------------------------------------------------------------------
model.inputs.air_cp        = {default = 1.0336, unit = '-', description = ''}
model.inputs.cp_water      = {default = 4.2, unit = 'kJ/kg.K', description = 'cp of water'}
model.inputs.dtmin         = {default = 5, unit = 'oC', description = 'dt min of water'}
model.inputs.ht            = {default = 1, unit = 'kW/(m2K)', description = 'heat transfer coefficient of water'}
model.inputs.add_colds     = {default = 1, unit = '-', description = 'add to problem of cold streams'}
model.inputs.add_hots      = {default = 1, unit = '-', description = 'add to problem of hot streams'}
model.inputs.add_waste     = {default = 1, unit = '-', description = 'add to problem of waste streams'}
model.inputs.add_water     = {default = 1, unit = '-', description = 'add to problem of water streams'}
model.inputs.tchimney             = {default = 165, unit = 'C', description = 'flue gas out temperature'}-- changed (1)
model.inputs.efficiency           = {default = 0.91, unit = 'C', description = 'efficiency of bark boiler for steam production'} -- changed 
model.inputs.air_ratio            = {default = 7.3, unit = 'kg/kgds', description = 'air to fuel ratio'}-- changed (1)-^, related to dry bark 
model.inputs.air_tin              = {default = 32, unit = 'C', description = 'air inlet temperature'} -- not changed 
model.inputs.air_tout             = {default = 110, unit = 'C', description = 'air temperature preheated'} -- assumption that air is preheated in the same preheater --as for the recvery boiler 


model.inputs.bark_mf      = {default = 1, unit = 'kgds', description = '-'}
model.inputs.bark_lhv     = {default = 20000, unit = 'kJ/kgds', description = 'lhv with dry content'} -- changed 

-- assumed mass flow of bark: 67 000 kW / 20000 kJ/kgds/s = 3.35 kg/s dry bark = 6.7 kg /s with 50 % moisture content (Petterson & Harvey)
model.inputs.heat_available_steam = {default = 19865,  unit = 'kJ/kgds', description = 'after air preheating'}--set to dry mass flow lhv - q air preheating (20000- --135 kJ/kg dry bark) 
-- air flow rate: 1.2 * 
-- current flow of bark into furnace 850 [l/m] / 60 [m/s] * 0.8 [kg/l] *0.5 [water] = 8.5 kgds/s
model.inputs.tfurnace             = {default = 996, unit = 'C', description = 'furnace temperature'}-- from Pleshanov 
model.inputs.tadiabatic             = {default = 1500, unit = 'C', description = 'furnace temperature'}-- assumed to be tfurnance/0.6667 (Kermani)
model.inputs.furnace_fmin         = {default = 1, unit = 'C', description = ' '}
model.inputs.furnace_fmax         = {default = 1.675, unit = 'C', description = 'max-bau 1.675 kg/s'} -- mass flow of dry bark that determines the size of the furnance 
-----------------------------------------------------------------------------------------------------------------------



model.outputs.heat_available_tot  = {job = "heat_available_steam + (air_tout-air_tin)*air_cp*air_ratio", unit = 'kJ/kgds', description = 'before air preheating'}-- this is per kg bark
model.outputs.heat_rad            = {job = "heat_available_tot()*(tadiabatic-tfurnace)/(tadiabatic-tchimney)", unit = 'kJ/kgds', description = 'share of heat with constant temperature'}
model.outputs.heat_conv           = {job = "heat_available_tot()-heat_rad()", unit = 'kJ/kgds', description = "gliding heat"}
model.outputs.air_hout            = {job = "air_ratio*air_cp*(air_tout-air_tin)", unit = 'kJ/kgds', description = "gliding heat"}
model.outputs.bark_hout             = {job = "bark_heater_dh_nom/", unit = 'kJ/kgds', description = "gliding heat of black liquor heater"}
-----------------------------------------------------------------------------------------------------------------------
--model:addLayers {water  = {type = 'MassBalanceQuality', unit = 'kg/s'}}
--model:addLayers {heat   = {type ='HeatCascade', unit ='kW'}}
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
model:addUnit ("furnace", {type = 'Process', DisplayName = 'bark boiler furnace', addToProblem  = 1,Fmin = 'furnace_fmin', Fmax = 'furnace_fmax', Mult = 'furnace_fmax'})
model["furnace"]:addStreams {rad = qt {tin = 'tfurnace', hin = 'heat_rad',  tout = 'tfurnace', hout = 0,          dtmin = 5, alpha = 1, HC = 'heat'}}
model["furnace"]:addStreams {con = qt {tin = 'tfurnace', hin = 'heat_conv', tout = 'tchimney', hout = 0,          dtmin = 5, alpha = 1, HC = 'heat'}}
model["furnace"]:addStreams {air = qt {tin = 'air_tin',  hin = 0,           tout = 'air_tout', hout = 'air_hout', dtmin = 3, alpha = 1, HC = 'heat'}}
--model["furnace"]:addStreams {bark  = qt {tin = 'bark_heater_tin',  hin = 0, tout = 'bark_heater_tout', hout = 'bark_hout', dtmin = 3, alpha = 1, HC = 'heat'}} -- we assume no preheating of bark is happening 
-----------------------------------------------------------------------------------------------------------------------
model:addUnit ("surface_condenser",   {type = 'Process', DisplayName = 'air preheater of recovery boiler', addToProblem  = 'add_hots'})
model:addUnit ("d_fan_cooler",        {type = 'Process', DisplayName = '', addToProblem  = 'add_water'})
model:addUnit ("s_fan_cooler",        {type = 'SOWE', DisplayName = '', addToProblem  = 'add_water', Fmin = 1, Fmax = 1,
  ['SOWE'] = { water = {cp = 'cp_water', dtmin = 'dtmin', ht_coeff = 'ht', HClayer = 'heat', fmin = 0.05}}
})

model["surface_condenser"]:addStreams   {h = qt {tin = 89,  hin = 17472, tout = 89,   hout = 0, dtmin = 5, alpha = 1, HC = 'heat'}}
model["d_fan_cooler"]:addStreams {d = msq ({'water', 'in',1346/4.2/10, 1, {temp = {28,1}, rm1 = {1,1}} })}
model["s_fan_cooler"]:addStreams {d = msq ({'water', 'out',1346/4.2/10, 1, {temp = {38,1}, rm1 = {1,1}} })}

model:addUnit ("d_smelt_spout", {type = 'Process', DisplayName = '', addToProblem  = 'add_water', Fmin = 1, Fmax = 1})
model:addUnit ("s_smelt_spout", {type = 'SOWE', DisplayName = '', addToProblem  = 'add_water', Fmin = 1, Fmax = 1,
  ['SOWE'] = { water = {cp = 'cp_water', dtmin = 'dtmin', ht_coeff = 'ht', HClayer = 'heat', fmin = 0.05}}
})

model["d_smelt_spout"]:addStreams {d = msq ({'water', 'in', 16, 1, {temp = {28,1}, rm1 = {0,1}} })}
model["s_smelt_spout"]:addStreams {d = msq ({'water', 'out', 16, 1, {temp = {45,1}, rm1 = {0,1}} })}
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
-- RETURN OUTPUT
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
return model