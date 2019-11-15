--[[
	Mod Sovagxas para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Bancada
  ]]

-- Tradução de strings
local S = sovagxas.S

-- Bancada de Trabalho Selvagem
default.crafttable_formspec = -- Inventario da Bancada de Trabalho
	"size[8,9]"..
	default.gui_bg..
	default.gui_bg_img..
	default.gui_slots..
	"label[1.75,0;"..S("Craftador").."]"..
	"list[current_player;main;0,4.25;8,1;]"..
	"list[current_player;main;0,5.5;8,3;8]"..
	"list[current_player;craft;1.75,0.5;3,3;]"..
	"image[4.85,1.45;1,1;gui_furnace_arrow_bg.png^[transformR270]"..
	"list[current_player;craftpreview;5.75,1.5;1,1;]"..
	default.get_hotbar_bg(0,4.25)
	
minetest.register_node("sovagxas:bancada", { -- Bancada de Trabalho Sovagxa
	description = S("Bancada de Trabalho Sovagxa"),
	tiles = {"default_junglewood.png"},
	paramtype2 = "facedir",
	paramtype = "light",
	drawtype = "nodebox",
		node_box = {
		type = "fixed",
		fixed = {
			{0.3125, -0.5, -0.375, 0.375, 0.375, -0.25}, -- Perna_1
			{-0.375, -0.5, -0.375, -0.25, 0.375, -0.25}, -- Perna_2
			{0.3125, -0.5, 0.3125, 0.375, 0.375, 0.375}, -- Perna_3
			{-0.4375, -0.5, 0.3125, -0.25, 0.375, 0.4375}, -- Perna_4
			{-0.5, -0.25, -0.25, 0.4375, -0.1875, 0.3125}, -- Gaveta_1
			{-0.25, 0.0625, -0.4375, 0.3125, 0.125, 0.4375}, -- Gaveta_2
			{-0.4375, 0.375, -0.4375, 0.4375, 0.4375, 0.5}, -- Mesa
			{-0.5, -0.1875, 0.0625, 0.5, -0.0625, 0.1875}, -- Objeto_1
			{-0.125, 0.125, -0.4375, -0.0625, 0.1875, 0.5}, -- Objeto_2
			{0, 0.125, -0.5, 0.0625, 0.1875, 0.4375}, -- Objeto_3
			{0.1875, 0.125, -0.5, 0.25, 0.1875, 0.5}, -- Objeto_4
			{-0.3125, 0.4375, -0.25, -0.25, 0.5, 0.375}, -- Base_1
			{-0.125, 0.4375, -0.25, -0.0625, 0.5, 0.375}, -- Base_2
			{0.0625, 0.4375, -0.25, 0.125, 0.5, 0.375}, -- Base_3
			{0.25, 0.4375, -0.25, 0.3125, 0.5, 0.375}, -- Base_4
			{-0.3125, 0.4375, -0.25, 0.3125, 0.5, -0.1875}, -- Base_5
			{-0.3125, 0.4375, -0.0625, 0.3125, 0.5, 0}, -- Base_6
			{-0.3125, 0.4375, 0.125, 0.3125, 0.5, 0.1875}, -- Base_7
			{-0.3125, 0.4375, 0.3125, 0.3125, 0.5, 0.375}, -- Base_8
		}
	},
	groups = {choppy=2,oddly_breakable_by_hand=2},
	legacy_facedir_simple = true,
	is_ground_content = false,
	sounds = default.node_sound_wood_defaults(),
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec",default.crafttable_formspec)
	end,
})
-- Criar cópia sem Drop (para evitar furtos em estruturas dos sunos)
do
	-- Copiar tabela de definições
	local def = {}
	for n,d in pairs(minetest.registered_nodes["sovagxas:bancada"]) do
		def[n] = d
	end
	-- Mantem a tabela groups separada
	def.groups = minetest.deserialize(minetest.serialize(def.groups))
	
	-- Altera alguns paremetros
	def.description = def.description .. " ("..S("Sem Drop")..")"
	def.groups.not_in_creative_inventory = 1
	def.drop = ""
	-- Registra o novo node
	minetest.register_node("sovagxas:bancada_nodrop", def)
end
