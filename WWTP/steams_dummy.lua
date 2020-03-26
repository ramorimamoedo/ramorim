--[[-----------------------------------------------------------------------------------
# Hot and cold utilities
  Data is taken from ASPEN utilities
# The idea is to have the hot utilities as steam network at some point
-----------------------------------
  From Fundamental of Thermodynamics, Sonntag and Van Wylen
  High Pressure (HP) steam:   250 oC, 3973.0 KPa (572 psi), 1716.18 kJ/kg 42 bar
  Medium Pressure (MP) steam: 175 oC, 892 KPa (127 psi), 2032.42 kJ/kg    11 bar
  Low Pressure (LP) steam:    125 oC, 232.1 KPa (), 2188.5 kJ/kg          6 bar


]]-----------------------------------------------------------------------------------
--
local osmose  = require 'osmose'
local hcu     = osmose.Model 'utilities'
local cp      = require 'coolprop'

hcu.software = {'Ecoinvent'}

hcu.class = {
  Group 	= 'utilities',
  Type 		= 'hot and cold',
  SubType = 'steam and cooling water'}

hcu.label = {
  Name        = 'hcu',
  Description = 'hot and cold utilities in and industrial plant',
}

hcu.author = {{
  Id 			    = 1,
  Author 		  = 'Maziar Kermani',
  Date 		    = '05-Feb-2016',
  ChangeLog 	= ''},
}
-----------------------------------------------------------------------
-----------------------------------------------------------------------
-- Adding constant values
hcu.values = {
}
-----------------------------------------------------------------------
-----------------------------------------------------------------------
-- Adding inputs
hcu.inputs = {
  hhp_steam_p = {default = 32, unit = 'bar', description = 'pressure level of the high pressure steam'},
  hp_steam_p = {default = 12, unit = 'bar', description = 'pressure level of the medium pressure steam'},
  mp_steam_p = {default = 9.3, unit = 'bar', description = 'pressure level of the low pressure steam'},
  lp_steam_p = {default = 5.13, unit = 'bar', description = 'pressure level of the low pressure steam'},
  llp_steam_p = {default = 3, unit = 'bar', description = 'pressure level of the low pressure steam'},
  con_steam_p = {default = 0.3, unit = 'bar', description = 'pressure level of the low pressure steam'},
}
-----------------------------------------------------------------------
-----------------------------------------------------------------------
-- outputs (calculations)
hcu.outputs = {
  hhp_steam_t  = {job = function() return cp.PropsSI("T", "P", hhp_steam_p*100000, "Q", 0, "Water") - 273 end, unit = 'oC', description = 'saturated temperature'},
  hhp_steam_hg = {job = function() return cp.PropsSI("H", "P", hhp_steam_p*100000, "Q", 1, "Water")/1000 end, unit = 'kJ/kg', description = 'enthalpy of saturated gas'},
  hhp_steam_hl = {job = function() return cp.PropsSI("H", "P", hhp_steam_p*100000, "Q", 0, "Water")/1000 end, unit = 'kJ/kg', description = 'enthalpy of saturated gas'},

  hp_steam_t  = {job = function() return cp.PropsSI("T", "P", hp_steam_p*100000, "Q", 0, "Water") - 273 end, unit = 'oC', description = 'saturated temperature'},
  hp_steam_hg = {job = function() return cp.PropsSI("H", "P", hp_steam_p*100000, "Q", 1, "Water")/1000 end, unit = 'kJ/kg', description = 'enthalpy of saturated gas'},
  hp_steam_hl = {job = function() return cp.PropsSI("H", "P", hp_steam_p*100000, "Q", 0, "Water")/1000 end, unit = 'kJ/kg', description = 'enthalpy of saturated gas'},

  mp_steam_t  = {job = function() return cp.PropsSI("T", "P", mp_steam_p*100000, "Q", 0, "Water") - 273 end, unit = 'oC', description = 'saturated temperature'},
  mp_steam_hg = {job = function() return cp.PropsSI("H", "P", mp_steam_p*100000, "Q", 1, "Water")/1000 end, unit = 'kJ/kg', description = 'enthalpy of saturated gas'},
  mp_steam_hl = {job = function() return cp.PropsSI("H", "P", mp_steam_p*100000, "Q", 0, "Water")/1000 end, unit = 'kJ/kg', description = 'enthalpy of saturated gas'},

  lp_steam_t  = {job = function() return cp.PropsSI("T", "P", lp_steam_p*100000, "Q", 0, "Water") - 273 end, unit = 'oC', description = 'saturated temperature'},
  lp_steam_hg = {job = function() return cp.PropsSI("H", "P", lp_steam_p*100000, "Q", 1, "Water")/1000 end, unit = 'kJ/kg', description = 'enthalpy of saturated gas'},
  lp_steam_hl = {job = function() return cp.PropsSI("H", "P", lp_steam_p*100000, "Q", 0, "Water")/1000 end, unit = 'kJ/kg', description = 'enthalpy of saturated gas'},

  llp_steam_t  = {job = function() return cp.PropsSI("T", "P", llp_steam_p*100000, "Q", 0, "Water") - 273 end, unit = 'oC', description = 'saturated temperature'},
  llp_steam_hg = {job = function() return cp.PropsSI("H", "P", llp_steam_p*100000, "Q", 1, "Water")/1000 end, unit = 'kJ/kg', description = 'enthalpy of saturated gas'},
  llp_steam_hl = {job = function() return cp.PropsSI("H", "P", llp_steam_p*100000, "Q", 0, "Water")/1000 end, unit = 'kJ/kg', description = 'enthalpy of saturated gas'},

  con_steam_t  = {job = function() return cp.PropsSI("T", "P", con_steam_p*100000, "Q", 0, "Water") - 273 end, unit = 'oC', description = 'saturated temperature'},
  con_steam_hg = {job = function() return cp.PropsSI("H", "P", con_steam_p*100000, "Q", 1, "Water")/1000 end, unit = 'kJ/kg', description = 'enthalpy of saturated gas'},
  con_steam_hl = {job = function() return cp.PropsSI("H", "P", con_steam_p*100000, "Q", 0, "Water")/1000 end, unit = 'kJ/kg', description = 'enthalpy of saturated gas'},
  }
