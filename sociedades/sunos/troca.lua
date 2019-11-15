--[[
	Mod Sunos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Operações de troca de itens
  ]]

-- Lib tror
local tror = dofile(minetest.get_modpath("sunos").."/lib/tror.lua")

-- Trocar itens
sunos.trocar_itens = tror.trocar

-- Plucar itens "PLUS"
sunos.trocar_plus = tror.trocar_plus
