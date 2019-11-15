--[[
	Mod Sunos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Loja dos sunos
  ]]

-- Tradução de strings
local S = sunos.S

-- Bau de venda simples
minetest.register_node("sunos:bau_loja", {
	description = S("Bau de Venda dos Sunos"),
	tiles = {"default_chest_top.png^sunos_bau_topo.png", "default_chest_top.png", "default_chest_side.png^sunos_bau_lado.png",
		"default_chest_side.png^sunos_bau_lado.png", "default_chest_side.png^sunos_bau_lado.png", "default_chest_lock.png^sunos_bau_frente.png"},
	paramtype2 = "facedir",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
	legacy_facedir_simple = true,
	is_ground_content = false,
	sounds = default.node_sound_wood_defaults(),
	drop = "",
	
	-- Nao pode ser escavado/quebrado por jogadores
	can_dig = function(pos, player)
		return minetest.check_player_privs(player, {server=true})
	end,
	
	-- Receptor dos botos
	on_receive_fields = function(pos, formname, fields, sender)
		if fields.trocar_madeira then
			-- Tenta trocar
			if sunos.trocar_plus(sender, {"default:tree"}, {"default:apple 2"}) == false then
				return minetest.chat_send_player(sender:get_player_name(), S("Precisa do item para trocar"))
			else
				return minetest.chat_send_player(sender:get_player_name(), S("Troca feita"))
			end
		elseif fields.trocar_pedra then
			-- Tenta trocar
			if sunos.trocar_plus(sender, {"default:stonebrick"}, {"default:apple 2"}) == false then
				return minetest.chat_send_player(sender:get_player_name(), S("Precisa do item para trocar"))
			else
				return minetest.chat_send_player(sender:get_player_name(), S("Troca feita"))
			end
		elseif fields.trocar_ouro then
			-- Tenta trocar
			if sunos.trocar_plus(sender, {"default:gold_ingot"}, {"default:apple 10"}) == false then
				return minetest.chat_send_player(sender:get_player_name(), S("Precisa do item para trocar"))
			else
				return minetest.chat_send_player(sender:get_player_name(), S("Troca feita"))
			end
		elseif fields.trocar_ferro then
			-- Tenta trocar
			if sunos.trocar_plus(sender, {"default:steel_ingot"}, {"default:apple 6"}) == false then
				return minetest.chat_send_player(sender:get_player_name(), S("Precisa do item para trocar"))
			else
				return minetest.chat_send_player(sender:get_player_name(), S("Troca feita"))
			end
		elseif fields.trocar_carvao then
			-- Tenta trocar
			if sunos.trocar_plus(sender, {"default:coal_lump"}, {"default:apple 2"}) == false then
				return minetest.chat_send_player(sender:get_player_name(), S("Precisa do item para trocar"))
			else
				return minetest.chat_send_player(sender:get_player_name(), S("Troca feita"))
			end
		elseif fields.trocar_vidro then
			-- Tenta trocar
			if sunos.trocar_plus(sender, {"default:glass"}, {"default:apple 2"}) == false then
				return minetest.chat_send_player(sender:get_player_name(), S("Precisa do item para trocar"))
			else
				return minetest.chat_send_player(sender:get_player_name(), S("Troca feita"))
			end
		end
	end,
})