-----------------------------------------------------------------------
-----------------------------------------------------------------------
-- Adding Layers
------------------------
-----------------------------------------------------------------------
--[[
--
--
# Add Units and their streams
--
--
--]]
-----------------------------------------------------------------------
-----------------------------------------------------------------------
-- high pressure steam with hot stream
-----------------------------------------------------------------------
-----------------------------------------------------------------------
--hcu:addUnit("hhp_steam",  {type = 'Utility', addToProblem  = 1, Fmax = 100000, Cost2 = 1/3600})
hcu:addUnit("hp_steam",   {type = 'Utility', addToProblem  = 1, Fmax = 100000, Cost2 = 0.9/3600})
hcu:addUnit("mp_steam",   {type = 'Utility', addToProblem  = 1, Fmax = 100000, Cost2 = 0.8/3600})
hcu:addUnit("lp_steam",   {type = 'Utility', addToProblem  = 1, Fmax = 100000, Cost2 = 0.7/3600})
hcu:addUnit("llp_steam",  {type = 'Utility', addToProblem  = 1, Fmax = 100000, Cost2 = 0.6/3600})
hcu:addUnit("con_steam", {type = 'Utility', addToProblem  = 0, Fmax = 100000, Cost2 = 0.5/3600})

--hcu["hhp_steam"]:addStreams   {h = qt {tin = 'hhp_steam_t', hin = 1, tout = 'hhp_steam_t', hout = 0, dtmin = 5, alpha = 1}}
hcu["hp_steam"]:addStreams    {h = qt {tin = 'hp_steam_t',  hin = 1, tout = 'hp_steam_t', hout = 0, dtmin = 5, alpha = 1}}
hcu["mp_steam"]:addStreams    {h = qt {tin = 'mp_steam_t',  hin = 1, tout = 'mp_steam_t', hout = 0, dtmin = 5, alpha = 1}}
hcu["lp_steam"]:addStreams    {h = qt {tin = 'lp_steam_t',  hin = 1, tout = 'lp_steam_t', hout = 0, dtmin = 5, alpha = 1}}
hcu["lp_steam"]:addStreams    {h = qt {tin = 'lp_steam_t',  hin = 1, tout = 'lp_steam_t', hout = 0, dtmin = 5, alpha = 1}}
hcu["llp_steam"]:addStreams   {h = qt {tin = 'llp_steam_t', hin = 1, tout = 'llp_steam_t', hout = 0, dtmin = 5, alpha = 1}}
hcu["con_steam"]:addStreams   {h = qt {tin = 'con_steam_t', hin = 1, tout = 'con_steam_t', hout = 0, dtmin = 5, alpha = 1}}

hcu:addUnit("cold", {type = 'Utility', Description = 'cold utility', addToProblem  = 0,
  Fmin          = 0,
  Fmax          = 10000,
  Cost1         = 0,
  Cost2         =  0, -- 'price_elec_sell',
})

hcu["cold"]:addStreams {c =  qt {tin = 20,  hin = 0, tout = 30, hout = 4.2*(20-10), dtmin = 2, alpha = 1}}

return hcu