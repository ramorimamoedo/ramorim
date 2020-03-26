--[[------------------------------------------------------
# ORC (Organic Rankine Cycle)
--]]------------------------------------------------------

local osmose  = require 'lib.osmose'
local ET      = osmose.Model 'orc_ET'
local layers  = require 'ET.pulp.layers'
setmetatable(ET.layers,layers.layers_metatable)
------------------------------------------------------------------------------------------
ET.superstructure = 'steamnetwork_sowe'
------------------------------------------------------------------------------------------
ET.inputs.addp01    = {default = 1, unit = '-', description ='addtoproblem of level 1 of pressure'}
ET.inputs.addp02    = {default = 1, unit = '-', description ='addtoproblem of level 2 of pressure'}
ET.inputs.addp03    = {default = 1, unit = '-', description ='addtoproblem of level 3 of pressure'}
ET.inputs.addp04    = {default = 1, unit = '-', description ='addtoproblem of level 4 of pressure'}
------------------------------------------------------------------------------------------
ET.inputs.fluidname = {default = 'Ammonia', unit = 'bar', description ='1st level of pressure'}
------------------------------------------------------------------------------------------
ET.inputs.p01    = {default = 50, unit = 'bar', description ='1st level of pressure'}
ET.inputs.p02    = {default = 25, unit = 'bar', description ='2nd level of pressure'}
ET.inputs.p03    = {default = 9.793, unit = 'bar', description ='3rd level of pressure'}
ET.inputs.p04    = {default = 1, unit = 'bar', description ='3rd level of pressure'}
------------------------------------------------------------------------------------------
ET.inputs.turb01 = {default = 1, unit = '-', description ='is the 1st level a turbine inlet'}
ET.inputs.turb02 = {default = 1, unit = '-', description ='is the 2nd level a turbine inlet'}
ET.inputs.turb03 = {default = 1, unit = '-', description ='is the 3rd level a turbine inlet'}
ET.inputs.turb04 = {default = 0, unit = '-', description ='is the 3rd level a turbine inlet'}
------------------------------------------------------------------------------------------
ET.inputs.steam01  = {default = 1, unit = '-', description ='is the 1st level a steam prodcution'}
ET.inputs.steam02  = {default = 1, unit = '-', description ='is the 2nd level a steam prodcution'}
ET.inputs.steam03  = {default = 1, unit = '-', description ='is the 3rd level a steam prodcution'}
ET.inputs.steam04  = {default = 0, unit = '-', description ='is the 3rd level a steam prodcution'}
------------------------------------------------------------------------------------------
ET.inputs.supdT01  = {default = 1.01, unit = 'C', description ='superheat at 1st level'}
ET.inputs.supdT02  = {default = 1.01, unit = 'C', description ='superheat at 2nd level'}
ET.inputs.supdT03  = {default = 1.01, unit = 'C', description ='superheat at 3rd level'}
ET.inputs.supdT04  = {default = 1.01, unit = 'C', description ='superheat at 3rd level'}
------------------------------------------------------------------------------------------
ET.inputs.rhdT01  = {default = 0,  unit = 'C', description ='reheat temperature relative to 1st level temperature'}
ET.inputs.rhdT02  = {default = -1, unit = 'C', description ='reheat temperature relative to 1st level temperature'}
ET.inputs.rhdT03  = {default = -5, unit = 'C', description ='reheat temperature relative to 1st level temperature'}
------------------------------------------------------------------------------------------
ET.inputs.subcooldT  = {default = -1.01, unit = 'C', description ='subcooling in condensation level (lowest pressure level)'}
------------------------------------------------------------------------------------------
ET.inputs.dT01  = {default = 5, unit = 'C', description ='minimum approach temperature at vapour state'}
ET.inputs.dT02  = {default = 5, unit = 'C', description ='minimum approach temperature at liquid state'} 
ET.inputs.dT03  = {default = 5, unit = 'C', description ='minimum approach temperature at phasechange state'}
------------------------------------------------------------------------------------------
ET.inputs.eff_backpr_turb = {default = 0.8, unit = '-', description ='efficiency of back pressure turbine'}
ET.inputs.eff_cond_turb   = {default = 0.8, unit = '-', description ='efficiency of condesation turbine'}   
ET.inputs.eff_pump        = {default = 0.65, unit = '-', description ='efficiency of pump'}
------------------------------------------------------------------------------------------
ET.inputs.fmin_pump       = {default = 0, unit = '-', description ='size'}
ET.inputs.fmax_pump       = {default = 50, unit = '-', description ='size'}
ET.inputs.fmin_header     = {default = 0, unit = '-', description ='size'}
ET.inputs.fmax_header     = {default = 1, unit = '-', description ='size'}
ET.inputs.fmin_drawoff    = {default = 0, unit = '-', description ='size'}
ET.inputs.fmax_drawoff    = {default = 1, unit = '-', description ='size'}
ET.inputs.fmin_td         = {default = 0, unit = '-', description ='size'}
ET.inputs.fmax_td         = {default = 100, unit = '-', description ='size'}
ET.inputs.fmin_trh        = {default = 0, unit = '-', description ='size'}
ET.inputs.fmax_trh        = {default = 100, unit = '-', description ='size'}
ET.inputs.fmin_text       = {default = 0, unit = '-', description ='size'}
ET.inputs.fmax_text       = {default = 70, unit = '-', description ='size'}
------------------------------------------------------------------------------------------
ET:addSteamNetwork  {
  base            = 'sowe',
  database        = 'coolprop',
  addtoproblem    = {'addp01','addp02','addp03','addp04'},
  pressures 		  = {'p01','p02','p03','p04'},
  isturbine 		  = {'turb01','turb02','turb03','turb04'},
  issteam 		    = {'steam01','steam02','steam03','steam04'},
  superheatdT 	  = {'supdT01','supdT02','supdT03','supdT04'},
  reheatdT        = {nil,'rhdT02',nil},
  fmin            = {pump = 'fmin_pump', header = 'fmin_header', drawoff = 'fmin_drawoff', turbine_drawoff = 'fmin_td', turbine_reheat = 'fmin_trh', turbine_ext = 'fmin_text'},
  fmax            = {pump = 'fmax_pump', header = 'fmax_header', drawoff = 'fmax_drawoff', turbine_drawoff = 'fmax_td', turbine_reheat = 'fmax_trh', turbine_ext = 'fmax_text'},
--  inv1            = {turbine = 0, pump = 0},
--  inv2            = {turbine = 1650*0.23, pump = 1650*0.23},
--  inv2            = {turbine = 0, pump = 0},
  subcooldT 		  = 'subcooldT',
  dT 				      = {gas = 'dT01', liquid = 'dT02', phasechange = 'dT03', global = 'dT02'},
  eff_backpr_turb	= 'eff_backpr_turb',
  eff_cond_turb 	= 'eff_cond_turb',
  eff_pump 		    = 'eff_pump',
  fluid			      = 'fluidname',
  options         = {add_ext_turbine = 0, pl_envelope = 1},
--  htc             = {gas = 0.06, liquid = 0.56, condensing = 1.6, vaporising = 3.6},
  layerofelec 	  = 'electricity',
  layerofheat     = 'heat',
  layerstype      = {electricity = 'ResourceBalance', pressure = 'ResourceBalanceQuality', drawoff = 'ResourceBalance', condensate = 'MassBalance', makeup = 'ResourceBalance'},
  layerofdrawoff  = {'dp01','dp02','dp03','dp04'},
}

return ET