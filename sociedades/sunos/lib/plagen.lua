--[[
	Lib Plagen para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Planificador
  ]]

local plagen = {}


-- Metodo para pegar blocos mesmo nao carregados
local function pegar_node(pos)
	local node = minetest.get_node(pos)
	if node.name == "ignore" then
		minetest.get_voxel_manip():read_from_map(pos, pos)
		node = minetest.get_node(pos)
	end
	return node
end


-- Calcular diferença do novo degrau
local function calc_dif(y, y1, y2)
	if y2 > y1 then
		return y + 1
	elseif y2 < y1 then
		return y - 1
	else
		return y
	end
end


-- Metodo para colocar um nivel de blocos (como um solo)
local function montar_solo(pos, solo, subsolo, rocha)
	if not pos or not solo or not subsolo or not rocha then 
		return false
	end
	local miny = pos.y-20
	local maxy = pos.y+20
	for y=miny, maxy do
		if y < pos.y - 2 then
			minetest.set_node({x=pos.x,y=y,z=pos.z}, {name=rocha})
		elseif y < pos.y then
			minetest.set_node({x=pos.x,y=y,z=pos.z}, {name=subsolo})
		elseif y == pos.y then
			minetest.set_node({x=pos.x,y=y,z=pos.z}, {name=solo})
		else
			minetest.remove_node({x=pos.x,y=y,z=pos.z})
		end
	end
	return true
end


-- Encontrar altura de um bloco alvo (em uma coluna)
local pegar_altura_solo = function(pos, alvos, amplitude)
	local y = pos.y + amplitude
	local resp = pos.y
	while y >= pos.y - amplitude do
		if table.maxn(minetest.find_nodes_in_area({x=pos.x,y=y,z=pos.z}, {x=pos.x,y=y,z=pos.z}, alvos)) == 1 then
			resp = y
			break
		end
		y = y - 1
	end
	return resp
end


-- Planificar uma area
--[[
	Esse metodo planifica uma area
	Retornos:
		<booleano> true para operação bem sucedida e false para nao sucedida
	Argumentos:
		<pos> do centro da area a ser planificada
		<tipo> tipo de planificação
			"quadrada" para planificar uma area quadrada
		<largura> largura da area planificada
		<amplitude> Quantidade de blocos para cima e para baixo em que ocorre a operação (colocação de blocos)
		<nodes> É o material utilizado na planificação
			{rocha="string", subsolo="string", solo="string"}
		<borda> É quantos blocos a partir da area planificada serão afetado para formar os degrais
		<calc_media> é booleano para planificar em uma faixa de altura média da area a planificar
		<verif_mapa> Verificar se o mapa está gerado por segurança
		
  ]]
