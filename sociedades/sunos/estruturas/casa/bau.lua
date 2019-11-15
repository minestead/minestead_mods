--[[
	Mod Sunos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Bau da casa dos sunos
  ]]

-- Tradução de strings
local S = sunos.S

-- Tempo para cada ciclo de on_timer
local timeout_bau = 180

-- Bau dos sunos
--[[
	Esse é o node que tem nas casas dos sunos
]]
minetest.register_node("sunos:bau_casa", {
	description = S("Bau da Casa dos Sunos"),
	tiles = {"default_chest_top.png^sunos_bau_topo.png", "default_chest_top.png", "default_chest_side.png^sunos_bau_lado.png",
		"default_chest_side.png^sunos_bau_lado.png", "default_chest_side.png^sunos_bau_lado.png", "default_chest_lock.png^sunos_bau_frente.png"},
	paramtype2 = "facedir",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, not_in_creative_inventory=1},
	legacy_facedir_simple = true,
	is_ground_content = false,
	sounds = default.node_sound_wood_defaults(),
	drop = "",
	
	-- Nao pode ser escavado/quebrado por jogadores
	on_dig = function() end,
})

-- Altera a ocupação do NPC de acordo com a vila atual
minetest.register_abm({
	nodenames = {"sunos:bau_casa"},
	interval = 5,--300, -- 5 min
	chance = 1,
	action = function(pos)
		local meta = minetest.get_meta(pos)
		local ultima_data = meta:get_string("occupation_date")
		if ultima_data == "" 
			or tonumber(ultima_data)+2 <= minetest.get_day_count() -- No 2º dia apos a ultima data
		then
			
			-- Cria nova ocupação e configura npcnode
			local occupation, checkin = sunos.estruturas.casa.select_occupation(pos, meta:get_string("vila"))
			sunos.npcnode.set_npcnode(pos, {
				tipo = "caseiro",
				occupation = occupation,
				checkin = checkin,
			})
			-- Data da ocupação
			meta:set_string("occupation_date", minetest.get_day_count())
		end
	end,
})

-- Registrar Spawner
sunos.npc_checkin.register_spawner("sunos:bau_casa", {
	func_spawn = function(pos, npc_tipo, npcnode_pos)
		
		local meta = minetest.get_meta(pos)
		
		-- Verifica fundamento
		local pf = sunos.verificar_fundamento_bau_sunos(pos)
		if not pf then return end
		
		local spos = sunos.npcs.select_pos_spawn(pf, {tipo = "fundamento"})
		
		if spos then
			-- Spawnar um novo npc na casa
			sunos.npcs.npc.spawn(npc_tipo, minetest.get_meta(pos):get_string("vila"), npcnode_pos, spos)
		end
	end,
})

