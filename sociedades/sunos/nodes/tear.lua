--[[
	Mod Sunos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Tear de Palha
  ]]

-- Tradução de strings
local S = sunos.S

-- Tear do Carpete de Palha
minetest.register_node("sunos:tear_palha", {
	description = S("Tear de Palha"),
	tiles = {
		"default_wood.png", -- Cima 
		"default_wood.png^(farming_straw.png^sunos_tear_palha.png^[makealpha:76,255,0)", -- Baixo
		"default_wood.png^(farming_straw.png^sunos_tear_palha_lado.png^[makealpha:76,255,0)^[transformFX", -- Direita
		"default_wood.png^(farming_straw.png^sunos_tear_palha_lado.png^[makealpha:76,255,0)", -- Esquerda
		"default_wood.png^(farming_straw.png^sunos_tear_palha.png^[makealpha:76,255,0)", -- Fundo
		"default_wood.png^(farming_straw.png^sunos_tear_palha.png^[makealpha:76,255,0)" -- Frente
	},
	paramtype2 = "facedir",
	groups = {choppy = 2, oddly_breakable_by_hand = 2,attached_node=1},
	legacy_facedir_simple = true,
	is_ground_content = false,
	sounds = default.node_sound_wood_defaults(),
	drawtype = "nodebox",
	paramtype = "light",
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.4375, -0.5, -0.0625, 0.4375, 0.4375, 0.125}
		}
	},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.4375, -0.5, -0.3125, -0.375, -0.4375, 0.3125}, -- NodeBox1
			{0.375, -0.5, -0.3125, 0.4375, -0.4375, 0.3125}, -- NodeBox2
			{0.375, -0.4375, -0.0625, 0.4375, 0.375, 0}, -- NodeBox3
			{0.375, -0.4375, 0.0625, 0.4375, 0.375, 0.125}, -- NodeBox4
			{-0.4375, -0.4375, -0.0625, -0.375, 0.375, 0}, -- NodeBox5
			{-0.4375, -0.4375, 0.0625, -0.375, 0.375, 0.125}, -- NodeBox6
			{0.375, 0.375, -0.0625, 0.4375, 0.4375, 0.125}, -- NodeBox7
			{-0.4375, 0.375, -0.0625, -0.375, 0.4375, 0.125}, -- NodeBox8
			{-0.375, 0.25, 0, 0.375, 0.4375, 0.0625}, -- NodeBox9
			{-0.3125, -0.3125, 0, -0.25, 0.4375, 0.0625}, -- NodeBox10
			{-0.1875, -0.375, 0, -0.125, 0.4375, 0.0625}, -- NodeBox11
			{-0.0625, -0.3125, 0, 0, 0.4375, 0.0625}, -- NodeBox12
			{0.0625, -0.25, 0, 0.125, 0.4375, 0.0625}, -- NodeBox13
			{0.1875, -0.375, 0, 0.25, 0.4375, 0.0625}, -- NodeBox14
			{-0.3125, 0.125, 0, 0.3125, 0.1875, 0.0625}, -- NodeBox15
			{-0.375, 0, 0, 0.375, 0.0625, 0.0625}, -- NodeBox16
			{-0.375, 0.1875, 0, 0.3125, 0.25, 0.0625}, -- NodeBox17
			{-0.1875, -0.125, 0, 0.375, -0.0625, 0.0625}, -- NodeBox18
			{-0.3125, -0.25, 0, 0.25, -0.1875, 0.0625}, -- NodeBox19
			{0.3125, -0.3125, 0, 0.375, 0.4375, 0.0625}, -- NodeBox20
		}
	},
	
	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		local formspec = "size[8,8.2]"
			..default.gui_bg
			..default.gui_bg_img
			..default.gui_slots
			.."label[0,0;"..S("Tear de Palha").."]"
			
			.."item_image_button[1,1;2,2;farming:straw;item1;]"
			.."image[3.5,1.45;1,1;gui_furnace_arrow_bg.png^[transformR270]"
			.."item_image_button[5,1;2,2;sunos:carpete_palha;tecer_carpete;]"
			
			.."list[current_player;main;0,4.25;8,1;]"
			.."list[current_player;main;0,5.5;8,3;8]"
			..default.get_hotbar_bg(0,4.25)
			
		minetest.show_formspec(player:get_player_name(), "sunos:tear_palha", formspec)
	end,
})

-- Criar cópia sem Drop (para evitar furtos em estruturas dos sunos)
do
	-- Copiar tabela de definições
	local def = {}
	for n,d in pairs(minetest.registered_nodes["sunos:tear_palha"]) do
		def[n] = d
	end
	-- Mantem a tabela groups separada
	def.groups = minetest.deserialize(minetest.serialize(def.groups))
	
	-- Altera alguns paremetros
	def.description = def.description .. " ("..S("Sem Drop")..")"
	def.groups.not_in_creative_inventory = 1
	def.drop = ""
	-- Registra o novo node
	minetest.register_node("sunos:tear_palha_nodrop", def)
end

-- Receptor de botoes
minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname == "sunos:tear_palha" then
		if fields.tecer_carpete then
			local inv = player:get_inventory()
			
			if inv:room_for_item("main", "sunos:carpete_palha 5") then
				sunos.trocar_plus(player, {"farming:straw"}, {"sunos:carpete_palha 5"})
			end
		end
	end
end)
