--[[
	Mod Sunos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Salada de Frutas dos Sunos
  ]]

-- Tradução de strings
local S = sunos.S

-- Broa de Frutas dos Sunos
minetest.register_craftitem("sunos:salada_frutas", {
	description = S("Salada de Frutas dos Sunos"),
	inventory_image = "sunos_salada_frutas.png",
	on_use = minetest.item_eat(tonumber(minetest.setting_get("sunos_item_salada_frutas_eat") or 5)),
	groups = {flammable = 2},
})
