--[[
	Mod Sovagxas para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Inicializador de scripts
  ]]

-- Variavel grobal dos metodos
sovagxas = {}

-- Versão do projeto (MAJOR.MINOR)
sovagxas.versao = "3.0"

-- Versoes compativeis
sovagxas.versao_comp = {
	--["2.0"] = true, -- Exemplo
}

-- Notificador de Inicializador
local notificar = function(msg)
	if minetest.setting_get("log_mods") then
		minetest.debug("[SOVAGXAS]"..msg)
	end
end

-- Modpath
local modpath = minetest.get_modpath("sovagxas")

-- Carregar scripts
notificar("Carregando...")
dofile(modpath.."/diretrizes.lua")
dofile(modpath.."/tradutor.lua")
dofile(modpath.."/compatibilidade.lua")
dofile(modpath.."/nodes/totem.lua")
dofile(modpath.."/nodes/bancada.lua")
dofile(modpath.."/nodes/bau.lua")
dofile(modpath.."/nodes/jungleleaves.lua")
dofile(modpath.."/npc.lua")
dofile(modpath.."/arvore.lua")
dofile(modpath.."/mapgen.lua")
dofile(modpath.."/craftitens.lua")
notificar("[OK]!")
