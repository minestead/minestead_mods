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
sunos.npcnode = {} 

-- Configurar um npcnode
--[[ 
	Definições:
	
	-- Tipo de NPC registrado nos sunos
	tipo = "",
	
	-- Ocupação do NPC (registrada na API advanced_npc)
	occupation = "",
	
	-- Node spawner de cada horario
	checkin = {
		["0"] = {x=0, y=0, z=0}, 
		["1"] = {x=0, y=0, z=0},
		["2"] = {x=0, y=0, z=0},
		...
		["23"] = {x=0, y=0, z=0}
	},

  ]]
sunos.npcnode.set_npcnode = function(pos, def)
	
	local meta = minetest.get_meta(pos)
	
	-- Data da escolha
	local data = minetest.get_day_count()
	
	-- Registra checkins nos spawners
	for time,pc in pairs(def.checkin) do
		sunos.npc_checkin.add_checkin(pc, pos, time)
	end
	
	-- Armazena dados no bau
	meta:set_string("sunos_npc_tipo", def.tipo)
	meta:set_string("sunos_npc_occupation", def.occupation)
	meta:set_string("sunos_mynpc_checkin", minetest.serialize(def.checkin))
	
end

sunos.npcnode.atribuir_npc = function(pos, self)
	
	local meta = minetest.get_meta(pos)
	
	-- Salva checkin do node no NPC
	self.sunos_checkin = minetest.deserialize(meta:get_string("sunos_mynpc_checkin"))
	
	-- Inicializa variaveis de ocupação
	npc.occupations.initialize_occupation_values(self, self.sunos_occupation)
end
