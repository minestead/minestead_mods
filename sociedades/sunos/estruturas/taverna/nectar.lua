--[[
	Mod Sunos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Nectar de fruta dos sunos
  ]]

-- Tradução de strings
local S = sunos.S

-- Node Garrafa de Nectar (item comestivel)
minetest.register_node("sunos:nectar", {
	description = S("Nectar de Frutas dos Sunos"),
	tiles = {"sunos_nectar.png"},
	drawtype = "mesh",
	mesh = "sunos_nectar_tool.b3d",
	paramtype = "light",
	stack_max = 10,
	on_use = core.item_eat(tonumber(minetest.setting_get("sunos_item_nectar_eat") or 4)),
	groups = {attached_node=1,choppy=2,dig_immediate=3},
	sounds = default.node_sound_defaults(),
	collision_box = {
		type = "fixed",
		fixed = {
			{-0.1,  -0.5,  -0.1, 0.1, 0, 0.1}
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.1,  -0.5,  -0.1, 0.1, 0, 0.1}
		}
	},
	on_place = function(itemstack, placer, pointed_thing)
		if pointed_thing.type ~= "node" then
			return itemstack
		end
		
		-- Verifica se esta acessando outro node
		local under = pointed_thing.under
		local node = minetest.get_node(under)
		local defnode = minetest.registered_nodes[node.name]
		if defnode and defnode.on_rightclick and
			((not placer) or (placer and not placer:get_player_control().sneak)) then
			return defnode.on_rightclick(under, node, placer, itemstack,
				pointed_thing) or itemstack
		end
		
		itemstack:set_name("sunos:nectar_node")
		
		if not minetest.item_place(itemstack, placer, pointed_thing) then
			return itemstack
		end
			
		-- Remove item do inventario
		itemstack:take_item()

		return itemstack
	end,
})
-- Node Garrafa de Nectar (decorativo)
minetest.register_node("sunos:nectar_node", {
	description = S("Nectar de Frutas dos Sunos"),
	tiles = {"sunos_nectar.png"},
	drawtype = "mesh",
	mesh = "sunos_nectar.b3d",
	paramtype = "light",
	groups = {attached_node=1,choppy=2,dig_immediate=3,not_in_creative_inventory=1},
	sounds = default.node_sound_defaults(),
	collision_box = {
		type = "fixed",
		fixed = {
			{-0.1,  -0.5,  -0.1, 0.1, 0, 0.1}
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.1,  -0.5,  -0.1, 0.1, 0, 0.1}
		}
	},
	drop = "sunos:nectar",
	
})

-- Registrar comida no hbhunger
if minetest.get_modpath("hbhunger") then
	hbhunger.register_food("sunos:nectar", tonumber(minetest.setting_get("sunos_item_nectar_eat") or 4), "vessels:glass_bottle", nil, 2, "sunos_bebendo_garrafa_de_vidro")
end

-- Criar cópia sem Drop (para evitar furtos em estruturas dos sunos)
do
	-- Copiar tabela de definições
	local def = {}
	for n,d in pairs(minetest.registered_nodes["sunos:nectar_node"]) do
		def[n] = d
	end
	-- Mantem a tabela groups separada
	def.groups = minetest.deserialize(minetest.serialize(def.groups))
	
	-- Altera alguns paremetros
	def.description = def.description .. " ("..S("Sem Drop")..")"
	def.groups.not_in_creative_inventory = 1
	def.drop = ""
	-- Registra o novo node
	minetest.register_node("sunos:nectar_node_nodrop", def)
end

do
	-- Copiar tabela de definições
	local def = {}
	for n,d in pairs(minetest.registered_nodes["sunos:nectar"]) do
		def[n] = d
	end
	-- Mantem a tabela groups separada
	def.groups = minetest.deserialize(minetest.serialize(def.groups))
	
	-- Altera alguns paremetros
	def.description = def.description .. " ("..S("Sem Drop")..")"
	def.groups.not_in_creative_inventory = 1
	def.drop = ""
	-- Registra o novo node
	minetest.register_node("sunos:nectar_nodrop", def)
end
