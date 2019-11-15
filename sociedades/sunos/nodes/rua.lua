--[[
	Mod Sunos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Ruas das vilas
  ]]

-- Tradução de strings
local S = sunos.S

-- Rua Calcetada
minetest.register_node("sunos:rua_calcetada", {
	description = S("Rua Calcetada"),
	tiles = {"default_grass.png^sunos_rua_calcetada_cima.png", "default_dirt.png",
		{name = "default_dirt.png^default_grass_side.png^sunos_rua_calcetada_lado.png",
			tileable_vertical = false}},
	groups = {crumbly = 3, soil = 1, spreading_dirt_type = 1},
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_hard_footstep", gain = 0.4},
	}),
})

-- Receitas
minetest.register_craft({
	output = "sunos:rua_calcetada 3",
	recipe = {
		{"", "default:cobble", ""},
		{"default:dirt", "default:dirt", "default:dirt"}
	}
})
minetest.register_craft({
	output = "default:dirt",
	recipe = {
		{"sunos:rua_calcetada"},
	}
})

stairs.register_stair_and_slab(
	"rua_calcetada",
	"sunos:rua_calcetada",
	{crumbly = 3, soil = 1, spreading_dirt_type = 1},
	{"default_grass.png^sunos_rua_calcetada_cima.png", "default_dirt.png",
		"default_dirt.png^default_grass_side.png^sunos_rua_calcetada_lado.png"
	},
	S("Degrau de Rua Calcetada"),
	S("Placa de Rua Calcetada"),
	default.node_sound_dirt_defaults({
		footstep = {name = "default_hard_footstep", gain = 0.4},
	})
)

