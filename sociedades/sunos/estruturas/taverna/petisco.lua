--[[
	Mod Sunos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Petisco de frutas dos sunos
  ]]

-- Tradução de strings
local S = sunos.S

-- Custo de um petisco
local custo_petisco = tonumber(minetest.setting_get("sunos_item_petisco_custo") or 1)

-- Petisco de frutas dos sunos
minetest.register_craftitem("sunos:petisco", {
	description = S("Petisco de Frutas dos Sunos"),
	inventory_image = "sunos_petisco_frutas.png",
	on_use = core.item_eat(tonumber(minetest.setting_get("sunos_item_petisco_eat") or 1)),
})

-- Registrar comida no hbhunger
if minetest.get_modpath("hbhunger") then
	hbhunger.register_food("sunos:petisco", tonumber(minetest.setting_get("sunos_item_petisco_eat") or 1), nil, nil, 2, "sunos_comendo_crocante")
end

minetest.register_node("sunos:expositor_petisco_frutas", {
	description = S("Expositor de Petisco de Frutas dos Sunos"),
	tiles = {
		"default_wood.png^sunos_expositor_petisco_cima.png", -- Cima
		"default_wood.png", -- Baixo
		"default_wood.png^sunos_expositor_petisco_direita.png", -- Lado direito
		"default_wood.png^sunos_expositor_petisco_esquerda.png", -- Lado esquerda
		"default_wood.png^sunos_expositor_petisco_fundo.png", -- Fundo
		"default_wood.png^sunos_expositor_petisco_frente.png" -- Frente
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.4375, -0.5, -0.4375, 0.4375, -0.4375, 0.4375}, -- Base_1
			{-0.375, -0.4375, 0.125, -0.1875, -0.125, 0.3125}, -- Caixa_1
			{-0.375, -0.4375, -0.375, -0.1875, -0.125, -0.1875}, -- Caixa_2
			{-0.375, -0.4375, -0.125, -0.1875, -0.125, 0.0625}, -- Caixa_3
			{-0.125, -0.4375, -0.375, 0.0625, -0.125, -0.1875}, -- Caixa_4
			{-0.125, -0.4375, -0.125, 0.0625, -0.125, 0.0625}, -- Caixa_5
			{-0.125, -0.4375, 0.125, 0.0625, -0.125, 0.3125}, -- Caixa_6
			{0.125, -0.4375, -0.375, 0.3125, -0.125, -0.1875}, -- Caixa_7
			{0.125, -0.4375, -0.125, 0.3125, -0.125, 0.0625}, -- Caixa_8
			{0.125, -0.4375, 0.125, 0.3125, -0.125, 0.3125}, -- Caixa_9
			{0.375, -0.5, 0.375, 0.4375, 0.25, 0.4375}, -- Mastro
			{-0.3125, -0.0625, 0.375, 0.375, 0.25, 0.4375}, -- Bandeira
		}
	},
	groups = {attached_node=1,choppy=2,oddly_breakable_by_hand=2},
	sounds = default.node_sound_defaults(),
	drop = "",
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", S("Petisco de Frutas dos Sunos")) -- infotext pode ser serializado
	end,
	on_rightclick = function(pos, node, player)
		minetest.show_formspec(player:get_player_name(), "sunos:expositor_petisco_frutas", 
			"size[3,3]"
			.."item_image_button[0,0;3,3;sunos:petisco;comprar;]"
		)
	end,
})

-- receptor dos botoes dos expositores
minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname == "sunos:expositor_petisco_frutas" then
		if fields.comprar then
			local sender_name = player:get_player_name()
			local sender_inv = player:get_inventory()
			if not sender_inv:contains_item("main", sunos.var.moeda.." "..custo_petisco) then
				minetest.chat_send_player(sender_name, S("Precisa pagar por isso"))
				return
			elseif not sender_inv:room_for_item("main", "sunos:petisco 1") then
				minetest.chat_send_player(sender_name, S("Inventario Lotado"))
				return
			end
			-- retirando itens do inventario
			local i = 0
			while i < custo_petisco do -- 1 eh o tanto que quero tirar
				sender_inv:remove_item("main", sunos.var.moeda.." 1") -- tira 1
				i = i + 1
			end
			sender_inv:add_item("main", "sunos:petisco 1")
		end
	end
end)


