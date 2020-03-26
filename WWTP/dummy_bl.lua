


local osmose  = require 'osmose'
local model   = osmose.Model 'Dummy'
local cp      = require 'coolprop'
local layers  = require 'ET.pulp.layers'
setmetatable(model.layers,layers.layers_metatable)



model:addUnit("Dummy_bl",{ type = "Process"})
model["Dummy_bl"].Cost1 = 0
model["Dummy_bl"].Cost2 = 0
model["Dummy_bl"].Cinv1 = 0
model["Dummy_bl"].Cinv2 = 0
model["Dummy_bl"]:addStreams {
   black_liquor = ms({'black_liquor','out',54.211, AddToProblem=1}) -- xx.assumed 80% moisture content 
}


return model