--[[
	Mod Sunos para Minetest
	Copyright (C) 2018 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Sistema de spawner de NPC
	
	É básicamente um sistema que faz os NPCs estarem ou irem para 
	determinados lugares do mapa que podem estar longe ou inativos.
  ]]

-- API de checkins
sunos.npc_checkin = {} 

-- Spawners
sunos.npc_checkin.spawners = {}

-- Função para spawnar NPC
sunos.npc_checkin.registered_spawners = {}


-- Montar checkin
sunos.npc_checkin.montar_checkin_simples = function(pos)
	local checkin = {}
	for x=0, 23 do
		checkin[tostring(x)] = pos
	end
	return checkin
end


-- Conversões padrão para indexição de coordenadas
local pos_to_string = function(pos)
	return pos.x.." "..pos.y.." "..pos.z
end
local string_to_pos = function(st)
	local p = string.split(st, " ")
	return {x=tonumber(p[1]), y=tonumber(p[2]), z=tonumber(p[3])}
end
local ppp = ""
-- Pegar checkin de um node
sunos.npc_checkin.get_checkin = function(pos, time)
	local checkin = minetest.get_meta(pos):get_string("sunos_npc_checkin_"..time)
	if checkin == "" then
		return {}
	end
	return minetest.deserialize(checkin)
end
local get_checkin = sunos.npc_checkin.get_checkin
-- Salvar checkin em um node
sunos.npc_checkin.set_checkin = function(pos, checkin, time)
	minetest.get_meta(pos):set_string("sunos_npc_checkin_"..time, minetest.serialize(checkin))
end
local set_checkin = sunos.npc_checkin.set_checkin
-- Adiciona novo checkin em um node
sunos.npc_checkin.add_checkin = function(pos, npcnode_pos, time)
	local checkin = get_checkin(pos, time)
	checkin[pos_to_string(npcnode_pos)] = {
		nodename = minetest.get_node(npcnode_pos).name,
	}
	set_checkin(pos, checkin, time)
end
local add_checkin = sunos.npc_checkin.add_checkin


-- Pegar dados do NPC
local get_mynpc_checkin = function(pos)
	local mynpc_checkin = minetest.get_meta(pos):get_string("sunos_mynpc_checkin")
	if mynpc_checkin == "" then
		return
	end
	return minetest.deserialize(mynpc_checkin)
end
-- Salvar dados do NPC
local set_mynpc = function(pos, mynpc)
	minetest.get_meta(pos):set_string("sunos_mynpc_checkin", minetest.serialize(mynpc))
end

-- Registrar Node spawner para marcar checkin
--[[
	Isso irá marar um node para ser verificado com 
	relação ao surgimento do NPC registrado no node.
	Argumentos:
	#1 Nodename do node spawner
	#2 Tabela de definições:
		func_spawn = function(pos, tipo) end, -- Função que analisa local em torno e spawna NPC
  ]]
sunos.npc_checkin.register_spawner = function(nodename, def)
	
	-- Insere na tabela
	table.insert(sunos.npc_checkin.spawners, nodename)
	
	sunos.npc_checkin.registered_spawners[nodename] = {}
	
	sunos.npc_checkin.registered_spawners[nodename].func_spawn = def.func_spawn
	
	-- Cria ou atualiza ABM para tentar spawnar NPCs
	minetest.register_abm{
		label = "sunos:spawner_checkin",
		nodenames = sunos.npc_checkin.spawners,
		interval = 30,
		chance = 1,
		action = function(pos)
			
			-- Pegar node atual
			local node = minetest.get_node(pos)
			
			-- Pega metadados
			local meta = minetest.get_meta(pos)
			
			-- Hora atual no jogo
			local time = sunos.npcs.npc.get_time()
			
			-- Verifica metadados de checkin
			local checkin = get_checkin(pos, time)
			-- Verifica checkins registrados
			--[[
				Tabela de checkins possui uma tabela chamada registros de checkins
				em que se constitui assim:
				{
					["x y z"] = { -- coordenada do node que registrou o checkin e que registra em si mesmo o NPC
						nodename = "itemstring", -- do node que registrou o checkin
					},
					["x y z"] = {
						nodename = "itemstring",
					},
				}
				Exemplo:
				{
					["-3489 9 9888"] = {
						nodename = "mymod:bau"
					}
					["-14555 11 911"] = {
						nodename = "mymod:tree"
					}
				}
			]]
			
			if checkin then
				
				for pos_npc_st,dados in pairs(checkin) do
				
					-- npcnode que registrou o checkin nesse spawner
					local pos_npc = string_to_pos(pos_npc_st)
					-- Verifica se NPC desse node já está ativo
					if sunos.npcs.is_active(pos_npc) ~= true then
					
						-- Verificar dados do npc
						local mynpc_checkin = get_mynpc_checkin(pos_npc)
						
						-- Registro de checkins
						if mynpc_checkin then
						
							if pos_to_string(mynpc_checkin[tostring(time)]) == pos_to_string(pos) 
								and sunos.npc_checkin.registered_spawners[node.name]
							then
							
								-- Spawna o NPC na região comum
								sunos.npc_checkin.registered_spawners[node.name].func_spawn(
									pos,
									minetest.get_meta(pos_npc):get_string("sunos_npc_tipo"),
									pos_npc
								)
								
							else -- Registro não coincide
								checkin[pos_npc_st] = nil
							end
							
						else -- Registro do npc não existe
							checkin[pos_npc_st] = nil
						end
									
					end
				end
				
				-- Atualiza checkin com registros falhos removidos
				set_checkin(pos, checkin, time)
				
			end
			
		end,
	}

end

-- Registrar Spawner
sunos.npc_checkin.register_spawner("sunos:fundamento", {
	func_spawn = function(pos, npc_tipo, npcnode_pos)
		
		local meta = minetest.get_meta(pos)
		
		local spos = sunos.npcs.select_pos_spawn(pos, {tipo = "fundamento"})
		
		if spos then
			-- Spawnar um novo npc na casa
			sunos.npcs.npc.spawn(npc_tipo, minetest.get_meta(pos):get_string("vila"), npcnode_pos, spos)
		end
	end,
})

