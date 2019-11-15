--[[
	Mod Sunos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Casa dos sunos
  ]]

-- Funções para geração de tabelas de itens de reposição
sunos.estruturas.taverna.gerar_itens_repo = {}
-- Gerar itens de reposição para taverna nivel 1
sunos.estruturas.taverna.gerar_itens_repo["1"] = function()
	return {
		bancadas = {
			{"sunos:bau_taverna", 1},
		},
		sobrebancadas = {
			{"sunos:barril", 1},
		},
		simples = {
			{"sunos:nectar_node_nodrop", 3},
		},
	}
end
-- Gerar itens de reposição para taverna nivel 2
sunos.estruturas.taverna.gerar_itens_repo["2"] = function()
	return {
		bancadas = {
			{"sunos:bau_taverna", 1},
		},
		sobrebancadas = {
			{"sunos:barril", 2},
		},
		simples = {
			{"sunos:nectar_node_nodrop", 5},
		},
	}
end


