--[[
	Mod Sunos para Minetest
	Copyright (C) 2018 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Diretrizes gerais
  ]]


-- Salvar dados variaveis
sunos.var = {}

-- Configurações / Settings
--[[ 
	Quanto maior, mais raro (Minimo é 1).
	The less, more rare (Minimo is 1).
  ]]
sunos.var.CHANCE = tonumber(minetest.setting_get("sunos_chance") or 25)

-- Intervalo de tempo (em segundos) que uma vila se mantem inimigo de um jogador apos ser atacada
sunos.var.tempo_inimigo = 300

-- Intervalo para verificar se estrutura esta danificada para tentar reformar
sunos.var.tempo_verif_restauro = 600

-- Intervalo de tempo (em segundos) de verificação dos rastreadores de jogadores perto de fundamentos dos sunos
sunos.var.tempo_atualizar_jogadores_perto = 5

-- Tempo (em segundos) entre as verificações de estrutura obstruida
sunos.var.tempo_verif_estruturas = tonumber(minetest.setting_get("sunos_verif_fundamento") or 120)

-- Tempo (em segundos) em que uma casa comunal pode ficar em decadencia antes de perder o fundamento
sunos.var.tempo_decadencia = tonumber(minetest.setting_get("sunos_comunal_decadencia") or 300)

-- Moeda monetaria usada para trocas comerciais mais formais
sunos.var.moeda = minetest.setting_get("sunos_moeda") or "default:apple"

-- Limite de nodes destruidos em uma estrutura para justificar abandono
sunos.var.limite_nodes_destruidos_abandonar = 8

-- Construir estruturas instantaneamente
sunos.var.instant_structure_build = (minetest.settings:get("sunos_instant_structure_build") == "true") or false

-- Limite de população das vilas
sunos.var.max_pop = 40

-- Notificar mensagens de depuração (para desenvolvimento)
sunos.var.debug_info = (minetest.settings:get("sunos_enable_debug_notify") == "true") or false

-- Nomes de NPCs (derivados do esperanto)
sunos.var.npc_names = {
	male = {
		"Lumo", -- Luz
		"Racio", -- Razão
		"Honoro", -- Honra
		"Akurata", -- Pontual
		"Bonfama", -- de boa fama
		"Bonulo", -- Bom
		"Kora", -- Cordial
		"Negro", -- Negro
		"Obei", -- Obedecer
		"Obstini", -- Teimar
		"Poeto", -- Poeta
		"Trunko", -- Tronco
		"Flavo", -- Amarelo
	},
	female = {
		"Flava", -- Amarela
		"Hela", -- Luminosa
		"Brava", -- valente
		"Afable", -- Amavel
		"Bela", -- Bela
		"Danka", -- Grato
		"Eleganta", -- Elegante
		"Epopea", -- Épico
		"Negra", -- Negra
		"Nigra", -- Negra
		"Obeema", -- Obediente
	},
}
for _, name in ipairs(sunos.var.npc_names.male) do
	npc.info.register_name(name, {"male", "sunos"})
end
for _, name in ipairs(sunos.var.npc_names.female) do
	npc.info.register_name(name, {"female", "sunos"})
end

-- Nodes de mobilias (index é o place_name)
-- Exemplo: sunos.nodes_de_mobilias["bau_primario"] = {"sunos:bau_casa"}
sunos.nodes_de_mobilias = {}

