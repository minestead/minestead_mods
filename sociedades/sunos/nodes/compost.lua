--[[
	Mod Sunos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Barril de compostagem
  ]]

-- Tradução de strings
local S = sunos.S


do
	-- Pega os groups separadamente para evitar replicação erronea ao ser alterado
	local g = minetest.deserialize(minetest.serialize(minetest.registered_nodes["compost:wood_barrel"].groups))
	g.not_in_creative_inventory = 1

	-- Cria o node usando a midia do mod compost original
	minetest.register_node("sunos:wood_barrel_nodrop", {
		description = minetest.registered_nodes["compost:wood_barrel"].description .. " ("..S("Sem Drop")..")",
		tiles = minetest.registered_nodes["compost:wood_barrel"].tiles,
		drawtype = minetest.registered_nodes["compost:wood_barrel"].drawtype,
		node_box = minetest.registered_nodes["compost:wood_barrel"].node_box,
		selection_box = minetest.registered_nodes["compost:wood_barrel"].selection_box,
		paramtype = "light",
		is_ground_content = false,
		groups = g,
		sounds =  minetest.registered_nodes["compost:wood_barrel"].sounds,
		drop = "",
	})
end
