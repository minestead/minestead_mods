--[[
	Mod Sunos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	emporio dos sunos
  ]]

-- Tradução de strings
local S = sunos.S

-- Placa da taverna barbara
minetest.register_node("sunos:emporio_placa", {
	description = S("Placa de Emporio dos Sunos"),
	drawtype = "nodebox",
	tiles = {
		"default_wood.png^sunos_emporio_placa.png", -- Cima
		"default_wood.png^sunos_emporio_placa.png", -- Baixo
		"default_wood.png^sunos_emporio_placa.png", -- Lado direito
		"default_wood.png^sunos_emporio_placa.png", -- Lado esquerda
		"default_wood.png^sunos_emporio_placa.png", -- Fundo
		"default_wood.png^sunos_emporio_placa.png" -- Frente
	},
	inventory_image = "default_wood.png^sunos_emporio_placa_inv.png^[makealpha:255,127,127",
	wield_image = "default_wood.png^sunos_emporio_placa_inv.png^[makealpha:255,127,127",
	paramtype = "light",
	paramtype2 = "facedir",
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.4375, -0.4375, 0.4375, 0.4375, 0.4375, 0.5},
	},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.1875, -0.4375, 0.4375, 0.1875, 0.4375, 0.5}, -- NodeBox1
			{-0.4375, -0.1875, 0.4375, 0.4375, 0.1875, 0.5}, -- NodeBox2
			{-0.25, -0.375, 0.4375, 0.25, 0.375, 0.5}, -- NodeBox3
			{-0.3125, -0.3125, 0.4375, 0.3125, 0.3125, 0.5}, -- NodeBox4
			{-0.375, -0.25, 0.4375, 0.375, 0.25, 0.5}, -- NodeBox5
		}
	},
	groups = {choppy=2,oddly_breakable_by_hand=2},
	sounds = default.node_sound_defaults(),
	drop = "",
})