-- Nodes trocados na montagem de qualquer estrutura
sunos.var.nodes_trocados = {
	
	-- Estruturais
	["default:tree"] = "sunos:tree_nodrop",
	["default:wood"] = "sunos:wood_nodrop",
	["default:cobble"] = "sunos:cobble_nodrop",
	["default:glass"] = "sunos:glass_nodrop",
	["farming:straw"] = "sunos:straw_nodrop",
	["default:stonebrick"] = "sunos:stonebrick_nodrop",
	
	-- Stairs
	["stairs:stair_straw"] = "sunos:stair_straw_nodrop",
	["stairs:slab_straw"] = "sunos:slab_straw_nodrop",
	["stairs:stair_inner_straw"] = "sunos:stair_inner_straw_nodrop",
	["stairs:stair_outer_straw"] = "sunos:stair_outer_straw_nodrop",
	["stairs:stair_wood"] = "sunos:stair_wood_nodrop",
	["stairs:slab_wood"] = "sunos:slab_wood_nodrop",
	["stairs:stair_inner_wood"] = "sunos:stair_inner_wood_nodrop",
	["stairs:stair_outer_wood"] = "sunos:stair_outer_wood_nodrop",
	["stairs:stair_cobble"] = "sunos:stair_cobble_nodrop",
	["stairs:slab_cobble"] = "sunos:slab_cobble_nodrop",
	["stairs:stair_inner_cobble"] = "sunos:stair_inner_cobble_nodrop",
	["stairs:stair_outer_cobble"] = "sunos:stair_outer_cobble_nodrop",
	
	-- Tochas
	["default:torch"] = "sunos:torch_nodrop",
	["default:torch_ceiling"] = "sunos:torch_ceiling_nodrop",
	["default:torch_wall"] = "sunos:torch_wall_nodrop",
	
	-- Moveis
	["default:bookshelf"] = "sunos:default_bookshelf_nodrop",
	["vessels:shelf"] = "sunos:vessels_shelf_nodrop",
	["sunos:bancada"] = "sunos:bancada_nodrop",
	["sunos:bau"] = "sunos:bau_nodrop",
	["sunos:bancada_de_trabalho"] = "sunos:bancada_de_trabalho_nodrop",
	["sunos:carpete_palha"] = "sunos:carpete_palha_nodrop",
	["sunos:tear_palha"] = "sunos:tear_palha_nodrop",
	["sunos:kit_culinario"] = "sunos:kit_culinario_nodrop",
	["sunos:nectar"] = "sunos:nectar_nodrop",
	["sunos:nectar_node"] = "sunos:nectar_node_nodrop",
	["sunos:caixa_de_musica"] = "sunos:caixa_de_musica_nodrop",
	["compost:wood_barrel_empty"] = "sunos:wood_barrel_nodrop",
	
}

-- Listagem de itens para os nodes de venda
sunos.var.vendas = {
	--[[ Exemplo
	["default:dirt"] = {
		itemstack = {name="default:dirt", count=5, wear=0, metadata=""},
		custo = 3,
	},]]
	["sunos:bau_nodrop"] = {
		itemstack = "sunos:bau",
		custo = tonumber(minetest.setting_get("sunos_item_bau_custo") or 20),
	},
	["sunos:bancada_nodrop"] = {
		itemstack = "sunos:bancada",
		custo = tonumber(minetest.setting_get("sunos_item_bancada_custo") or 15),
	},
	["sunos:kit_culinario_nodrop"] = {
		itemstack = "sunos:kit_culinario",
		custo = tonumber(minetest.setting_get("sunos_item_kit_culinario_custo") or 30),
	},
	["sunos:tear_palha_nodrop"] = {
		itemstack = "sunos:tear_palha",
		custo = tonumber(minetest.setting_get("sunos_item_tear_palha_custo") or 25),
	},
	["sunos:bancada_de_trabalho_nodrop"] = {
		itemstack = "sunos:bancada_de_trabalho",
		custo = tonumber(minetest.setting_get("sunos_item_bancada_de_trabalho_custo") or 20),
	},
}

-- Tabela de musicas dos sunos
sunos.var.musicas = {
	["sunos_musica_sol"] = {duracao=26, gain=0.5},
	["sunos_musica_tempo"] = {duracao=30, gain=0.5},
	["sunos_musica_alegria"] = {duracao=22, gain=0.5},
	["sunos_musica_colheita"] = {duracao=37, gain=0.5},
	["sunos_musica_futuro"] = {duracao=23, gain=0.5},
}

