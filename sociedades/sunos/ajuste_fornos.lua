--[[
	Mod Sunos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Ajuste de fornos gerados
	
  ]]

-- ajusta os forno comuns numa area de estrutura
sunos.ajustar_fornos = function(pos, dist)
	
	-- Pega todos os fornos na area	
	local fornos = minetest.find_nodes_in_area(
		{x=pos.x-dist, y=pos.y, z=pos.z-dist}, 
		{x=pos.x+dist, y=pos.y+14, z=pos.z+dist}, 
		{"default:furnace"}
	)
	
	-- Ajusta cada forno
	for _,p in ipairs(fornos) do
		-- Executa chamada 'on_construct' padrão
		minetest.registered_nodes["default:furnace"].on_construct(p)
	end
	
end
