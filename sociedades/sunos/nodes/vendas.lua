--[[
	Mod Sunos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Itens para vendas
  ]]

-- Tradução de strings
local S = sunos.S

-- Caixa de Vendas
minetest.register_node("sunos:caixa_venda", {
	description = S("Caixa de Vendas"),
	tiles = {
		"sunos_caixa_venda_cima.png", -- Cima 
		"default_wood.png", -- Baixo
		"default_wood.png^sunos_caixa_venda_lado.png", -- Direita
		"default_wood.png^sunos_caixa_venda_lado.png", -- Esquerda
		"default_wood.png^sunos_caixa_venda_lado.png", -- Fundo
		"default_wood.png^sunos_caixa_venda_lado.png" -- Frente
	},
	paramtype2 = "facedir",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
	sounds = default.node_sound_wood_defaults(),
	paramtype = "light",
	drop = "",
	
	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
	
		-- Verificar item que está em cima
		local nn = minetest.get_node({x=pos.x, y=pos.y+1, z=pos.z}).name
		if not sunos.var.vendas[nn] then return end
		
		-- Salva o item que o jogador esta acessando nas vendas
		sunos.online[player:get_player_name()].vendas = nn
		
		-- Dados da venda
		local d = sunos.var.vendas[nn]
		
		-- String para o formspec
		local st = ""
		do
			-- Se for formato tabela
			if d.itemstack.name then
				st = d.itemstack.name
				if d.itemstack.count then
					st = st .. " " .. d.itemstack.count
				end
			-- formato tabela
			else
				st = d.itemstack
			end
		end
		
		local formspec = "size[8,8.2]"
			..default.gui_bg
			..default.gui_bg_img
			..default.gui_slots
			
			.."item_image_button[0.5,0;4,4;"..st..";item1;]"
			.."item_image_button[4.5,0;3,3;"..sunos.var.moeda.." "..d.custo..";item2;]"
			.."button[4.5,3;3,1;comprar;Comprar]"
			
			.."list[current_player;main;0,4.25;8,1;]"
			.."list[current_player;main;0,5.5;8,3;8]"
			..default.get_hotbar_bg(0,4.25)
			
		minetest.show_formspec(player:get_player_name(), "sunos:caixa_venda", formspec)
	end,
})

-- Receptor de botoes
minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname == "sunos:caixa_venda" then
		if fields.comprar then
			
			-- Pegar dados
			local d = sunos.var.vendas[sunos.online[player:get_player_name()].vendas]
			
			local inv = player:get_inventory()
			
			if inv:room_for_item("main", d.itemstack) and inv:contains_item("main", sunos.var.moeda.." "..d.custo) then
				inv:remove_item("main", sunos.var.moeda.." "..d.custo)
				inv:add_item("main", d.itemstack)
			end
		end
	end
end)
