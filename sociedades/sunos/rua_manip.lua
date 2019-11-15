--[[
	Mod Sunos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Manipulacao de ruas
  ]]

-- Caminho do diretório do mod
local modpath = minetest.get_modpath("sunos")

local colocar_rua = function(pos)
	minetest.set_node(pos, {name="sunos:rua_calcetada"})
end

-- Colocar rua
local colocar_rua = function(pos)
	-- Evita colocar sobre outro
	local n1 = minetest.get_node({x=pos.x,y=pos.y-1,z=pos.z}).name
	local n2 = minetest.get_node({x=pos.x,y=pos.y+1,z=pos.z}).name
	local n3 = minetest.get_node({x=pos.x,y=pos.y,z=pos.z}).name
	if n1 == "sunos:rua_calcetada" or n1 == "stairs:slab_rua_calcetada" then return end
	if n2 == "sunos:rua_calcetada" or n2 == "stairs:slab_rua_calcetada" then return end
	if n3 == "sunos:rua_calcetada" or n3 == "stairs:slab_rua_calcetada" then return end
	
	if minetest.get_node({x=pos.x+1,y=pos.y,z=pos.z}).name == "air"
		or minetest.get_node({x=pos.x-1,y=pos.y,z=pos.z}).name == "air"
		or minetest.get_node({x=pos.x,y=pos.y,z=pos.z+1}).name == "air"
		or minetest.get_node({x=pos.x,y=pos.y,z=pos.z-1}).name == "air"
	then
		minetest.set_node(pos,{name="stairs:slab_rua_calcetada"})
	else
		minetest.set_node(pos,{name="sunos:rua_calcetada"})
	end
end

-- Coloca rua em volta de uma estrutura
sunos.colocar_rua = function(pos, dist)

	-- Pegar nodes de terra superficial
	local nodes1 = minetest.find_nodes_in_area( -- X+
		{x=pos.x+dist+2, y=pos.y-1, z=pos.z-dist-2-1}, {x=pos.x+dist+2+2, y=pos.y+1, z=pos.z+dist+2+1}, {"group:spreading_dirt_type"})
	local nodes2 = minetest.find_nodes_in_area( -- Z+
		{x=pos.x-dist-2-1, y=pos.y-1, z=pos.z+dist+2}, {x=pos.x+dist+2+1, y=pos.y+1, z=pos.z+dist+2+2}, {"group:spreading_dirt_type"})
	local nodes3 = minetest.find_nodes_in_area( -- X-
		{x=pos.x-dist-2-2, y=pos.y-1, z=pos.z-dist-2-1}, {x=pos.x-dist-2, y=pos.y+1, z=pos.z+dist+2+1}, {"group:spreading_dirt_type"})
	local nodes4 = minetest.find_nodes_in_area( -- Z-
		{x=pos.x-dist-2-1, y=pos.y-1, z=pos.z-dist-2-2}, {x=pos.x+dist+2+1, y=pos.y+1, z=pos.z-dist-2}, {"group:spreading_dirt_type"})

	for _,p in ipairs(nodes1) do
		minetest.set_node(p, {name="sunos:rua_calcetada"})
	end
	for _,p in ipairs(nodes2) do
		minetest.set_node(p, {name="sunos:rua_calcetada"})
	end
	for _,p in ipairs(nodes3) do
		minetest.set_node(p, {name="sunos:rua_calcetada"})
	end
	for _,p in ipairs(nodes4) do
		minetest.set_node(p, {name="sunos:rua_calcetada"})
	end
	
	-- Repetir processo para blocos de terra expostos
	do
		local nodes1 = minetest.find_nodes_in_area( -- X+
			{x=pos.x+dist+2, y=pos.y-1, z=pos.z-dist-2-1}, {x=pos.x+dist+2+2, y=pos.y+1, z=pos.z+dist+2+1}, {"default:dirt"})
		local nodes2 = minetest.find_nodes_in_area( -- Z+
			{x=pos.x-dist-2-1, y=pos.y-1, z=pos.z+dist+2}, {x=pos.x+dist+2+1, y=pos.y+1, z=pos.z+dist+2+2}, {"default:dirt"})
		local nodes3 = minetest.find_nodes_in_area( -- X-
			{x=pos.x-dist-2-2, y=pos.y-1, z=pos.z-dist-2-1}, {x=pos.x-dist-2, y=pos.y+1, z=pos.z+dist+2+1}, {"default:dirt"})
		local nodes4 = minetest.find_nodes_in_area( -- Z-
			{x=pos.x-dist-2-1, y=pos.y-1, z=pos.z-dist-2-2}, {x=pos.x+dist+2+1, y=pos.y+1, z=pos.z-dist-2}, {"default:dirt"})

		for _,p in ipairs(nodes1) do
			local name = minetest.get_node({x=p.x,y=p.y+1,z=p.z}).name
			if name == "air" or minetest.get_item_group(name, "grass") ~= 0 then
				minetest.set_node(p, {name="sunos:rua_calcetada"})
			end
		end
		for _,p in ipairs(nodes2) do
			local name = minetest.get_node({x=p.x,y=p.y+1,z=p.z}).name
			if name == "air" or minetest.get_item_group(name, "grass") ~= 0 then
				minetest.set_node(p, {name="sunos:rua_calcetada"})
			end
		end
		for _,p in ipairs(nodes3) do
			local name = minetest.get_node({x=p.x,y=p.y+1,z=p.z}).name
			if name == "air" or minetest.get_item_group(name, "grass") ~= 0 then
				minetest.set_node(p, {name="sunos:rua_calcetada"})
			end
		end
		for _,p in ipairs(nodes4) do
			local name = minetest.get_node({x=p.x,y=p.y+1,z=p.z}).name
			if name == "air" or minetest.get_item_group(name, "grass") ~= 0 then
				minetest.set_node(p, {name="sunos:rua_calcetada"})
			end
		end
	end
	
	sunos.saida_para_rua(pos, dist)
	
