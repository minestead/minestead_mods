--[[
	Mod Sunos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Métodos para ajustar jogador
  ]]

-- Pega jogadores numa area
local pegar_jogadores = function(pos, dist)
	local all_objects = minetest.get_objects_inside_radius(pos, dist)
	local players = {}
	local _,obj
	for _,obj in ipairs(all_objects) do
		if obj:is_player() then
			table.insert(players, obj)
		end
	end
	return players
end

-- Remove jogadores de uma area e teleporta para ruas proximas
sunos.ajustar_jogadores = function(pos)
	
	-- Procura uma rua proxima
	local rua = minetest.find_node_near(pos, 10, {"sunos:rua_calcetada"})
	
	-- Verificar se encontrou uma rua proxima
	if not rua then return end
	
	-- Procurar jogadores proximos
	local jogadores = pegar_jogadores(pos, 7)
	
	-- Teleporta todos os jogadores encontrados
	for _,obj in ipairs(jogadores) do
		obj:setpos({x=rua.x,y=rua.y+3,z=rua.z})
	end
	
end

