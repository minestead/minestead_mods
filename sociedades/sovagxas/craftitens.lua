--[[
	Mod Sovagxas para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Craftitens
  ]]

-- Tradução de strings
local S = sovagxas.S

-- Muda de Arvore dos Sovagxas
minetest.register_craftitem("sovagxas:muda_sovagxas", {
	description = S("Muda de Arvore Sovagxa"),
	inventory_image = "default_junglesapling.png",
	
	on_place = function(itemstack, placer, pointed_thing)
		
		-- Verifica se tem privilegios
		if minetest.check_player_privs(placer:get_player_name(), {server=true}) ~= true then
			return
		end
		
		sovagxas.montar_arvore(pointed_thing.above)
	end,
})
