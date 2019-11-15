--[[
	Mod Sovagxas para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Totem
  ]]

-- Tradução de strings
local S = sovagxas.S

-- Totem Sovagxa
minetest.register_node("sovagxas:totem", {
	description = S("Totem Sovagxa"),
	tiles = {
		"default_jungletree_top.png", 
		"default_jungletree_top.png", 
		"default_jungletree.png",
		"default_jungletree.png", 
		"default_jungletree.png", 
		"default_jungletree.png^sovagxas_totem.png" -- frente
	},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree=1,choppy=2,oddly_breakable_by_hand=1,flammable=2},
	sounds = default.node_sound_wood_defaults(),
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", S("Totem Sovagxa"))
	end,
	on_place = minetest.rotate_node
})
-- Criar cópia sem Drop (para evitar furtos em estruturas dos sunos)
do
	-- Copiar tabela de definições
	local def = {}
	for n,d in pairs(minetest.registered_nodes["sovagxas:totem"]) do
		def[n] = d
	end
	-- Mantem a tabela groups separada
	def.groups = minetest.deserialize(minetest.serialize(def.groups))
	
	-- Altera alguns paremetros
	def.description = def.description .. " ("..S("Sem Drop")..")"
	def.groups.not_in_creative_inventory = 1
	def.drop = ""
	-- Registra o novo node
	minetest.register_node("sovagxas:totem_nodrop", def)
end


