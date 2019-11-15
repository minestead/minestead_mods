--[[
	Mod Sunos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Kit reparador de estruturas
  ]]

-- Tradução de strings
local S = sunos.S

-- Kit reparador de estruturas
minetest.register_craftitem("sunos:kit_reparador", {
	description = S("Kit Reparador de estrutura dos Sunos"),
	inventory_image = "sunos_fundamento_estrutura_namao.png^sunos_kit_reparador.png",
	stack_max = 1,
})

