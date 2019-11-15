--[[
	Mod Sunos para Minetest
	Copyright (C) 2018 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Metodos de spawn
	
	Metodos para escolher o node certo para spawnar
  ]]



-- Verifica se tem jogadores no interior de uma estrutura
local check_players_estrut = function(pf, dist)
	-- Analizar objetos (possiveis npcs) perto
	for i = 0, math.floor(15/dist)-1 do
		for _,obj in ipairs(minetest.get_objects_inside_radius({x=pf.x, y=pf.y+(i*dist), z=pf.z}, dist)) do
		
			-- Evita jogadores por perto para nao spawnar de repente
			if obj:is_player() then
				return true
			end
		end
	end
	return false
end


-- Verifica se a area está carregada
local check_load_estrut = function(pf, dist)
	-- Verifica se a area está carregada
	if minetest.get_node(pf).name == "ignore" then
		minetest.get_voxel_manip():read_from_map(
			{x=pf.x-dist, y=pf.y, z=pf.z-dist},
			{x=pf.x+dist, y=pf.y+14, z=pf.z+dist}
		)
	end
end


-- Tabela de metodos
--[[
	Definições:
		
		tipo = "", 
			^ Tipo escolhido
			  "fundamento" : Escolhe um node dentro de area de uma estrutura.
			                 A coordenada `pos` deve ser o proprio fundamento.
			  "node_front" : Escolhe a coordenada da frente de um node
		
		no_players = true, -- OPICIONAL, Se quer evitar jogadores, retorna nil se houver.
		
		nodes = {"nodename1", "nodename2", "nodename2"}, 
			^ OPICIONAL. Tabela de nodes sobre o qual vai spawnar
			^ Padrão é {"sunos:wood_nodrop", "default:stonebrick", "sunos:cobble_nodrop"}
		
		carpete = "nodename",
			^ OPICIONAL. Node a ser considerado como carpete e deve estar acima do node, 
			^ Colocar "air" para evitar qualquer carpete
			^ Padrão é "sunos:carpete_palha_nodrop"
		
		node_pos = {x=0, y=0, z=0}, -- Coordenada do node para spawnar na frente (
			^ Usado apenas no tipo "node_front"
			
  ]]
sunos.npcs.select_pos_spawn = function(pos, def)
	
	if def.tipo == "fundamento" then
	
		local meta = minetest.get_meta(pos)
		
		local pf = pos
		
		local dist = tonumber(minetest.get_meta(pf):get_string("dist"))
		
		-- Assegura carregamento da area
		check_load_estrut(pf, dist)
		
		-- Verifica se tem jogadores na estrutura
		if def.no_players ~= false and check_players_estrut(pf, dist) == true then
			return
		end
		
		-- Escolher uma coordenada para spawnar
		do
			local nok = {} -- tabela de nodes ok 
			-- Pegar nodes de madeira
			local nodes = minetest.find_nodes_in_area(
				{x=pf.x-dist, y=pf.y, z=pf.z-dist}, 
				{x=pf.x+dist, y=pf.y+14, z=pf.z+dist}, 
				def.nodes or {"sunos:wood_nodrop", "default:stonebrick", "sunos:cobble_nodrop"})
			for _,p in ipairs(nodes) do
				if minetest.get_node({x=p.x, y=p.y+1, z=p.z}).name == (def.carpete or "sunos:carpete_palha_nodrop")
					and minetest.get_node({x=p.x, y=p.y+2, z=p.z}).name == "air"
				then
					table.insert(nok, {x=p.x, y=p.y+1.5, z=p.z})
				end
			end
			-- Verifica se achou algum
			if not nok[1] then 
				return
			end
			
			-- Sorteia uma coordenada
			return nok[math.random(1, table.maxn(nok))]
		end
	
	elseif def.tipo == "node_front" then
		
		local meta = minetest.get_meta(pos)
		
		local pf = pos
		
		local dist = tonumber(minetest.get_meta(pf):get_string("dist"))
		
		-- Assegura carregamento da area
		check_load_estrut(pf, dist)
		
		-- Verifica se tem jogadores na estrutura
		if def.no_players ~= false and check_players_estrut(pf, dist) == true then
			return
		end
		
		local v = minetest.facedir_to_dir(minetest.get_node(def.node_pos).param2)
		local f = vector.subtract(node_pos, v)
		
		if minetest.get_node({x=f.x, y=f.y, z=f.z}).name == (def.carpete or "sunos:carpete_palha_nodrop")
			and minetest.get_node({x=f.x, y=f.y, z=f.z}).name == "air"
		then
			return {x=f.x, y=f.y+0.5, z=f.z}
		end
		
	end
end
