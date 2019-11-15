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

-- Envia uma formspec simples de aviso
local avisar = function(player, texto)
	if not player then
		minetest.log("error", "[Sunos] player nulo (em avisar do script interface.lua)")
		return false
	end
	if not texto then
		minetest.log("error", "[Sunos] texto nulo (em avisar do script interface.lua)")
		return false
	end
	
	minetest.show_formspec(player:get_player_name(), "sunos:npc", "size[12,1]"
		..default.gui_bg
		..default.gui_bg_img
		.."label[0.5,0;"..S("Aviso").." \n"..texto.."]")
	return true
end

-- Acessar NPC
sunos.npcs.npc.registrados.caseiro.on_rightclick = function(ent, player)
	
	-- Verifica se NPC ainda existe
	if not ent or not player then
		return
	end
	
	-- Verifica se o jogador é inimigo da vila
	if sunos.verif_inimigo(ent.vila, player:get_player_name()) == true then
		return
	end
	
	-- Verifica a tabela volatil de 'casa'
	if not sunos.online[player:get_player_name()].casa then sunos.online[player:get_player_name()].casa = {} end
	
	-- Armazena a entidade que esta sendo acessada
	sunos.online[player:get_player_name()].casa.ent_acesso = ent
	
	-- Verifica se nao tem casa comunal e oferece para construir
	if sunos.bd.verif("vila_"..ent.vila, "comunal") == false then
		local formspec = "size[6,3]"
			..default.gui_bg
			..default.gui_bg_img
			.."textarea[0.225,-0.1;6,1.3;;"..S("Oi. Ajude essa vila a montar uma Casa Comunal")..";]"
			.."item_image_button[0,1;1,1;default:tree 20;item1;]" -- Item 1
			.."item_image_button[1,1;1,1;default:stone 70;item2;]" -- Item 2
			.."item_image_button[2,1;1,1;farming:straw 30;item3;]" -- Item 3
			.."item_image_button[5,1;1,1;sunos:fundamento_comunal;fundamento;]" -- Fundamento de Casa Comunal
			.."button_exit[0,2;6,1;trocar;"..S("Trocar por Fundamento").."]"
		return minetest.show_formspec(player:get_player_name(), "sunos:npcs_npc_caseiro", formspec)
	end
	
	-- Avisa para ir ate a casa comunal
	return minetest.chat_send_player(player:get_player_name(), S("Nenhuma atividade disponivel"))
	
end

-- Receptor de botoes
minetest.register_on_player_receive_fields(function(player, formname, fields)

	-- NPC suno comum
	if formname == "sunos:npcs_npc_caseiro" then 
		local name = player:get_player_name()
		
		-- Validar entidade acessada
		if not sunos.online[name].casa.ent_acesso then return end
		
		-- Verifica se o jogador é inimigo da vila
		if sunos.verif_inimigo(sunos.online[name].casa.ent_acesso.vila, name) == true then
			return
		end
		
		if fields.trocar then -- Trocar fundamento de casa comunal
			local desc_item = minetest.registered_nodes["sunos:fundamento_comunal"].description
			-- Tenta trocar pelo fundamento de casa comunal
			if sunos.trocar_plus(player, 
				{"default:tree 20", "default:stone 70", "farming:straw 30"}, 
				{"sunos:fundamento_comunal"}
			) == false 
			then
				return minetest.chat_send_player(name, S("Precisa dos itens exigidos para obter @1", "'"..desc_item.."'"))
			else
				minetest.chat_send_player(name, S("Recebeste @1", "'"..desc_item.."'"))
				minetest.chat_send_player(name, S("Coloque em um local adequado para que seja construida"))
				return
			end
		end
	end
	
end)
