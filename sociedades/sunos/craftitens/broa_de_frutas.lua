--[[
	Mod Sunos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Broa de Frutas dos Sunos
  ]]

-- Tradução de strings
local S = sunos.S

-- Broa de Frutas dos Sunos
minetest.register_craftitem("sunos:broa_frutas", {
	description = S("Broa de Frutas dos Sunos"),
	inventory_image = "sunos_broa_frutas.png",
	on_use = minetest.item_eat(tonumber(minetest.setting_get("sunos_item_broa_frutas_eat") or 7)),
	groups = {flammable = 2},
})

-- Massa de Broa de Frutas dos Sunos
minetest.register_craftitem("sunos:massa_broa_frutas", {
	description = S("Massa de Broa de Frutas dos Sunos"),
	inventory_image = "sunos_massa_broa_frutas.png",
	on_use = minetest.item_eat(2),
	groups = {flammable = 2},
})

-- Processo de assadura da broa
minetest.register_craft({
	type = "cooking",
	cooktime = 15,
	output = "sunos:broa_frutas",
	recipe = "sunos:massa_broa_frutas"
})
