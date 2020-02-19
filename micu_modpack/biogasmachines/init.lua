--[[

	=======================================================================
	Tubelib Biogas Machines Mod
	by Micu (c) 2018

	Copyright (C) 2018 Michal Cieslakiewicz

	License: LGPLv2.1+
	Media: CC BY-SA
	=======================================================================
	
]]--

biogasmachines = {}

-- helper functions
dofile(minetest.get_modpath("biogasmachines").."/functions.lua")

-- machines
dofile(minetest.get_modpath("biogasmachines").."/freezer.lua")
dofile(minetest.get_modpath("biogasmachines").."/gasifier.lua")
dofile(minetest.get_modpath("biogasmachines").."/gasfurnace.lua")
dofile(minetest.get_modpath("biogasmachines").."/jetfurnace.lua")
-- dofile(minetest.get_modpath("biogasmachines").."/compactor.lua")
-- dofile(minetest.get_modpath("biogasmachines").."/torch.lua")
dofile(minetest.get_modpath("biogasmachines").."/tank.lua")
