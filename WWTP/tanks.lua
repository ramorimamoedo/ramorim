--[[-------------------------------------------------------------------------------------------------------------------
# TB CASE STUDY (TANKS SECTION)

# REFERENCE
  Kermani, M., Périn-Levasseur, Z., Benali, M., Savulescu, L., Maréchal, F., 2017. A novel MILP approach for simultaneous optimization of water and energy: Application to a Canadian softwood Kraft pulping mill. Computers & Chemical Engineering. doi:10.1016/j.compchemeng.2016.11.043
  + PhD thesis
--]]-------------------------------------------------------------------------------------------------------------------
--
local osmose  = require 'osmose'
local model   = osmose.Model 'tanks'
local cp      = require 'coolprop'
local layers  = require 'ET.pulp.layers'
setmetatable(model.layers,layers.layers_metatable)
-----------------------------------------------------------------------------------------------------------------------
--model.software = {'Ecoinvent'}
-----------------------------------------------------------------------------------------------------------------------
model.Class = {Group = 'process', Type = 'pulp&paper', SubType = 'water tanks of pulp'}
-----------------------------------------------------------------------------------------------------------------------
model.Tagging = {TagName = 'tanks', DisplayName = 'tanks', Description = 'tanks'}
-----------------------------------------------------------------------------------------------------------------------
model.author = {{Id = 1, Author = 'MAZIAR KERMANI', Date = '10-FEB-2016', ChangeLog = ''}, {Id = 2, Author = 'MAZIAR KERMANI', Date = '23-MAR-2018', ChangeLog = 'check'}}
-----------------------------------------------------------------------------------------------------------------------
model.values = {}
-----------------------------------------------------------------------------------------------------------------------
model.inputs.air_cp     = {default = 1.0336, unit = '-', description = ''}
model.inputs.cp_water   = {default = 4.2, unit = 'kJ/kg.K', description = 'cp of water'}
model.inputs.dtmin      = {default = 5, unit = 'oC', description = 'dt min of water'}
model.inputs.ht         = {default = 1, unit = 'kW/(m2K)', description = 'heat transfer coefficient of water'}
model.inputs.add_colds  = {default = 1, unit = '-', description = 'add to problem of cold streams'}
model.inputs.add_hots   = {default = 1, unit = '-', description = 'add to problem of hot streams'}
model.inputs.add_waste  = {default = 1, unit = '-', description = 'add to problem of waste streams'}
model.inputs.add_water  = {default = 1, unit = '-', description = 'add to problem of water streams'}
model.inputs.twwsp_t    = {default = 28, unit = '-', description = 'add to problem of hot streams'}
model.inputs.rwwsp_t    = {default = 52, unit = '-', description = 'add to problem of hot streams'}
model.inputs.thwsp_t    = {default = 60, unit = '-', description = 'add to problem of hot streams'}
model.inputs.fwsp_t     = {default = 20, unit = '-', description = 'add to problem of hot streams'}
model.inputs.wwsp_t     = {default = 30, unit = '-', description = 'add to problem of hot streams'}
model.inputs.fmax_tank  = {default = 350, unit = '-', description = 'size of tanks maximum'}
-----------------------------------------------------------------------------------------------------------------------
model.outputs = {}
-----------------------------------------------------------------------------------------------------------------------
--model:addLayers {water  = {type = 'MassBalanceQuality', unit = 'kg/s'}}
--model:addLayers {rww  = {type = 'ResourceBalance', unit = 'kg/s'}}
--model:addLayers {tww  = {type = 'ResourceBalance', unit = 'kg/s'}}
--model:addLayers {thw  = {type = 'ResourceBalance', unit = 'kg/s'}}
--model:addLayers {fw  = {type = 'ResourceBalance', unit = 'kg/s'}}
--model:addLayers {ww  = {type = 'ResourceBalance', unit = 'kg/s'}}
--model:addLayers {heat   = {type ='HeatCascade', unit ='kW'}}
-----------------------------------------------------------------------------------------------------------------------
-- twwsp
-----------------------------------------------------------------------------------------------------------------------
model:addUnit ("twwsp_d", {type = 'SOWE', DisplayName = 'treated warm water inlet', addToProblem = 'add_water', Fmin = 20, Fmax = 'fmax_tank', Cost2 = 0,
  ['SOWE'] = { water = {cp = 'cp_water', dtmin = 'dtmin', ht_coeff = 'ht', fmin = 2, HClayer = 'heat', tank = 'twwsp', T = {'twwsp_t'} } } })
model:addUnit ("twwsp_s", {type = 'SOWE', DisplayName = 'treated warm water outlet', addToProblem = 'add_water', Fmin = 20, Fmax = 'fmax_tank', Cost2 = 0,
  ['SOWE'] = { water = {cp = 'cp_water', dtmin = 'dtmin', ht_coeff = 'ht', fmin = 2, HClayer = 'heat', tank = 'twwsp'} } })

