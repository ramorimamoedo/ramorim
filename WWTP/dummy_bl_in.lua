
local osmose  = require 'osmose'
local model   = osmose.Model 'recovery_boiler'
local cp      = require 'coolprop'
local layers  = require 'ET.pulp.layers'
setmetatable(model.layers,layers.layers_metatable)

--model.software = {'VALI', 'ET/htg_exp_sel_noh2.bls'}-- (name of soft, name of model)

model:addUnit("Bl_dummy",{ type = "Utility"})
model["Bl_dummy"].Cost1 = 0
model["Bl_dummy"].Cost2 = 0
model["Bl_dummy"].Cinv1 = 0
model["Bl_dummy"].Cinv2 = 0
model["Bl_dummy"]:addStreams {
   black_liquor = ms({'black_liquor','in', 1 , AddToProblem=1}) -- xxx
   
}


return model