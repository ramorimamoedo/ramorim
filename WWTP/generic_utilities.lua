#!/usr/bin/lua
--[[------------------------------------------------------

# Cooking Mixing

The model class stores the elements of the energy technology
such as  *utility*, *stream* and *operational costs*.


TODO: 


--]]------------------------------------------------------

local osmose = require 'osmose'
local lib = osmose.Model 'generic_utilities'

local layers  = require 'ET.pulp.layers'
setmetatable(lib.layers,layers.layers_metatable)


-- ## Inlet Parameters  (isVIT = 1)
lib.inputs = {

price_el_buy = {default = 0.08, min=0, max=100000, unit = 'USD/kWh'},

-- turton book pg 235 ref cycle
COP_heatpump = {default =  7.981 ,min=0, max=100000, unit = ''},
refrigeration_ref= {default = 1, min=0, max=100000, unit = 'kW'},}

-- ## Result (isVIT = 2)
lib.outputs = { 

elec_refrig_unit_price = {unit = '$/h', job = "(price_el_buy)*(refrigeration_ref/COP_heatpump) " },
elec_req_refrigeration = {unit = 'kW', job = "(refrigeration_ref/COP_heatpump) " },}



-- lower temperature cooler
lib:addUnit("Refrigeration", {type = 'Utility'})
lib["Refrigeration"].Fmax = 10000000
lib["Refrigeration"].Fmin = 0
lib["Refrigeration"].Cost2 = 'elec_refrig_unit_price'
lib["Refrigeration"]:addStreams({refrig_stream = qt{5,0,5,'refrigeration_ref',4,1,1, HC='heat'}, --{tin, hin, tout, hout, deltaT}

elec_in_refrig = rs{'electricity', 'in', 'elec_req_refrigeration'}   

})


return lib