model["twwsp_d"]:addStreams {d = msq ({'water', 'in', 1, 1, {temp = {'twwsp_t',1}, rm1 = {1,1}} })}
model["twwsp_d"]:addStreams {c = ms  ({'tww', 'out', 1, 1})}

model["twwsp_s"]:addStreams {s = msq ({'water', 'out', 1, 1, {temp = {'twwsp_t',1}, rm1 = {1,1}} })}
model["twwsp_s"]:addStreams {c = ms  ({'tww', 'in', 1, 1})}
-----------------------------------------------------------------------------------------------------------------------
-- rwwsp
-----------------------------------------------------------------------------------------------------------------------
model:addUnit ("rwwsp_d", {type = 'SOWE', DisplayName = 'raw warm water inlet', addToProblem = 'add_water', Fmin = 20, Fmax = 'fmax_tank', Cost2 = 0,
  ['SOWE'] = { water = {cp = 'cp_water', dtmin = 'dtmin', ht_coeff = 'ht', fmin = 2, HClayer = 'heat', tank = 'rwwsp', T = {'rwwsp_t'} } } })
model:addUnit ("rwwsp_s", {type = 'SOWE', DisplayName = 'raw warm water outlet', addToProblem = 'add_water', Fmin = 20, Fmax = 'fmax_tank', Cost2 = 0,
  ['SOWE'] = { water = {cp = 'cp_water', dtmin = 'dtmin', ht_coeff = 'ht', fmin = 2, HClayer = 'heat', tank = 'rwwsp' } } })

model["rwwsp_d"]:addStreams {d = msq ({'water', 'in', 1, 1, {temp = {'rwwsp_t',1}, rm1 = {1,1}} })}
model["rwwsp_d"]:addStreams {c = ms  ({'rww', 'out', 1, 1})}

model["rwwsp_s"]:addStreams {s = msq ({'water', 'out', 1, 1, {temp = {'rwwsp_t',1}, rm1 = {1,1}} })}
model["rwwsp_s"]:addStreams {c = ms  ({'rww', 'in', 1, 1})}
-----------------------------------------------------------------------------------------------------------------------
-- thwsp
-----------------------------------------------------------------------------------------------------------------------
model:addUnit ("thwsp_d", {type = 'SOWE', DisplayName = 'treated hot water inlet', addToProblem = 'add_water', Fmin = 20, Fmax = 'fmax_tank', Cost2 = 0,
  ['SOWE'] = { water = {cp = 'cp_water', dtmin = 'dtmin', ht_coeff = 'ht', fmin = 2, HClayer = 'heat', tank = 'thwsp', T = {'thwsp_t'} } } })
model:addUnit ("thwsp_s", {type = 'SOWE', DisplayName = 'treated hot water outlet', addToProblem = 'add_water', Fmin = 20, Fmax = 'fmax_tank', Cost2 = 0,
  ['SOWE'] = { water = {cp = 'cp_water', dtmin = 'dtmin', ht_coeff = 'ht', fmin = 2, HClayer = 'heat', tank = 'thwsp' } } })

model["thwsp_d"]:addStreams {d = msq ({'water', 'in', 1, 1, {temp = {'thwsp_t',1}, rm1 = {1,1}} })}
model["thwsp_d"]:addStreams {c = ms  ({'thw', 'out', 1, 1})}

model["thwsp_s"]:addStreams {s = msq ({'water', 'out', 1, 1, {temp = {'thwsp_t',1}, rm1 = {1,1}} })}
model["thwsp_s"]:addStreams {c = ms  ({'thw', 'in', 1, 1})}

-----------------------------------------------------------------------------------------------------------------------
-- fwsp
-----------------------------------------------------------------------------------------------------------------------
model:addUnit ("fwsp", {type = 'SOWE', DisplayName = 'freshwater', addToProblem = 'add_water', Fmin = 10, Fmax = 600,
  ['SOWE'] = { water = {cp = 'cp_water', dtmin = 'dtmin', ht_coeff = 'ht', fmin = 1, HClayer = 'heat' } } })

model["fwsp"]:addStreams {s = msq ({'water', 'out', 1, 1, {temp = {'fwsp_t',1}, rm1 = {1,1}} })}
model["fwsp"]:addStreams {i = ms  ({'fw', 'in', 1, 1})}
-----------------------------------------------------------------------------------------------------------------------
-- wwsp
-----------------------------------------------------------------------------------------------------------------------
model:addUnit ("wwsp", {type = 'SOWE', DisplayName = 'wastewater', addToProblem = 'add_water', Fmin = 10, Fmax = 600,
  ['SOWE'] = { water = {cp = 'cp_water', dtmin = 'dtmin', ht_coeff = 'ht', fmin = 1, HClayer = 'heat' } } })

