--[[
	Mod Sunos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Diretrizes do emporio
  ]]

-- Tradução de strings
local S = sunos.Sfake

sunos.estruturas.emporio.var = {}

-- Tabela de niveis de acordo com população
sunos.estruturas.emporio.var.niveis = {
	10, -- nivel 1
	16, -- nivel 2
}

-- Insere o item para ser vendido na casa comunal
sunos.estruturas.comunal.var.tb_menu_comunal[S("Emporio")] = {
	desc = S("O principal lugar para comprar itens comuns dos sunos."),
	pop = sunos.estruturas.emporio.var.niveis[1],
	item_add = "sunos:fundamento_emporio", 
	item_rem = {"default:tree 15", "default:cobble 40", "default:torch 10", "farming:straw 30"}
}
