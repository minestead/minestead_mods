--[[
	Mod Sunos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Diretrizes do taverna
  ]]

-- Tradução de strings
local S = sunos.Sfake

sunos.estruturas.taverna.var = {}

-- Tabela de niveis de acordo com população
sunos.estruturas.taverna.var.niveis = {
	15, -- nivel 1
	20, -- nivel 2
}

-- Insere o item para ser vendido na casa comunal
sunos.estruturas.comunal.var.tb_menu_comunal[S("Taverna")] = {
	desc = S("Uma bom ponto de encontro dos sunos onde podem ser comprados alguns itens especiais."),
	pop = sunos.estruturas.taverna.var.niveis[1],
	item_add = "sunos:fundamento_taverna", 
	item_rem = {"default:tree 15", "default:cobble 40", "default:torch 10", "farming:straw 30"}
}
