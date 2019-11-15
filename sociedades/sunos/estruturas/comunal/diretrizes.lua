--[[
	Mod Sunos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Diretrizes da casa comunal
  ]]

-- Tradução de strings
local S = sunos.Sfake

sunos.estruturas.comunal.var = {}

-- Tabela de niveis de acordo com população
sunos.estruturas.comunal.var.niveis = {
	1, -- nivel 1
	12, -- nivel 2
}


-- Tabela do menu da casa comunal 
sunos.estruturas.comunal.var.tb_menu_comunal = {
	-- Casas
	[S("Casa Pequena")] = { -- Nome do items
		-- Texto descritivo do item
		desc = S("Aumenta um pouco a quantidade de moradores da vila"),
		-- População necessaria
		pop = 0, 
		-- Item a receber (apenas 1 item e 1 unidade)
		item_add = "sunos:fundamento_casa_pequena", 
		-- Itens a pagar (de 1 a 14 itens diferentes de qualquer quantidade) 
		item_rem = {"default:tree 15", "default:cobble 25", "default:glass 10", "default:torch 10", "farming:straw 20"}
	},
	[S("Casa Mediana")] = {
		desc = S("Aumenta a quantidade de moradores da vila"),
		pop = 0,
		item_add = "sunos:fundamento_casa_mediana", 
		item_rem = {"default:tree 25", "default:cobble 30", "default:glass 15", "default:torch 15", "farming:straw 30"}
	},
	[S("Casa Grande")] = {
		desc = S("Aumenta bastante a quantidade de moradores da vila"),
		pop = 0,
		item_add = "sunos:fundamento_casa_grande", 
		item_rem = {"default:tree 35", "default:cobble 45", "default:glass 20", "default:torch 20", "farming:straw 40"}
	},
	-- Fundamento de Loja
	[S("Feirinha")] = {
		desc = S("Uma feirinha simples para trocar itens"),
		pop = 5,
		item_add = "sunos:fundamento_loja", 
		item_rem = {"default:tree 10", "default:cobble 20", "default:torch 4", "farming:straw 15"}
	},
}
