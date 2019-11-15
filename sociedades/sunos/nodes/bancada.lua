--[[
	Mod Sunos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Bancada dos sunos
  ]]

-- Tradução de strings
local S = sunos.S

-- Bancada dos sunos
minetest.register_node("sunos:bancada", {
	description = S("Bancada dos Sunos"),
	tiles = {
		"default_wood.png",
		"(default_wood.png^(farming_straw.png^sunos_bancada_lado.png^[makealpha:76,255,0))"
	},
	paramtype2 = "facedir",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, sunos=1},
	legacy_facedir_simple = true,
	is_ground_content = false,
	sounds = default.node_sound_wood_defaults(),
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, -0.375, 0.375, -0.375}, -- Perna_1
			{0.375, -0.5, -0.5, 0.5, 0.375, -0.375}, -- Perna_2
			{-0.5, -0.5, 0.375, -0.375, 0.375, 0.5}, -- Perna_3
			{0.375, -0.5, 0.375, 0.5, 0.375, 0.5}, -- Perna_4
			{-0.5, 0.375, -0.5, 0.5, 0.5, 0.5}, -- Tampo
			{-0.4375, -0.4375, -0.4375, 0.4375, 0.375, 0.4375}, -- Interior
		}
	},
})

-- Criar cópia sem Drop (para evitar furtos em estruturas dos sunos)
do
	-- Copiar tabela de definições
	local def = {}
	for n,d in pairs(minetest.registered_nodes["sunos:bancada"]) do
		def[n] = d
	end
	-- Mantem a tabela groups separada
	def.groups = minetest.deserialize(minetest.serialize(def.groups))
	
	-- Altera alguns paremetros
	def.description = def.description .. " ("..S("Sem Drop")..")"
	def.groups.not_in_creative_inventory = 1
	def.drop = ""
	-- Registra o novo node
	minetest.register_node("sunos:bancada_nodrop", def)
end