end

-- Cria saidas para a rua nas estruturas
--[[
	O objetivo é evidenciar as saidas que não tem portas na estrutura 
	mas que são saidas normais como lojas, quintais e etc. Sempre com pedregulhos
	Arquimentos:
		<pos> coordenada do centro do solo da estrutura
		<dist> distancia de centro a borda da estrutura
  ]]
local ajustar_quina = function(pos)
	if minetest.get_node(pos).name ~= "default:dirt_with_grass" then return end
	local n1 = minetest.get_node({x=pos.x+1, y=pos.y, z=pos.z}).name -- X+
	local n2 = minetest.get_node({x=pos.x-1, y=pos.y, z=pos.z}).name -- X-
	local n3 = minetest.get_node({x=pos.x, y=pos.y, z=pos.z+1}).name -- Z+
	local n4 = minetest.get_node({x=pos.x, y=pos.y, z=pos.z-1}).name -- Z-
	local n = 0
	if n1 == "sunos:rua_calcetada" or n1 == "stairs:slab_rua_calcetada" then n = n + 1 end
	if n2 == "sunos:rua_calcetada" or n2 == "stairs:slab_rua_calcetada" then n = n + 1 end
	if n3 == "sunos:rua_calcetada" or n3 == "stairs:slab_rua_calcetada" then n = n + 1 end
	if n4 == "sunos:rua_calcetada" or n4 == "stairs:slab_rua_calcetada" then n = n + 1 end
	if n == 4 then
		colocar_rua(pos)
	end
