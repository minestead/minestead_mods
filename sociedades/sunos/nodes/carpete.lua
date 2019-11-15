--[[
	Mod Sunos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Carpete de palha
  ]]

-- Tradução de strings
local S = sunos.S

-- Carpete de palha
minetest.register_node("sunos:carpete_palha", {
	description = S("Carpete de Palha"),
	tiles = {"farming_straw.png"},
	drawtype = "nodebox",
	paramtype = "light",
	liquids_pointable = false,
	walkable = false,
	buildable_to = true,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5}, -- Base
			{-0.3125, -0.4375, -0.3125, -0.25, -0.406, 0.1875}, -- NodeBox2
			{0.25, -0.4375, 0.0625, 0.3125, -0.406, 0.5}, -- NodeBox3
			{0, -0.4375, -0.5, 0.0625, -0.406, -0.125}, -- NodeBox4
			{-0.125, -0.4375, 0.125, -0.0625, -0.406, 0.5}, -- NodeBox5
			{0.375, -0.4375, -0.375, 0.4375, -0.406, 0.125}, -- NodeBox6
			{0.125, -0.4375, -0.25, 0.1875, -0.406, 0.1875}, -- NodeBox7
			{-0.4375, -0.4375, 0, -0.375, -0.406, 0.375}, -- NodeBox8
			{-0.1875, -0.4375, -0.375, -0.125, -0.406, -0.0625}, -- NodeBox9
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5}
	},
    	groups = {choppy=2,oddly_breakable_by_hand=3,flammable=1,attached_node=1,fall_damage_add_percent=-5},
    	sounds = default.node_sound_leaves_defaults(),
})

-- Criar cópia sem Drop (para evitar furtos em estruturas dos sunos)
do
	-- Copiar tabela de definições
	local def = {}
	for n,d in pairs(minetest.registered_nodes["sunos:carpete_palha"]) do
		def[n] = d
	end
	-- Mantem a tabela groups separada
	def.groups = minetest.deserialize(minetest.serialize(def.groups))
	
	-- Altera alguns paremetros
	def.description = def.description .. " ("..S("Sem Drop")..")"
	def.groups.not_in_creative_inventory = 1
	def.drop = ""
	-- Registra o novo node
	minetest.register_node("sunos:carpete_palha_nodrop", def)
end


