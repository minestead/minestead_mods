--[[
	Mod Sunos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Kit Culinario
  ]]

-- Tradução de strings
local S = sunos.S

-- Kit Culinario
minetest.register_node("sunos:kit_culinario", {
	-- Geral
	description = S("Kit Culinario"),
	
	-- Arte
	tiles = {"sunos_kit_culinario.png"},
	drawtype = "mesh",
	mesh = "sunos_kit_culinario.b3d",
	collision_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.35, 0.5},
		},
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.2, 0.5},
		},
	},
	
	-- Características
	liquids_pointable = false,
	walkable = false,
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	groups = {choppy = 2, oddly_breakable_by_hand = 2,attached_node = 1},
	sounds = default.node_sound_wood_defaults(),
	
	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		local formspec = "size[8,7.2]"
			..default.gui_bg
			..default.gui_bg_img
			..default.gui_slots
			.."label[0,0;"..S("Kit Culinario").."]"
			
			.."item_image_button[0,1;1,1;default:apple 5;item1;]"
			.."item_image_button[0,2;1,1;default:stick 2;item2;]"
			.."item_image_button[1,1;2,2;sunos:salada_frutas;fazer_salada;]"
			
			.."item_image_button[7,1;1,1;farming:flour;item3;]"
			.."item_image_button[7,2;1,1;default:apple 2;item4;]"
			.."item_image_button[5,1;2,2;sunos:broa_frutas;fazer_broa;]"
			
			.."list[current_player;main;0,3.25;8,1;]"
			.."list[current_player;main;0,4.5;8,3;8]"
			..default.get_hotbar_bg(0,3.25)
			
		minetest.show_formspec(player:get_player_name(), "sunos:kit_culinario", formspec)
	end,
	
})

-- Criar cópia sem Drop (para evitar furtos em estruturas dos sunos)
do
	-- Copiar tabela de definições
	local def = {}
	for n,d in pairs(minetest.registered_nodes["sunos:kit_culinario"]) do
		def[n] = d
	end
	-- Mantem a tabela groups separada
	def.groups = minetest.deserialize(minetest.serialize(def.groups))
	
	-- Altera alguns paremetros
	def.description = def.description .. " ("..S("Sem Drop")..")"
	def.groups.not_in_creative_inventory = 1
	def.drop = ""
	-- Registra o novo node
	minetest.register_node("sunos:kit_culinario_nodrop", def)
end

-- Receptor de botoes
minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname == "sunos:kit_culinario" then
		if fields.fazer_salada then
			
			sunos.trocar_plus(player, {"default:apple 5", "default:stick 2"}, {"sunos:salada_frutas"})

		elseif fields.fazer_broa then
			
			sunos.trocar_plus(player, {"default:apple 2", "farming:flour"}, {"sunos:massa_broa_frutas"})

		end
	end
end)