local solos_gerais = {"group:soil", "group:stone", "group:sand"}
plagen.planificar = function(pos, tipo, largura, amplitude, nodes, borda, calc_media, verif_mapa)
	-- Verificar dados
	if not pos then
		minetest.log("error", "[Plagen] Tabela 'pos' nula (em plagen.planificar)")
		return false
	end
	if not tipo then
		minetest.log("error", "[Plagen] String de 'tipo' nula (em plagen.planificar)")
		return false
	end
	if not largura then
		minetest.log("error", "[Plagen] Variavel 'largura' nula (em plagen.planificar)")
		return false
	end
	if not amplitude then
		minetest.log("error", "[Plagen] Variavel 'amplitude' nula (em plagen.planificar)")
		return false
	end
	if not nodes then
		minetest.log("error", "[Plagen] Tabela 'nodes' nula (em plagen.planificar)")
		return false
	end
	-- Refino de dados
	if tipo ~= "quadrada" then
		minetest.log("error", "[Plagen] Tipo de planificacao "..dump(tipo).." invalida (em plagen.planificar)")
		return false
	end
	if not nodes.rocha then
		minetest.log("error", "[Plagen] Tabela 'nodes' nao tem 'rocha' definido (em plagen.planificar)")
		return false
	end
	if not nodes.subsolo then
		minetest.log("error", "[Plagen] Tabela 'nodes' nao tem 'subsolo' definido (em plagen.planificar)")
		return false
	end
	if not nodes.solo then
		minetest.log("error", "[Plagen] Tabela 'nodes' nao tem 'solo' definido (em plagen.planificar)")
		return false
	end
	
	-- Reajuste de dados
	if not borda then borda = 0 end
	
	-- Criado variaveis auxiliares
	
	-- Materiais
	local solo = nodes.solo
	local subsolo = nodes.subsolo
	local rocha = nodes.rocha
	
	-- Distancia do centro a borda da area plana
	local dist = math.ceil(largura/2) -- arredonda pra cima
	
	-- Coordenadas da area plana
	local minp = {x=pos.x-dist, z=pos.z-dist}
	local maxp = {x=pos.x+dist, z=pos.z+dist}
	
	-- Altura da area plana
	local altura = pos.y
	
	-- Verificar se o mapa está gerado
	if verif_mapa then
		local d = borda + dist
		local node1 = pegar_node({x=pos.x+d, y=pos.y+borda, z=pos.z})
		local node2 = pegar_node({x=pos.x-d, y=pos.y+borda, z=pos.z})
		local node3 = pegar_node({x=pos.x, y=pos.y+borda, z=pos.z+d})
		local node4 = pegar_node({x=pos.x, y=pos.y+borda, z=pos.z-d})
		local node5 = pegar_node({x=pos.x+d, y=pos.y-borda, z=pos.z})
		local node6 = pegar_node({x=pos.x-d, y=pos.y-borda, z=pos.z})
		local node7 = pegar_node({x=pos.x, y=pos.y-borda, z=pos.z+d})
		local node8 = pegar_node({x=pos.x, y=pos.y-borda, z=pos.z-d})
		if node1.name == "ignore" or node2.name == "ignore" or node3.name == "ignore" or node4.name == "ignore"
			or node5.name == "ignore" or node6.name == "ignore" or node7.name == "ignore" or node8.name == "ignore"
		then 
			return false
		end
	end
	
	
	-- Calcular altura média dos blocos de solo na area a ser aplanada para definir a altura mais adequada
	if calc_media then
		local nodes = minetest.find_nodes_in_area(
			{x=minp.x, y=pos.y-amplitude, z=minp.z}, 
			{x=maxp.x, y=pos.y+amplitude, z=maxp.z}, 
			{solo}
		)
		local n = 0
		for _, vpos in ipairs(nodes) do
			n = n + vpos.y
		end
		if table.maxn(nodes) > 0 then
			altura = math.ceil(n/table.maxn(nodes))
		end
	end
	
	
	-- Inicia um processo de planagem
	if tipo == "quadrada" then
	
	
		-- Montar faixa de terra plana
		for x=minp.x, maxp.x do
			for z=minp.z, maxp.z do
				montar_solo({x=x,y=altura,z=z}, solo, subsolo, rocha)
			end
		end
	
	
	
		-- Montar degrais de blocos (em direção a borda)
		if borda > 0 then
			for degrau=1, borda do
				--[[
					y1 é a altura do degrau já construindo
					y2 é a altura do degrau que será contruindo
				  ]]
				  
				-- Montar fileira de Degrais X+
				for z=minp.z, maxp.z do
					local p = {x=maxp.x,y=altura,z=z}
					local y1 = pegar_altura_solo(p, {solo}, amplitude)
					p.y = y1
					p.x = p.x + 1
					local y2 = pegar_altura_solo(p, solos_gerais, amplitude)
			
					-- Verifica precipicios
					if y2 == false then y2 = y1 end
			
					-- Calcula novo degrau
					p.y = calc_dif(p.y, y1, y2)
					montar_solo(p, solo, subsolo, rocha)
				end
		
				-- Montar fileira de Degrais X-
				for z=minp.z, maxp.z do
					local p = {x=minp.x,y=altura,z=z}
					local y1 = pegar_altura_solo(p, {solo}, amplitude)
					p.y = y1
					p.x = p.x - 1
					local y2 = pegar_altura_solo(p, solos_gerais, amplitude)
			
					-- Verifica precipicios
					if y2 == false then y2 = y1 end
			
					-- Calcula novo degrau
					p.y = calc_dif(p.y, y1, y2)
					montar_solo(p, solo, subsolo, rocha)
				end
		
				-- Montar fileira de Degrais Z+
				for x=minp.x, maxp.x do
					local p = {x=x,y=altura,z=maxp.z}
					local y1 = pegar_altura_solo(p, {solo}, amplitude)
					p.y = y1
					p.z = p.z + 1
					local y2 = pegar_altura_solo(p, solos_gerais, amplitude)
			
					-- Verifica precipicios
					if y2 == false then y2 = y1 end
			
					-- Calcula novo degrau
					p.y = calc_dif(p.y, y1, y2)
					montar_solo(p, solo, subsolo, rocha)
				end
		
				-- Montar fileira de Degrais Z-
				for x=minp.x, maxp.x do
					local p = {x=x,y=altura,z=minp.z}
					local y1 = pegar_altura_solo(p, {solo}, amplitude)
					p.y = y1
					p.z = p.z - 1
					local y2 = pegar_altura_solo(p, solos_gerais, amplitude)
			
					-- Verifica precipicios
					if y2 == false then y2 = y1 end
			
					-- Calcula novo degrau
					p.y = calc_dif(p.y, y1, y2)
					montar_solo(p, solo, subsolo, rocha)
				end
		
				-- Montar quinas
		
				-- Quina X+Z+
				local p = {x=maxp.x,y=altura,z=maxp.z}
				local y1 = pegar_altura_solo(p, {solo}, amplitude)
				p.y = y1
				p.x = p.x + 1
				p.z = p.z + 1
				local y2 = pegar_altura_solo(p, solos_gerais, amplitude)
		
				-- Verifica precipicios
				if y2 == false then y2 = y1 end
		
				-- Calcula novo degrau
				p.y = calc_dif(p.y, y1, y2)
				montar_solo(p, solo, subsolo, rocha)
		
				-- Quina X+Z-
				p = {x=maxp.x,y=altura,z=minp.z}
				y1 = pegar_altura_solo(p, {solo}, amplitude)
				p.y = y1
				p.x = p.x + 1
				p.z = p.z - 1
				y2 = pegar_altura_solo(p, solos_gerais, amplitude)
		
				-- Verifica precipicios
				if y2 == false then y2 = y1 end
		
				-- Calcula novo degrau
				p.y = calc_dif(p.y, y1, y2)
				montar_solo(p, solo, subsolo, rocha)
		
				-- Quina X-Z-
				p = {x=minp.x,y=altura,z=minp.z}
				y1 = pegar_altura_solo(p, {solo}, amplitude)
				p.y = y1
				p.x = p.x - 1
				p.z = p.z - 1
				y2 = pegar_altura_solo(p, solos_gerais, amplitude)
		
				-- Verifica precipicios
				if y2 == false then y2 = y1 end
		
				-- Calcula novo degrau
				p.y = calc_dif(p.y, y1, y2)
				montar_solo(p, solo, subsolo, rocha)
		
				-- Quina X-Z+
				p = {x=minp.x,y=altura,z=maxp.z}
				y1 = pegar_altura_solo(p, {solo}, amplitude)
				p.y = y1
				p.x = p.x - 1
				p.z = p.z + 1
				y2 = pegar_altura_solo(p, solos_gerais, amplitude)
		
				-- Verifica precipicios
				if y2 == false then y2 = y1 end
		
				-- Calcula novo degrau
				p.y = calc_dif(p.y, y1, y2)
				montar_solo(p, solo, subsolo, rocha)
		
		
				-- Preparar para proximo degrau
				minp = {x=minp.x-1, z=minp.z-1}
				maxp = {x=maxp.x+1, z=maxp.z+1}
		
			end
		end
 	end
 	
 	
 	-- Remove arvores danificadas perto
 	local d = borda + dist + 2
 	local arvores = minetest.find_nodes_in_area(
 		{x=pos.x-d, y=pos.y+borda, z=pos.z-d}, 
 		{x=pos.x+d, y=pos.y-borda, z=pos.z+d}, 
 		{"group:tree"}
 	)
 	for _, pos in ipairs(arvores) do
 		minetest.remove_node(pos)
 	end
 	
	-- Terreno aplanado com sucesso
	return true
	
end


return plagen
