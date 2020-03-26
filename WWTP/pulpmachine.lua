--[[-------------------------------------------------------------------------------------------------------------------
# TB CASE STUDY (PULP MACHINE SECTION)

# REFERENCE
  Kermani, M., Périn-Levasseur, Z., Benali, M., Savulescu, L., Maréchal, F., 2017. A novel MILP approach for simultaneous optimization of water and energy: Application to a Canadian softwood Kraft pulping mill. Computers & Chemical Engineering. doi:10.1016/j.compchemeng.2016.11.043
  + PhD thesis
--]]-------------------------------------------------------------------------------------------------------------------
--
local osmose  = require 'osmose'
local model   = osmose.Model 'pulpmachine'
local cp      = require 'coolprop'
local layers  = require 'ET.pulp.layers'
setmetatable(model.layers,layers.layers_metatable)
-----------------------------------------------------------------------------------------------------------------------
--model.software = {'Ecoinvent'}
-----------------------------------------------------------------------------------------------------------------------
model.Class = {Group = 'process', Type = 'pulp&paper', SubType = 'pulp machine of pulp'}
-----------------------------------------------------------------------------------------------------------------------
model.Tagging = {TagName = 'pulpmachine', DisplayName = 'pulpmachine', Description = 'pulpmachine'}
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
model:addUnit ("wash_water_heater",   {type = 'Process', DisplayName = 'wash water heater', addToProblem  = 'add_colds'})
model:addUnit ("dryer",               {type = 'Process', DisplayName = 'flakt dryer', addToProblem  = 'add_colds'})
model:addUnit ("room_air_preheater",  {type = 'Process', DisplayName = 'room air preheater', addToProblem  = 'add_colds'})
model:addUnit ("dryer_exhaust",       {type = 'Process', DisplayName = 'dryer exhaust chimney', addToProblem  = 'add_hots'})
model:addUnit ("waste_dryer_exhaust", {type = 'Utility',  Fmin = 0.05, Fmax = 1, DisplayName = 'waste dryer exhaust', addToProblem = 'add_waste'})


model["wash_water_heater"]:addStreams   {c = qt {tin = 66,  hin = 0,    tout = 88,   hout = 1640,   dtmin = 5, alpha = 1, HC = 'heat'}}
model["dryer"]:addStreams               {c = qt {tin = 42,  hin = 0,    tout = 95,   hout = 26510,  dtmin = 3, alpha = 1, HC = 'heat'}}
model["room_air_preheater"]:addStreams  {c = qt {tin = 21,  hin = 0,    tout = 25,   hout = 210,    dtmin = 3, alpha = 1, HC = 'heat'}}
model["dryer_exhaust"]:addStreams       {h = qt {tin = 92,  hin = 4745, tout = 68,   hout = 0,      dtmin = 5, alpha = 1, HC = 'heat'}}
model["waste_dryer_exhaust"]:addStreams {h = qt {tin = 68,  hin = 9643, tout = 35,   hout = 0,      dtmin = 5, alpha = 1, HC = 'heat'}}



model:addUnit ("d_vacuum_pump", {type = 'Process', DisplayName = '-', addToProblem = 'add_water', Fmin = 1, Fmax = 1})
model:addUnit ("s_vacuum_pump", {type = 'Process', DisplayName = '-', addToProblem = 'add_water', Fmin = 1, Fmax = 1,
  ['SOWE'] = { water = {cp = 'cp_water', dtmin = 'dtmin', ht_coeff = 'ht', HClayer = 'heat', fmin = 0.05}}
})
model:addUnit ("d_pm_cooler", {type = 'Process', DisplayName = '-', addToProblem = 'add_water', Fmin = 1, Fmax = 1})
model:addUnit ("s_pm_cooler", {type = 'SOWE', DisplayName = '-', addToProblem = 'add_water', Fmin = 1, Fmax = 1,
  ['SOWE'] = { water = {cp = 'cp_water', dtmin = 'dtmin', ht_coeff = 'ht', HClayer = 'heat', fmin = 0.05}}
})
model:addUnit ("d_whw_chest", {type = 'Utility', DisplayName = '-', addToProblem = 'add_water', Fmin = 0, Fmax = 700})
model:addUnit ("s_whw_chest", {type = 'Utility', DisplayName = '-', addToProblem = 'add_water', Fmin = 0, Fmax = 700})
model:addUnit ("d_shower", {type = 'SOWE', DisplayName   = '-', addToProblem  = 'add_water', Fmin = 1, Fmax = 1,
  ['SOWE'] = { water = {cp = 'cp_water', dtmin = 'dtmin', ht_coeff = 'ht', HClayer = 'heat', fmin = 0.05}}
  })

model["d_vacuum_pump"]:addStreams {d = msq ({'water', 'in', 48, 1, {temp = {20,1}, rm1 = {1,1}} })}
model["s_vacuum_pump"]:addStreams {d = msq ({'water', 'out', 48, 1, {temp = {36,1}, rm1 = {1,1}} })}
model["d_pm_cooler"]:addStreams {d = msq ({'water', 'in',1605/4.2/16, 1, {temp = {20,1}, rm1 = {1,1}} })}
model["s_pm_cooler"]:addStreams {d = msq ({'water', 'out',1605/4.2/16, 1, {temp = {36,1}, rm1 = {1,1}} })}
model["d_whw_chest"]:addStreams {d = msq ({'water', 'in',1, 1, {temp = {69,1}, rm1 = {0,1}} })}
model["d_whw_chest"]:addStreams {q = qt   {tin = 69, hin = 0, tout = 71, hout = 8.4, dtmin = 5, alpha = 1, HC = 'heat'}}
model["s_whw_chest"]:addStreams {d = msq ({'water', 'out',1, 1, {temp = {71,1}, rm1 = {0,1}} })}
model["d_shower"]:addStreams {d = msq ({'water', 'in', 6.5, 1, {temp = {45,1}, rm1 = {1,1}} })}

model:addUnit ("d_recycled_whitewater", {type = 'SOWE', DisplayName = '-', addToProblem = 'add_water', Fmin = 1, Fmax = 1,
  ['SOWE'] = { water = {cp = 'cp_water', dtmin = 'dtmin', ht_coeff = 'ht', HClayer = 'heat', fmin = 0.05}}
  })

model:addUnit ("s_pulp_machine", {type = 'SOWE', DisplayName = '-', addToProblem = 'add_water', Fmin = 1, Fmax = 1,
  ['SOWE'] = { water = {cp = 'cp_water', dtmin = 'dtmin', ht_coeff = 'ht', HClayer = 'heat', fmin = 0.05}}
  })

model["d_recycled_whitewater"]:addStreams {d = msq ({'water', 'in', 578, 1, {temp = {71,1}, rm1 = {0,1}} })}
model["s_pulp_machine"]:addStreams {d = msq ({'water', 'out', 666, 1, {temp = {66,1}, rm1 = {0,1}} })}

local whw_addtoproblem = function(model)
  if model.objective.phrase == 'mer' or model.units.s_pulp_machine.faddToProblem(model) == 0 then
    --model.objective:lower():match('mer')
    return 0
  else
    return 1
  end
end


model:addEquations{['whw_connection'] = {statement = "{t in TIME}:\n\t Units_Mult_t[d_whw_chest,t] - Units_Mult_t[s_whw_chest,t] = 0;",type = 'ampl', addToProblem = whw_addtoproblem}}
-----------------------------------------------------------------------------------------------------------------------
return model