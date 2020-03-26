--[[-------------------------------------------------------------------------------------------------------------------
# TB CASE STUDY (LAYER MODEL)

# REFERENCE
  Kermani, M., Périn-Levasseur, Z., Benali, M., Savulescu, L., Maréchal, F., 2017. A novel MILP approach for simultaneous optimization of water and energy: Application to a Canadian softwood Kraft pulping mill. Computers & Chemical Engineering. doi:10.1016/j.compchemeng.2016.11.043
  + PhD thesis
--]]-------------------------------------------------------------------------------------------------------------------
--
local osmose  = require 'osmose'
local model   = osmose.Model 'layers'


model:addLayers {water        = {type = 'MassBalanceQuality', unit = 'kg/s'}}
--model:addLayers {water        = {type = 'ResourceBalanceQuality', unit = 'kg/s'}}
model:addLayers {heat         = {type = 'HeatCascade',            unit ='kW'}}
model:addLayers {heat_cu      = {type = 'HeatCascade',            unit ='kW'}}
model:addLayers {rww          = {type = 'ResourceBalance',        unit = 'kg/s'}}
model:addLayers {tww          = {type = 'ResourceBalance',        unit = 'kg/s'}}
model:addLayers {thw          = {type = 'ResourceBalance',        unit = 'kg/s'}}
model:addLayers {fw           = {type = 'ResourceBalance',        unit = 'kg/s'}}
model:addLayers {ww           = {type = 'ResourceBalance',        unit = 'kg/s'}}
model:addLayers {cu           = {type = 'ResourceBalance',        unit = 'kg/s'}}
model:addLayers {electricity  = {type = 'ResourceBalance',        unit = 'kW'}}

model:addLayers {black_liquor = {type = 'ResourceBalance',        unit = 'kg/s'} }

model:addLayers {cr_gas_4 = {type ='MassBalance', unit ='kg/s'}}
model:addLayers {grid_gas = {type ='MassBalance', unit ='kg/s'}}

-- INTERNAL LAYERS OF THIS MODEL
model:addLayers {exsel_lqph = {type ='MassBalance', unit ='kg/s'}}
model:addLayers {exsel_crude_gas = {type ='MassBalance', unit ='kg/s'}}
model:addLayers {exsel_gasph = {type ='MassBalance', unit ='kg/s'}}
model:addLayers {exsel_ofg1 = {type ='MassBalance', unit ='kg/s'}}
model:addLayers {exsel_ofg2 = {type ='MassBalance', unit ='kg/s'}}
model:addLayers {gas_ssep_noh2 = {type ='MassBalance', unit ='kW'} }
return model