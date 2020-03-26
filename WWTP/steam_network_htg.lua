--[[-------------------------------------------------------------------------------------------------------------------
# TB CASE STUDY (HTG steam delivery)

# REFERENCE
  Kermani, M., Périn-Levasseur, Z., Benali, M., Savulescu, L., Maréchal, F., 2017. A novel MILP approach for simultaneous optimization of water and energy: Application to a Canadian softwood Kraft pulping mill. Computers & Chemical Engineering. doi:10.1016/j.compchemeng.2016.11.043
  
  Vakkilainen, E., 2005. Kraft recovery boilers – Principles and practice. Suomen Soodakattilayhdistys r.y.
--]]-------------------------------------------------------------------------------------------------------------------
--
local osmose  = require 'osmose'
local model   = osmose.Model 'recovery_boiler_steam'
local layers  = require 'ET.pulp.layers'
setmetatable(model.layers,layers.layers_metatable)
-----------------------------------------------------------------------------------------------------------------------
model.superstructure = 'steamnetwork_sowe'
-----------------------------------------------------------------------------------------------------------------------
model.Class = {Group = 'htg', Type = 'pulp&paper', SubType = 'htg steam generator of htg'}
-----------------------------------------------------------------------------------------------------------------------
model.Tagging = {TagName = 'htg_steam', DisplayName = 'htg_steam', Description = 'htg_steam'}
-----------------------------------------------------------------------------------------------------------------------
model.author = {{Id = 1, Author = 'MAZIAR KERMANI', Date = '23-MAR-2018', ChangeLog = 'first version'}} -- edited by Julia in 1/2019
-----------------------------------------------------------------------------------------------------------------------
model.values = {}
-----------------------------------------------------------------------------------------------------------------------
model.inputs.fluidname            = {default = 'water', unit = '-', description ='fluidname'}
-----------------------------------------------------------------------------------------------------------------------
model.inputs.addp01               = {default = 1, unit = '-', description ='addtoproblem of level 1 of pressure'}
model.inputs.addp02               = {default = 1, unit = '-', description ='addtoproblem of level 2 of pressure'}
model.inputs.addp03               = {default = 1, unit = '-', description ='addtoproblem of level 3 of pressure'}
model.inputs.addp04               = {default = 1, unit = '-', description ='addtoproblem of level 4 of pressure'}
-----------------------------------------------------------------------------------------------------------------------
model.inputs.p01                  = {default = 58.7, unit = 'bar', description ='hp'}
model.inputs.p02                  = {default = 12, unit = 'bar', description ='mp'}
model.inputs.p03                  = {default = 5.2, unit = 'bar', description ='lp'}
model.inputs.p04                  = {default = 1, unit = 'bar', description ='cond'}
-----------------------------------------------------------------------------------------------------------------------
model.inputs.turb01               = {default = 1, unit = '-', description ='is the 1st level a turbine inlet'}
model.inputs.turb02               = {default = 0, unit = '-', description ='is the 2nd level a turbine inlet'}
model.inputs.turb03               = {default = 0, unit = '-', description ='is the 3rd level a turbine inlet'}
model.inputs.turb04               = {default = 0, unit = '-', description ='is the 3rd level a turbine inlet'}
-----------------------------------------------------------------------------------------------------------------------
model.inputs.steam01              = {default = 1, unit = '-', description ='is the 1st level a steam prodcution'}
model.inputs.steam02              = {default = 0, unit = '-', description ='is the 2nd level a steam prodcution'}
model.inputs.steam03              = {default = 0, unit = '-', description ='is the 3rd level a steam prodcution'}
model.inputs.steam04              = {default = 0, unit = '-', description ='is the 3rd level a steam prodcution'}
-----------------------------------------------------------------------------------------------------------------------
model.inputs.supdT01              = {default = 2500, unit = 'C', description ='superheat at 1st level'} --Julia
model.inputs.supdT02              = {default = 1.01, unit = 'C', description ='superheat at 2nd level'}
model.inputs.supdT03              = {default = 1.01, unit = 'C', description ='superheat at 3rd level'}
model.inputs.supdT04              = {default = 1.01, unit = 'C', description ='superheat at 3rd level'}
-----------------------------------------------------------------------------------------------------------------------
model.inputs.rhdT01               = {default = 0,   unit = 'C', description ='reheat temperature relative to 1st level temperature'}
model.inputs.rhdT02               = {default = -1, unit = 'C', description ='reheat temperature relative to 1st level temperature'}
model.inputs.rhdT03               = {default = -1, unit = 'C', description ='reheat temperature relative to 1st level temperature'}
-----------------------------------------------------------------------------------------------------------------------
model.inputs.subcooldT            = {default = -1.01, unit = 'C', description ='subcooling in condensation level (lowest pressure level)'}
-----------------------------------------------------------------------------------------------------------------------
model.inputs.dT01                 = {default = 5, unit = 'C', description ='minimum approach temperature at vapour state'}
model.inputs.dT02                 = {default = 5, unit = 'C', description ='minimum approach temperature at liquid state'} 
model.inputs.dT03                 = {default = 5, unit = 'C', description ='minimum approach temperature at phasechange state'}
-----------------------------------------------------------------------------------------------------------------------
model.inputs.eff_backpr_turb      = {default = 0.8, unit = '-', description ='efficiency of back pressure turbine'}
model.inputs.eff_cond_turb        = {default = 0.8, unit = '-', description ='efficiency of condesation turbine'}   
model.inputs.eff_pump             = {default = 0.65, unit = '-', description ='efficiency of pump'}
-----------------------------------------------------------------------------------------------------------------------
model.inputs.fmin_pump            = {default = 0, unit = '-', description ='size'}
model.inputs.fmax_pump            = {default = 4000, unit = '-', description ='size'} --400 Julia
model.inputs.fmin_header          = {default = 0, unit = '-', description ='size'}
model.inputs.fmax_header          = {default = 500, unit = '-', description ='size'} -- 50 Julia
model.inputs.fmin_drawoff         = {default = 0, unit = '-', description ='size'}
model.inputs.fmax_drawoff         = {default = 500, unit = '-', description ='size'} -- 500 Julia
model.inputs.fmin_td              = {default = 0, unit = '-', description ='size'}
model.inputs.fmax_td              = {default = 200000, unit = '-', description ='size'} -- 20000 Julia
model.inputs.fmin_trh             = {default = 0, unit = '-', description ='size'}
model.inputs.fmax_trh             = {default = 1000000, unit = '-', description ='size'} -- 10000 Julia
model.inputs.fmin_text            = {default = 0, unit = '-', description ='size'}
model.inputs.fmax_text            = {default = 70000, unit = '-', description ='size'} -- 7000 Julia 
-----------------------------------------------------------------------------------------------------------------------
--model:addLayers {water  = {type = 'ResourceBalanceQuality', unit = 'kg/s'}}
--model:addLayers {heat   = {type ='HeatCascade', unit ='kW'}}
--model:addLayers {electricity  = {type = 'ResourceBalance', unit = 'kg/s'}}
-----------------------------------------------------------------------------------------------------------------------
model:addSteamNetwork  {
  base            = 'sowe',
  database        = 'coolprop',
  addtoproblem    = {'addp01','addp02','addp03','addp04'},
  pressures 		  = {'p01','p02','p03','p04'},
  isturbine 		  = {'turb01','turb02','turb03','turb04'},
  issteam 		    = {'steam01','steam02','steam03','steam04'},
  superheatdT 	  = {'supdT01','supdT02','supdT03','supdT04'},
--  reheatdT        = {'rhdT01','rhdT02','rhdT03'},
  fmin            = {pump = 'fmin_pump', header = 'fmin_header', drawoff = 'fmin_drawoff', turbine_drawoff = 'fmin_td', turbine_reheat = 'fmin_trh', turbine_ext = 'fmin_text'},
  fmax            = {pump = 'fmax_pump', header = 'fmax_header', drawoff = 'fmax_drawoff', turbine_drawoff = 'fmax_td', turbine_reheat = 'fmax_trh', turbine_ext = 'fmax_text'},
--  inv1            = {turbine = 0, pump = 0},
--  inv2            = {turbine = 1650*0.23, pump = 1650*0.23},
--  inv2            = {turbine = 0, pump = 0},
--  inv1            = {turbine = 39022*537.5/389.5}, -- 
--  inv2            = {turbine = 8224.6*537.5/389.5/1000}, -- 
  subcooldT 		  = 'subcooldT',
  dT 				      = {gas = 'dT01', liquid = 'dT02', phasechange = 'dT03', global = 'dT02'},
  eff_backpr_turb	= 'eff_backpr_turb',
  eff_cond_turb 	= 'eff_cond_turb',
  eff_pump 		    = 'eff_pump',
  fluid			      = 'fluidname',
  options         = {add_ext_turbine = 0, pl_envelope = 0},
--  htc             = {gas = 0.06, liquid = 0.56, condensing = 1.6, vaporising = 3.6},
  layerofelec 	  = 'electricity',
  layerofheat     = 'heat',
  layerstype      = {electricity = 'ResourceBalance', pressure = 'ResourceBalanceQuality', drawoff = 'ResourceBalance', condensate = 'MassBalance', makeup = 'ResourceBalance'},
  layerofdrawoff  = {'dp01','dp02','dp03','dp04'},
}

return model