-- Tabela de grupos de nodes
sunos.var.node_group = {
	
	-- Nodes andaveis para os NPCs
	walkable = {
		"sunos:carpete_palha",
		"sunos:carpete_palha_nodrop",
		"sunos:torch_nodrop",
		"sunos:torch_ceiling_nodrop",
		"sunos:torch_wall_nodrop"
	},
	
	-- Nodes a terem metadados removidos quando schem for alterada
	remover_metadados = {
		-- Baus
		"sunos:bau_casa",
		"sunos:bau_comunal",
		"sunos:bau_taverna",
		"sunos:bau_loja",
		
		-- Outros
		"default:furnace",
		"default:furnace_active",
		"default:bookshelf", 
		"beds:bed_bottom",
		"vessels:shelf", 
		"sunos:kit_culinario",
		"sunos:kit_culinario_nodrop",
		"sunos:tear_palha",
		"sunos:tear_palha_nodrop",
		"sunos:bancada_de_trabalho",
		"sunos:bancada_de_trabalho_nodrop",
		"sunos:expositor_petisco_frutas",
		"sunos:caixa_venda",
		"sunos:caixa_de_musica",
		"sunos:caixa_de_musica_nodrop",
	},
	
	-- Nodes que compoem uma estrutura dos sunos
	estrutura = {
	
		-- Estrutural
		"sunos:tree_nodrop",
		"sunos:wood_nodrop", 
		"sunos:cobble_nodrop", 
		"sunos:stonebrick_nodrop",
		"sunos:straw_nodrop",
		"sunos:glass_nodrop",
		"sunos:carpete_palha_nodrop",
		
		-- Portas
		"doors:door_wood_a",
		"doors:door_wood_b",
		"doors:gate_wood_open",
		"doors:gate_wood_closed",
				
		-- Stairs
		"stairs:stair_straw",
		"stairs:slab_straw",
		"stairs:stair_inner_straw",
		"stairs:stair_outer_straw",
		"sunos:stair_wood_nodrop",
		"sunos:slab_wood_nodrop",
		"sunos:stair_inner_wood_nodrop",
		"sunos:stair_outer_wood_nodrop",
		"sunos:stair_cobble_nodrop",
		"sunos:slab_cobble_nodrop",
		"sunos:stair_inner_cobble_nodrop",
		"sunos:stair_outer_cobble_nodrop",
		
		-- Tochas
		"sunos:torch_nodrop",
		"sunos:torch_ceiling_nodrop",
		"sunos:torch_wall_nodrop",
		
		-- Moveis
		"sunos:bancada_de_trabalho_nodrop",
		"sunos:bancada_nodrop",
		"sunos:vessels_shelf_nodrop",
		"sunos:default_bookshelf_nodrop",
		"sunos:barril",
		
		-- Baus
		"sunos:bau_nodrop",
		"sunos:bau_casa",
		"sunos:bau_comunal",
		"sunos:bau_taverna",
		"sunos:bau_loja",
		
		-- Objetos simples
		"sunos:nectar_node_nodrop",
		"sunos:nectar_nodrop", -- usado em mostruario
		"sunos:kit_culinario_nodrop",
		"sunos:tear_palha_nodrop",
		"sunos:expositor_petisco_fruta",
	},
	
	-- Nodes que devem ser removidos quando uma estrutura se torna em ruina
	-- Evita que jogadores farmem itens bons em ruinas
	remover_da_ruina = {
		
		-- Estruturais
		"group:glass", 
		"group:fence", 
		"group:ladder", 
		"group:vessel", 
		"group:wool", 
		"group:wood",
		"group:tree",
		"group:door", 
		"group:pane", 
		"default:ladder_wood", 
		"default:ladder_steel", 
		"farming:straw",
		
		-- Stairs
		"sunos:stair_wood_nodrop",
		"sunos:slab_wood_nodrop",
		"sunos:stair_inner_wood_nodrop",
		"sunos:stair_outer_wood_nodrop",
		"sunos:stair_cobble_nodrop",
		"sunos:slab_cobble_nodrop",
		"sunos:stair_inner_cobble_nodrop",
		"sunos:stair_outer_cobble_nodrop",
		"stairs:stair_straw",
		"stairs:slab_straw",
		"stairs:stair_inner_straw",
		"stairs:stair_outer_straw",
		"stairs:stair_wood",
		"stairs:slab_wood",
		"stairs:stair_inner_wood",
		"stairs:stair_outer_wood",
		"stairs:stair_cobble",
		"stairs:slab_cobble",
		"stairs:stair_inner_cobble",
		"stairs:stair_outer_cobble",
		
		-- Objetos simples
		"default:apple", 
		"flowers:mushroom_brown",
		"group:flower",
		
		-- Tochas
		"group:torch", 
		"default:torch", 
		"sunos:torch_nodrop",
		"sunos:torch_ceiling_nodrop",
		"sunos:torch_wall_nodrop",
		
		-- Moveis
		"sunos:kit_culinario_nodrop",
		"sunos:tear_palha_nodrop",
		"sunos:carpete_palha_nodrop",
		"sunos:bancada_de_trabalho_nodrop",
		"sunos:bau_nodrop",
		"sunos:bancada_nodrop",
		"sunos:vessels_shelf_nodrop",
		"sunos:default_bookshelf_nodrop",
		"default:bookshelf", 
		"vessels:shelf", 
		"sunos:bau", 
		"sunos:bau_casa_comunal", 
		"sunos:bau_loja", 
		"sunos:taverna_placa",
		"sunos:emporio_placa",
		"sunos:nectar_nodrop",
		"sunos:barril",
		"sunos:expositor_petisco_frutas",
		"sunos:caixa_venda"
		
	},

}
