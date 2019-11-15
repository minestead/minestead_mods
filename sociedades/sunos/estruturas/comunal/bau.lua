--[[
	Mod Sunos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Bau da casa comunal dos sunos
  ]]

-- Tradução de strings
local S = sunos.S

-- Bau dos sunos
--[[
	Esse é o node que tem nas casas dos sunos
]]
minetest.register_node("sunos:bau_comunal", {
	description = S("Bau da Casa Comunal dos Sunos"),
	tiles = {"default_chest_top.png^sunos_bau_topo.png", "default_chest_top.png", "default_chest_side.png^sunos_bau_lado.png",
		"default_chest_side.png^sunos_bau_lado.png", "default_chest_side.png^sunos_bau_lado.png", "default_chest_lock.png^sunos_bau_frente.png"},
	paramtype2 = "facedir",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, not_in_creative_inventory=1},
	legacy_facedir_simple = true,
	is_ground_content = false,
	sounds = default.node_sound_wood_defaults(),
	drop = "default:chest",
	
	-- Nao pode ser escavado/quebrado por jogadores
	on_dig = function() end,
})

-- Registrar Spawner
sunos.npc_checkin.register_spawner("sunos:bau_comunal", {
	func_spawn = function(pos, npc_tipo, npcnode_pos)
		
		local meta = minetest.get_meta(pos)
		
		-- Verifica fundamento
		local pf = sunos.verificar_fundamento_bau_sunos(pos)
		if not pf then return end
		
		local spos
		if npc_tipo == "comunal" then
			spos = sunos.npcs.select_pos_spawn(pf, {
				tipo = "fundamento",
				nodes = {"sunos:solo_atendente_comunal"},
			})
		else	
			spos = sunos.npcs.select_pos_spawn(pf, {
				tipo = "fundamento",
			})
		end
		
		if spos then
			-- Spawnar um novo npc na casa
			sunos.npcs.npc.spawn(npc_tipo, minetest.get_meta(pos):get_string("vila"), npcnode_pos, spos)
		end
	end,
})

