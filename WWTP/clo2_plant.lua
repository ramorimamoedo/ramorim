--[[-------------------------------------------------------------------------------------------------------------------
# TB CASE STUDY (ClO2 SECTION)

# REFERENCE
  Kermani, M., Périn-Levasseur, Z., Benali, M., Savulescu, L., Maréchal, F., 2017. A novel MILP approach for simultaneous optimization of water and energy: Application to a Canadian softwood Kraft pulping mill. Computers & Chemical Engineering. doi:10.1016/j.compchemeng.2016.11.043
  + PhD thesis
--]]-------------------------------------------------------------------------------------------------------------------
--
local osmose  = require 'osmose'
local model   = osmose.Model 'clo2'
local cp      = require 'coolprop'
local layers  = require 'ET.pulp.layers'
setmetatable(model.layers,layers.layers_metatable)
-----------------------------------------------------------------------------------------------------------------------
--model.software = {'Ecoinvent'}
-----------------------------------------------------------------------------------------------------------------------
model.Class = {Group = 'clo2', Type = 'pulp&paper', SubType = 'clo2 of pulp'}
-----------------------------------------------------------------------------------------------------------------------
model.Tagging = {TagName = 'clo2', DisplayName = 'clo2', Description = 'clo2'}
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
model:addUnit ("clo2_heater",       {type = 'Process', DisplayName = 'clo2 heater', addToProblem  = 'add_colds'})
model["clo2_heater"]:addStreams       {c = qt {tin = 65, hin = 0, tout = 75, hout = 3170, dtmin = 3, alpha = 1, HC = 'heat'}}


model:addUnit ("d_clo2_absorption", {type = 'Process', DisplayName = 'demand of absorption tower in clo2 plant', addToProblem  = 'add_water', Fmin = 1, Fmax = 1})
model:addUnit ("d_clo2_shower",     {type = 'Process', DisplayName = 'demand of shower in clo2 plant', addToProblem = 'add_water', Fmin = 1, Fmax = 1})
model:addUnit ("d_clo2_icc",        {type = 'Process', DisplayName = 'demand of icc (indirect contanct cooler) in clo2 plant', addToProblem = 'add_water', Fmin = 1, Fmax = 1})
model:addUnit ("d_clo2_barom",      {type = 'Process', DisplayName = 'demand of barometric condenser in clo2 plant', addToProblem = 'add_water', Fmin = 1, Fmax = 1})

model["d_clo2_absorption"]:addStreams {d = msq ({'water','in',29.8,1,{temp = {20,1},rm1 = {1,1}} })}
model["d_clo2_shower"]:addStreams     {d = msq ({'water','in',6.7,1,{temp = {20,1},rm1 = {1,1}} })}
model["d_clo2_icc"]:addStreams        {d = msq ({'water','in',33.3,1,{temp = {20,1},rm1 = {1,1}} })}
model["d_clo2_barom"]:addStreams      {d = msq ({'water','in',16.5,1,{temp = {20,1},rm1 = {1,1}} })}
-----------------------------------------------------------------------------------------------------------------------
return model