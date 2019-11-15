--[[
	Mod Sunos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Interface
  ]]

-- Tradução de strings
local S = sunos.S

-- Custo de uma broa de frutas
local custo_broa_frutas = tonumber(minetest.setting_get("sunos_item_broa_frutas_custo") or 8)
-- Custo de uma garrafa de Nectar de fruta dos sunos
local custo_nectar = tonumber(minetest.setting_get("sunos_item_nectar_custo") or 6)

-- Acessar NPC
sunos.npcs.npc.registrados.barman.on_rightclick = function(ent, player)
	
	-- Verifica se NPC ainda existe
	if not ent or not player then
		return
	end
	
	-- Verifica se o jogador é inimigo da vila
	if sunos.verif_inimigo(ent.vila, player:get_player_name()) == true then
		return
	end
	
	-- Verifica a tabela volatil de 'taverna'
	if not sunos.online[player:get_player_name()].taverna then sunos.online[player:get_player_name()].taverna = {} end
	
	-- Armazena a entidade que esta sendo acessada
	sunos.online[player:get_player_name()].taverna.ent_acesso = ent
	
	-- Enviar formspec para compras
	local formspec = "size[6,3]"
		..default.gui_bg
		..default.gui_bg_img
		.."item_image_button[0,0;3,3;sunos:nectar "..custo_nectar..";item1;]" -- Item 1
		.."item_image_button[3,0;3,3;sunos:broa_frutas "..custo_broa_frutas..";item2;]" -- Item 2
	return minetest.show_formspec(player:get_player_name(), "sunos:npcs_npc_barman", formspec)	
end

-- Receptor de botoes
minetest.register_on_player_receive_fields(function(player, formname, fields)

	-- NPC suno comum
	if formname == "sunos:npcs_npc_barman" then 
		local name = player:get_player_name()
		
		-- Validar entidade acessada
		if not sunos.online[name].taverna.ent_acesso then return end
		
		-- Verifica se o jogador é inimigo da vila
		if sunos.verif_inimigo(sunos.online[name].taverna.ent_acesso.vila, name) == true then
			return
		end
		
		-- Comprar item1
		if fields.item1 then
			
			local sender_name = player:get_player_name()
			local sender_inv = player:get_inventory()
			if not sender_inv:contains_item("main", sunos.var.moeda.." "..custo_nectar) then
				minetest.chat_send_player(sender_name, S("Precisa pagar por isso"))
				return
			elseif not sender_inv:room_for_item("main", "sunos:nectar 1") then
				minetest.chat_send_player(sender_name, S("Inventario Lotado"))
				return
			end
			-- retirando itens do inventario
			local i = 0
			while i < custo_nectar do -- 1 eh o tanto que quero tirar
				sender_inv:remove_item("main", sunos.var.moeda.." 1") -- tira 1
				i = i + 1
			end
			sender_inv:add_item("main", "sunos:nectar 1")
			
		-- Comprar item2
		elseif fields.item2 then
		
			local sender_name = player:get_player_name()
			local sender_inv = player:get_inventory()
			if not sender_inv:contains_item("main", sunos.var.moeda.." "..custo_broa_frutas) then
				minetest.chat_send_player(sender_name, S("Precisa pagar por isso"))
				return
			elseif not sender_inv:room_for_item("main", "sunos:broa_frutas 1") then
				minetest.chat_send_player(sender_name, S("Inventario Lotado"))
				return
			end
			-- retirando itens do inventario
			local i = 0
			while i < custo_broa_frutas do -- 1 eh o tanto que quero tirar
				sender_inv:remove_item("main", sunos.var.moeda.." 1") -- tira 1
				i = i + 1
			end
			sender_inv:add_item("main", "sunos:broa_frutas 1")
		
		end
	end
	
end)
