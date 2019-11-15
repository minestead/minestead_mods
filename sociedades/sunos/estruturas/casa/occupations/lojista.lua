--[[
	Mod Sunos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Roteiro para NPC caseiro lojista
	
	Esse NPC apenas vai na loja e volta para casa
  ]]

-- Tradução de strings
local S = sunos.S

local interagir_casa = sunos.estruturas.casa.interagir_casa

local interagir_feirinha = sunos.estruturas.casa.interagir_feirinha

-- Registra ocupação padrão no NPC caseiro
npc.occupations.register_occupation("sunos_npc_caseiro_lojista", {
	dialogues = {},
	textures = {
		{name="sunos_npc_male.png", tags={"male", "adult", "sunos_npc_caseiro_lojista"}},
		{name="sunos_npc_female.png", tags={"female", "adult", "sunos_npc_caseiro_lojista"}}
	},
	building_types = {},
	surrounding_building_types = {},
	walkable_nodes = sunos.estruturas.casa.walkable_nodes,
	initial_inventory = {},
	schedules_entries = {
		
		-- Durmir
		[0] = sunos.estruturas.casa.durmir,
		[1] = sunos.estruturas.casa.durmir,
		[2] = sunos.estruturas.casa.durmir,
		[3] = sunos.estruturas.casa.durmir,
		[4] = sunos.estruturas.casa.durmir,
		[5] = sunos.estruturas.casa.durmir,
		[6] = sunos.estruturas.casa.durmir,
		[7] = sunos.estruturas.casa.acordar,
		-- Olhar a feirinha
		[8] = interagir_feirinha,
		[9] = interagir_feirinha,
		[10] = interagir_feirinha,
		[11] = interagir_feirinha,
		[12] = interagir_feirinha,
		[13] = interagir_feirinha,
		[14] = interagir_feirinha,
		-- Mecher em casa
		[15] = interagir_casa,
		[16] = interagir_casa,
		[17] = interagir_casa,
		[18] = interagir_casa,
		[19] = interagir_casa,
		[20] = interagir_casa,
		[21] = interagir_casa,
		-- Durmir
		[22] = sunos.estruturas.casa.durmir,
		[23] = sunos.estruturas.casa.durmir
	}
			
})