end
sunos.saida_para_rua = function(pos, dist)
	-- Pegar todos os nodes de terra no solo até + 1 em volta da estrutura
	local terras = {}
	
	for _, p in ipairs(minetest.find_nodes_in_area(
		{x=pos.x-dist-1, y=pos.y, z=pos.z-dist-1}, 
		{x=pos.x-dist-1, y=pos.y, z=pos.z+dist+1}, 
		{"default:dirt_with_grass"}
	)) do
		table.insert(terras, p)
	end
	for _, p in ipairs(minetest.find_nodes_in_area(
		{x=pos.x-dist-1, y=pos.y, z=pos.z+dist+1}, 
		{x=pos.x+dist+1, y=pos.y, z=pos.z+dist+1}, 
		{"default:dirt_with_grass"}
	)) do
		table.insert(terras, p)
	end
	for _, p in ipairs(minetest.find_nodes_in_area(
		{x=pos.x+dist+1, y=pos.y, z=pos.z+dist+1}, 
		{x=pos.x+dist+1, y=pos.y, z=pos.z-dist-1}, 
		{"default:dirt_with_grass"}
	)) do
		table.insert(terras, p)
	end
	for _, p in ipairs(minetest.find_nodes_in_area(
		{x=pos.x+dist+1, y=pos.y, z=pos.z-dist-1}, 
		{x=pos.x-dist-1, y=pos.y, z=pos.z-dist-1}, 
		{"default:dirt_with_grass"}
	)) do
		table.insert(terras, p)
	end
	
	for _,p in ipairs(terras) do
		-- Verifica os 8 nodes ao redor
		local n1 =  minetest.get_node({x=p.x+1, y=p.y, z=p.z}).name -- X+
		local n2 =  minetest.get_node({x=p.x-1, y=p.y, z=p.z}).name -- X-
		local n3 =  minetest.get_node({x=p.x, y=p.y, z=p.z+1}).name -- Z+
		local n4 =  minetest.get_node({x=p.x, y=p.y, z=p.z-1}).name -- Z-
		local n5 =  minetest.get_node({x=p.x+1, y=p.y, z=p.z+1}).name -- X+Z+
		local n6 =  minetest.get_node({x=p.x-1, y=p.y, z=p.z+1}).name -- X-Z+
		local n7 =  minetest.get_node({x=p.x+1, y=p.y, z=p.z-1}).name -- X+Z-
		local n8 =  minetest.get_node({x=p.x-1, y=p.y, z=p.z-1}).name -- X-Z-
		
		-- Coordenada do node de pedra
		local pp = {}
		
		-- Valida se existe rua perto da saida
		local tem_rua = false
		if n1 == "sunos:rua_calcetada" or n1 == "stairs:slab_rua_calcetada"
			or n2 == "sunos:rua_calcetada" or n2 == "stairs:slab_rua_calcetada"
			or n3 == "sunos:rua_calcetada" or n3 == "stairs:slab_rua_calcetada"
			or n4 == "sunos:rua_calcetada" or n4 == "stairs:slab_rua_calcetada"
			or n5 == "sunos:rua_calcetada" or n5 == "stairs:slab_rua_calcetada"
			or n6 == "sunos:rua_calcetada" or n6 == "stairs:slab_rua_calcetada"
			or n7 == "sunos:rua_calcetada" or n7 == "stairs:slab_rua_calcetada"
			or n8 == "sunos:rua_calcetada" or n8 == "stairs:slab_rua_calcetada"
		then
			tem_rua = true
		end
		
		if tem_rua == true then
			
			-- Verifica se um dos nodes é de pedra
			if n1 == "sunos:cobble_nodrop" then
				pp = {x=p.x+1, y=p.y, z=p.z}
			elseif n2 == "sunos:cobble_nodrop" then
				pp = {x=p.x-1, y=p.y, z=p.z}
			elseif n3 == "sunos:cobble_nodrop" then
				pp = {x=p.x, y=p.y, z=p.z+1}
			elseif n4 == "sunos:cobble_nodrop" then
				pp = {x=p.x, y=p.y, z=p.z-1}
			end
			
			-- Verifica se tem nada nas duas coordenadas acima
			if pp.x then
				local nn1 = minetest.get_node({x=pp.x, y=p.y+1, z=pp.z}).name
				local nn2 = minetest.get_node({x=pp.x, y=p.y+2, z=pp.z}).name
				if ((nn1 == "sunos:carpete_palha_nodrop" or nn1 == "air") and (nn2 == "air"))
					or nn1 == "doors:door_wood_a"
				then
					-- Altera a terra para rua
					colocar_rua(p)
				end
			end
		end
	end
	
	-- Ajustar quinas
	ajustar_quina({x=pos.x-dist-1, y=pos.y, z=pos.z-dist-1})
	ajustar_quina({x=pos.x-dist-1, y=pos.y, z=pos.z+dist+1})
	ajustar_quina({x=pos.x+dist+1, y=pos.y, z=pos.z+dist+1})
	ajustar_quina({x=pos.x+dist+1, y=pos.y, z=pos.z-dist-1})
	
end
