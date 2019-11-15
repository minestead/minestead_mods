--[[
	Mod Sunos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	barril taverna dos sunos
  ]]

-- Tradução de strings
local S = sunos.S

minetest.register_node("sunos:barril", {
	description = S("Barril"),
	paramtype = "light",
	paramtype2 = "facedir",
	drawtype = "mesh",
	mesh = "sunos_taverna_barril.obj",
	tiles = {"sunos_taverna_barril.png" },
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	drop = "",
	ground_content = false,
})
