--[[
	Mod Sunos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Ajuste de estantes geradas
	
  ]]

-- Coloca itens aleatoriamente no inventario dos nodes das coordenadas de uma tabela 
local colocar_inv = function(tb_pos, tb_item, inv_name)
	
	for _,p in ipairs(tb_pos) do
			
		-- Sorteia uma chance de ter livros
		if math.random(1, 100) < 100 then -- 50% de chance
			
			local inv = minetest.get_meta(p):get_inventory()
			
			local i_ok = {} -- tabela desordenada com nomes dos itens que ja foram colocados (evitar repetir)
			
			-- Sorteia uma quantia de livros até 5
			local qtd = math.random(1, 5)
			while qtd > 0 do
				-- Sorteia um item
				local i = tb_item[math.random(1, table.maxn(tb_item))]
				local iname = i.name or i -- pegar nome do item
				if not i_ok[iname] then
					-- Coloca na estante
					inv:add_item(inv_name, i)
					-- Coloca o item o historico
					i_ok[iname] = true
				end
				qtd = qtd - 1
			end
		end
	end
end

-- Ajusta as estantes de livros numa area de estrutura
sunos.ajustar_estantes_livro = function(pos, dist, random_tb)
	
	-- Pega todas as estantes na area
	local estantes_livro = minetest.find_nodes_in_area(
		{x=pos.x-dist, y=pos.y, z=pos.z-dist}, 
		{x=pos.x+dist, y=pos.y+14, z=pos.z+dist}, 
		{"default:bookshelf", "sunos:default_bookshelf_nodrop"}
	)
	
	-- Ajusta cada estante
	for _,p in ipairs(estantes_livro) do
		-- Executa chamada 'on_construct' padrão
		minetest.registered_nodes["default:bookshelf"].on_construct(p)
	end
	
	-- Coloca itens aleatoriamente
	if random_tb then
		
		colocar_inv(estantes_livro, random_tb, "books")
		
	end
end

-- Ajusta as estantes de frascos numa area de estrutura
sunos.ajustar_estantes_frasco = function(pos, dist, random_tb)
	
	-- Pega todas as estantes na area
	local estantes_frasco = minetest.find_nodes_in_area(
		{x=pos.x-dist, y=pos.y, z=pos.z-dist}, 
		{x=pos.x+dist, y=pos.y+14, z=pos.z+dist}, 
		{"vessels:shelf", "sunos:vessels_shelf_nodrop"}
	)
	
	-- Ajusta cada estante
	for _,p in ipairs(estantes_frasco) do
		-- Executa chamada 'on_construct' padrão
		minetest.registered_nodes["vessels:shelf"].on_construct(p)
	end
	
	-- Coloca itens aleatoriamente
	if random_tb then
		
		colocar_inv(estantes_frasco, random_tb, "vessels")
		
	end
end