model["wwsp"]:addStreams {s = msq ({'water', 'in', 1, 1, {temp = {'wwsp_t',1}, rm1 = {0,0}} })}
model["wwsp"]:addStreams {o = ms  ({'ww', 'out', 1, 1})}
-----------------------------------------------------------------------------------------------------------------------
-- closed loop recirculating cooling utility
-----------------------------------------------------------------------------------------------------------------------
model.inputs.cu_return_t  = {default = 26, unit = 'USD/kg', description = ''}
model.inputs.cu_dtmin     = {default = 3, unit = 'USD/kg', description = ''}
model.inputs.cu_return_mf = {default = 1-0.02, unit = 'USD/kg', description = ''}
model.outputs.cu_hot      = {job = "cp_water*(wwsp_t-cu_return_t)", unit = 'C', description = 'cooling utility duty'}
model.outputs.cu_air_tin  = {job = "cu_return_t-2*cu_dtmin-0.1", unit = 'C', description = 'cooling utility duty'}
model.outputs.cu_air_tout = {job = "wwsp_t-2*cu_dtmin", unit = 'C', description = 'cooling utility duty'}
model.outputs.cu_air_mf   = {job = "cp_water/air_cp", unit = 'C', description = 'cooling utility duty'}
model.outputs.cu_elec     = {job = "cu_hot()*0.03", unit = 'C', description = 'cooling utility duty'}
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
-- cu_ww and cu_rt (version 1)
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
model:addUnit ("cu_ww", {type = 'SOWE', DisplayName = 'wastewater', addToProblem = 0, Fmin = 10, Fmax = 600, Cost2 = 189/8000*4.2*(30-26),
  ['SOWE'] = { water = {cp = 'cp_water', dtmin = 'dtmin', ht_coeff = 'ht', fmin = 1, HClayer = 'heat' } } })

model["cu_ww"]:addStreams {i = msq ({'water', 'in', 1, 1, {temp = {'wwsp_t',1}, rm1 = {1,1}} })}
model["cu_ww"]:addStreams {o = ms  ({'cu','out',1,1})}
model["cu_ww"]:addStreams {el = ms  ({'electricity','in','cu_elec',1})}
model["cu_ww"]:addStreams {h =  qt {tin = 'wwsp_t',     hin = 'cu_hot', tout = 'cu_return_t', hout = 0,         dtmin = 'cu_dtmin', alpha = 1, HC = 'heat'}}
model["cu_ww"]:addStreams {c =  qt {tin = 'cu_air_tin', hin = 0,        tout = 'cu_air_tout',  hout = 'cu_hot',  dtmin = 'cu_dtmin', alpha = 1, HC = 'heat'}}

model:addUnit ("cu_rt", {type = 'Utility', DisplayName = 'cooling returned', addToProblem = 0, Fmin = 10, Fmax = 600, Cost2 = 0})
model["cu_rt"]:addStreams {o = msq ({'water', 'out', 'cu_return_mf', 1, {temp = {'cu_return_t',1}, rm1 = {1,1}} })}
model["cu_rt"]:addStreams {i = ms  ({'cu','in',1,1})}
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
-- cu_ww and cu_rt (version 2) new
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------- 
model:addUnit ("cu_ww", {type = 'SOWE', DisplayName = 'wastewater', addToProblem = 'add_water', Fmin = 10, Fmax = 1000, Cost2 = 0,
  ['SOWE'] = { water = {cp = 'cp_water', dtmin = 'cu_dtmin', ht_coeff = 'ht', fmin = 1, HClayer = 'heat_cu', T_forbidden = {20,28,66,69,71,85,'thwsp_t'} } } })

model["cu_ww"]:addStreams {i = msq ({'water', 'in', 1, 1, {temp = {'wwsp_t',1}, rm1 = {1,1}} })}
model["cu_ww"]:addStreams {o = ms  ({'cu','out',1,1})}
model["cu_ww"]:addStreams {h =  qt {tin = 'wwsp_t',     hin = 'cu_hot', tout = 'cu_return_t', hout = 0,         dtmin = 'cu_dtmin', alpha = 1, HC = 'heat_cu'}}

model:addUnit ("cu_rt", {type = 'Utility', DisplayName = 'cooling returned', addToProblem = 'add_water', Fmin = 10, Fmax = 1000, Cost2 = 0})
model["cu_rt"]:addStreams {o = msq ({'water', 'out',1, 1, {temp = {'cu_return_t',1}, rm1 = {1,1}} })}
model["cu_rt"]:addStreams {i = ms  ({'cu','in',1,1})}

model:addUnit ("cu_th", {type = 'Utility', DisplayName = 'cooling thermal duty', addToProblem = 'add_water', Fmin = 1, Fmax = 100000, Cost2 = 18.568/8000})
model["cu_th"]:addStreams {el = ms  ({'electricity','in',0.03,1})} -- 30 kW/MW_th
model["cu_th"]:addStreams {mk = ms  ({'cu','in',2*1000/3600/1000,1})} -- 2 m3/hr/MW_th of makeup for wet open recirculating BREF industrial cooling systems 
model["cu_th"]:addStreams {c =  qt {tin = 'cu_air_tin', hin = 0, tout = 'cu_air_tout', hout = 1, dtmin = 'cu_dtmin', alpha = 1, HC = 'heat_cu'}}


return model