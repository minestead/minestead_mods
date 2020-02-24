local modpath = minetest.get_modpath(minetest.get_current_modname())

dofile(modpath.."/nodes.lua")
dofile(modpath.."/invader.lua")
dofile(modpath.."/engine.lua")

local _ = {
  name = "air",
  prob = 0,
}

local M = {
  name = "ufowreck:alien_metal",
  force_place = true,
}

local M1 = {
  name = "ufowreck:alien_metal",
}

local L = {
  name = "ufowreck:alien_light",
}

local G = {
  name = "ufowreck:alien_glass",
  force_place = true,
}

local D1 = {
  name = "ufowreck:alien_door_closed", param2=3,
  force_place = true,
}

local D2 = {
  name = "ufowreck:alien_door_closed", param2=1,
  force_place = true,
}

local D3 = {
  name = "ufowreck:alien_door_closed_top", param2=3,
  force_place = true,
}

local D4 = {
  name = "ufowreck:alien_door_closed_top", param2=1,
  force_place = true,
}

local C = {
  name = "ufowreck:alien_control",
}

local E = {
  name = "ufowreck:alien_engine",
}

local H = {
  name = "ufowreck:alien_health_charger8", param2=3,
}

local F = {name = "air", prob = 0,}
local i = math.random(3)
if i == 1 then
	F = {name = "technic:mineral_uranium",
	force_place = true,}
	E = {name = "technic:mineral_uranium",
	force_place = true,}
elseif i == 2 then
	F = {name = "default:stone_with_mese",
	force_place = true,}
	E = {name = "default:stone_with_mese",
	force_place = true,}
end

local P1 = {name = "ufowreck:locked_crate",
	force_place = true,}
local P2 = {name = "air", prob = 0,}
local P3 = {name = "air", prob = 0,}

local i = math.random(3)
if i == 1 then
	P2 = {name = "ufowreck:bar_light",}
elseif i == 2 then
	P2 = {name = "ufowreck:crate",}
end;

local j = math.random(4)
if j == 1 then
	P3 = {name = "ufowreck:eye_tree",}
elseif j == 2 then
	P3 = {name = "ufowreck:predatory_plant",}
elseif j == 3 then
	P3 = {name = "ufowreck:alien_egg",}
else
	P3 = {name = "ufowreck:glow_plant",}
end

local S = {
  name = "ufowreck:floob_spawner",
  force_place = true,
}

-- make schematic
ufowreck_schematic = {
  size = {x = 10, y = 5, z = 10},
  data = {
--1   
    _, _, _, _, _, _, _, _, _, _,
    _, _, _, M, M, M, M, _, _, _,
    _, _, _, M, M, M, G, _, _, _,
    _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _,
--2
    _, _, _, M1, M, M1, M1, _, _, _,
    _, M, M, F, _, M, _, M, M1, _,
    _, M, M, _, _, H, _, G, G, _,
    _, _, _, M, M, M, M, _, _, _,
    _, _, _, _, _, _, _, _, _, _,
--3
    _, _, M, M, M, M1, M, M, _, _,
    _, M, F, E, F, _, _, _, M, _,
    _, M, _, F, _, _, _, _, G, _,
    _, _, M, _, _, _, _, M1, _, _,
    _, _, _, M, M, M, M1, _, _, _,
--4
    _, M, M, M1, M, M, M1, M, M, _,
    M, M, M, L, L, M, _, _, _, M,
    S, M, M, L, L, M, _, _, _, G,
    _, M, M, L, L, M, _, _, M, _,
    _, _, M, M1, M, M, M1, M1, _, _,
--5
    _, M, M, M1, M, M, M, M, M, _,
    _, D1, _, _, _, _, _, _, C, M,
    _, D3, _, _, _, _, _, _, _, G,
    _, M, _, _, _, _, _, _, M, _,
    _, _, M, M1, M, M, M, M1, _, _,
--6
    _, M, M, S, M, M, M, M, M1, _,
    _, D2, _, _, _, _, _, _, C, M,
    _, D4, _, _, _, _, _, _, _, G,
    _, M, _, _, _, _, _, _, M, _,
    _, _, M1, M, M, M, M, M, _, _,
--7
    _, M, M, M, M, M, M1, M, M, _,
    M, M, M, L, L, M, _, _, _, M,
    M, M, M, L, L, M, _, _, _, G,
    _, M, M, L, L, M, _, _, M, _,
    _, _, M, M, M, M1, M1, M, _, _,
--8
    _, _, M, M, M, M, M, M, _, _,
    _, M, P1, _, _, _, _, _, M, _,
    _, M, P2, _, _, _, _, _, G, _,
    _, _, M, _, _, _, _, M, _, _,
    _, _, _, M, M, M, M1, _, _, _,
--9
    _, _, _, M, M, M, M1, _, _, _,
    _, M, M, P2, P3, M, _, M, M, _,
    _, M, M, P2, _, M, _, G, G, _,
    _, _, _, M, M, M, M, _, _, _,
    _, _, _, _, _, _, _, _, _, _,
--10
    _, _, _, _, _, _, _, _, _, _,
    _, _, _, M, M, M1, M1, _, _, _,
    _, _, _, M, M, M, G, _, _, _,
    _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _,
    
  }
}

if math.random(2) == 1 then rotx = '180'
else rotx = '0'
end

minetest.register_decoration({
  deco_type = "schematic",
  place_on = {"default:stone", "default:dirt_with_coniferous_litter", "default:dirt_with_rainforest_litter", "default:dirt_with_snow", "default:snow",
		"default:permafrost_with_stones", "default:sand", "default:dirt_with_grass"},
  biomes = {--"desert", "snowy_grassland", "grassland", "grassland_dunes", "grassland_ocean", "coniferous_forest_dunes", "deciduous_forest", "deciduous_forest_shore", "deciduous_forest_ocean", "cold_desert",
			--"savanna", "savanna_shore", "savanna_ocean", "tundra_beach", 
		"icesheet_ocean", "tundra", "tundra_ocean",	"taiga", "taiga_ocean", "snowy_grassland_ocean",
		"coniferous_forest", "coniferous_forest_ocean", "cold_desert_ocean", "rainforest", "rainforest_swamp", "rainforest_ocean",
		"underground", "floatland_coniferous_forest", "floatland_coniferous_forest_ocean"},
  sidelen = 5,
  fill_ratio = 0.0000000000000001,
  schematic = ufowreck_schematic,
  rotation = rotx,
  y_min = -20,
  y_max = 31000,
  flags = {place_center_z = true, place_center_x = true},
})
