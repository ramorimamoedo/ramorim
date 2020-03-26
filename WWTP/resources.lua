--[[-------------------------------------------------------------------------------------------------------------------
# TB CASE STUDY (WATER SECTION)

# REFERENCE
Kermani, M., Prin-Levasseur, Z., Benali, M., Savulescu, L., Marchal, F., 2017. A novel MILP approach for simultaneous optimization of water and energy: Application to a Canadian softwood Kraft pulping mill. Computers & Chemical Engineering. doi:10.1016/j.compchemeng.2016.11.043
+ PhD thesis
--]]-------------------------------------------------------------------------------------------------------------------
--
local osmose  = require 'osmose'
local model   = osmose.Model 'water'
local cp      = require 'coolprop'
local layers  = require 'ET.pulp.layers'
setmetatable(model.layers,layers.layers_metatable)
-----------------------------------------------------------------------------------------------------------------------
--model.software = {'Ecoinvent'}
-----------------------------------------------------------------------------------------------------------------------
model.Class = {Group = 'process', Type = 'pulp&paper', SubType = 'water'}
-----------------------------------------------------------------------------------------------------------------------
model.Tagging = {TagName = 'water', DisplayName = 'water', Description = 'water'}
-----------------------------------------------------------------------------------------------------------------------
model.author = {{Id = 1, Author = 'MAZIAR KERMANI', Date = '10-FEB-2016', ChangeLog = ''}, {Id = 2, Author = 'MAZIAR KERMANI', Date = '23-MAR-2018', ChangeLog = 'check'}}
-----------------------------------------------------------------------------------------------------------------------
model.values = {}
-----------------------------------------------------------------------------------------------------------------------
model.inputs.cp_water   = {default = 4.2, unit = 'kJ/kg.K', description = 'cp of water'}
model.inputs.dtmin      = {default = 5, unit = 'oC', description = 'dt min of water'}
model.inputs.ht         = {default = 1, unit = 'kW/(m2K)', description = 'heat transfer coefficient of water'}
model.inputs.add_colds  = {default = 1, unit = '-', description = 'add to problem of cold streams'}
model.inputs.add_hots   = {default = 1, unit = '-', description = 'add to problem of hot streams'}
model.inputs.add_waste  = {default = 1, unit = '-', description = 'add to problem of waste streams'}
model.inputs.add_water  = {default = 1, unit = '-', description = 'add to problem of water streams'}
model.inputs.price_fw   = {default = 0.375/1000*3600, unit = 'USD/kg', description = ''}
model.inputs.price_el   = {default =  -0.081667  , unit = 'USD/kWh', description = ''}
--model.inputs.price_el_buy   = {default = 0.08, unit = 'USD/kWh', description = ''

model.inputs.fw_fmax    = {default = 820, unit = 'kg/s', description = ''}
model.inputs.ww_fmax    = {default = 820, unit = 'kg/s', description = ''}
model.inputs.capex      = {default = 1, unit = '-', description = 'effect of capex on opex'}
-----------------------------------------------------------------------------------------------------------------------
model.outputs = {}
-----------------------------------------------------------------------------------------------------------------------
--model:addLayers {fw  = {type = 'ResourceBalance', unit = 'kg/s'}}
--model:addLayers {ww  = {type = 'ResourceBalance', unit = 'kg/s'}}
--model:addLayers {electricity  = {type = 'ResourceBalance', unit = 'kg/s'}}
--model:addLayers {heat   = {type ='HeatCascade', unit ='kW'}}
-----------------------------------------------------------------------------------------------------------------------
-- electricity

-----------------------------------------------------------------------------------------------------------------------
model:addUnit("elec_sell", {type = 'Utility', Description = 'electricity grid', addToProblem = 1, Fmin = 0, Fmax = 10000000, Cost2 = 'price_el'})
model["elec_sell"]:addStreams {sell = rs ({'electricity', 'in', 1})}



--model:addUnit("elec_buy", {type = 'Utility', Description = 'electricity grid', addToProblem = 1, Fmin = 0, Fmax = 100000, Cost2 = 'price_el_buy'})
--model["elec_buy"]:addStreams {sell = ms ({'electricity', 'out', 1})} --Julia


-----------------------------------------------------------------------------------------------------------------------
-- electricity demand 25.1 MW ~ 550 kWh/adt BREF
-----------------------------------------------------------------------------------------------------------------------
model:addUnit("elec_demand", {type = 'Process', Description = 'electricity demand', addToProblem = 1})
model["elec_demand"]:addStreams {sell = ms ({'electricity', 'in', 25100})}
-----------------------------------------------------------------------------------------------------------------------
-- fwsp

-----------------------------------------------------------------------------------------------------------------------
model:addUnit ("fwmain", {type = 'Utility', DisplayName = 'freshwater', addToProblem = 'add_water', Fmin = 0, Fmax = 'fw_fmax', Cost2 = 'price_fw'})
model["fwmain"]:addStreams {o = ms  ({'fw', 'out', 1, 1})}
-----------------------------------------------------------------------------------------------------------------------
-- wwsp
-----------------------------------------------------------------------------------------------------------------------
model:addUnit ("wwmain", {type = 'Utility', DisplayName = 'wastewater', addToProblem = 'add_water', Fmin = 0, Fmax = 'ww_fmax'})
model["wwmain"]:addStreams {i = ms  ({'ww', 'in', 1, 1})}
-----------------------------------------------------------------------------------------------------------------------
model:addParameterData {capex_weight_factor = {value = 'capex'}}
-----------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------

return model
