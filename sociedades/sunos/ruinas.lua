--[[
	Mod Sunos para Minetest
	Copyright (C) 2018 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Métodos para tratamento de ruinas
  ]]

-- Traduções
local S = sunos.S


-- Montar ruinas
sunos.montar_ruinas = function(pos, dist)
	sunos.checkvar(pos, dist, "Parametro(s) invalido(s) para montar ruinas")
	
	local pos1 = {x=pos.x-dist, y=pos.y, z=pos.z-dist}
	local pos2 = {x=pos.x+dist, y=pos.y+14, z=pos.z+dist}
	
	-- Limpar metadados
	sunos.limpar_metadados(pos1, pos2)
	
	-- Pega todos elementos pedrosos
	local nodes = minetest.find_nodes_in_area(
		{x=pos.x-dist, y=pos.y, z=pos.z-dist}, 
		{x=pos.x+dist, y=pos.y+14, z=pos.z+dist}, 
		{"group:stone", "default:furnace", "default:furnace_active"}
	)
	
	-- Remove todos os nodes na regiao
	sunos.remover_todos_nodes_area(pos1, pos2)
	
	-- Recoloca pedregulho no lugar de elementos pedrosos
	for _,p in ipairs(nodes) do
		minetest.set_node(p, {name="default:cobble"})
	end
	
	-- Completa espaços com terra no solo
	do
		for _,p in ipairs(minetest.find_nodes_in_area(
			{x=pos.x-dist, y=pos.y, z=pos.z-dist}, 
			{x=pos.x+dist, y=pos.y, z=pos.z+dist}, 
			{"air"}
		)) do
			minetest.set_node(p, {name="default:dirt_with_grass"})
		end
		
	end
	
	return true
end
