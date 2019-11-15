--[[
	Mod Sunos para Minetest
	Copyright (C) 2018 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Cronograma de tarefas do NPC das casas
  ]]

-- Tradução de strings
local S = sunos.S

-- Interagir em casa
sunos.estruturas.casa.interagir_casa = {
	[1] = {
		program_name = "sunos:interagir_mobilia",
		arguments = {
			place_names = {
				"bau_primario",
				"compostagem_1",
				"compostagem_2",
				"tear_1",
				"tear_2",
				"bancada_de_trabalho_1",
				"bancada_de_trabalho_2",
				"kit_culinario_1",
				"kit_culinario_2",
				"caixa_de_musica_1",
				"caixa_de_musica_2",
			},
		},
		is_state_program = true,
	},
}

-- Interagir na feirinha
sunos.estruturas.casa.interagir_feirinha = {
	[1] = {
		program_name = "sunos:interagir_mobilia",
		arguments = {
			search = {
				"sunos:bau_loja",
			},
			search_dist = 5,
		},
		is_state_program = true,
	},
}

-- Durmir
sunos.estruturas.casa.durmir = {
	[1] = {
		program_name = "advanced_npc:internal_property_change",
		arguments = {
			property = "flag",
			args = {
				action = "set",
				flag_name = "sunos_repouso_status",
				flag_value = "durmir",
			}
		},
	},
}

