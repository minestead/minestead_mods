--[[
	Mod Sunos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Métodos comuns
  ]]

-- Traduções
local S = sunos.S

-- Caminho do diretório do mod
local modpath = minetest.get_modpath("sunos")

-- Copiar tabela de dados (bom para coordenadas)
sunos.copy_tb = function(tb)
	return minetest.deserialize(minetest.serialize(tb))
end

-- Pegar distancia entre duas coordenadas
sunos.p1_to_p2 = function(pos1, pos2)
	local dx = math.abs(pos1.x - pos2.x)
	local dy = math.abs(pos1.y - pos2.y)
	local dz = math.abs(pos1.z - pos2.z)
	local dist_xy = math.hypot(dx, dy)
	local dist_xyz = math.hypot(dist_xy, dz)
	return dist_xyz
end

-- Calcular valor diretamente proporcional (regra de 3)
sunos.calc_proporcional = function(x1, y1, x2)
	return ((y1*x2)/x1)
end

-- Ir um numero de blocos de pos1 a pos2
sunos.ir_p1_to_p2 = function(pos1, pos2, dist)
	-- Distancias em cada coordenada
	local dx = pos2.x - pos1.x
	local dy = pos2.y - pos1.y
	local dz = pos2.z - pos1.z
	local dxyz = sunos.p1_to_p2(pos1, pos2) -- distancia direta
	-- Calcular distancia proporcionais e cada coordenada
	local x = sunos.calc_proporcional(dxyz, dx, dist)
	local y = sunos.calc_proporcional(dxyz, dy, dist)
	local z = sunos.calc_proporcional(dxyz, dz, dist)
	return {x=pos1.x+x, y=pos1.y+y, z=pos1.z+z}
end


-- Pegar direcao oposta
sunos.pegar_dir_oposta = function(dir)
	if dir == "x+" then
		return "x-"
	end
	if dir == "x-" then
		return "x+"
	end
	if dir == "z+" then
		return "z-"
	end
	if dir == "z-" then
		return "z+"
	end
end

-- Verificar distancia entre duas pos
--[[
	Verifica a maior distancia possivel em um vetor (x, y ou z)
	Retorno:
		<dist> é a maior distancia de um vetor entre pos1 e pos2
	Argumentos:
		<pos1> é uma pos para ser comparada com a outra
		<pos2> é uma pos para ser comparada com a outra
  ]]
sunos.verif_dist_pos = function(pos1, pos2)
	sunos.checkvar(pos1, pos2, "Coordenada(s) nula(s) ao ao verificar distancia entre pos1 e pos2")
	
	local x = math.abs(math.abs(pos1.x)-math.abs(pos2.x))
	local y = math.abs(math.abs(pos1.y)-math.abs(pos2.y))
	local z = math.abs(math.abs(pos1.z)-math.abs(pos2.z))
	if x > z and x > y then return x end
	if y > x and y > z then return y end
	if z > x and z > y then return z end
	return x or y or z
end

-- Pega um node
--[[
	Pega o node normalmente e tenta carregar o node
	caso resulte em ignore. Se o node não tiver sido gerado
	o retorno será ignore.
  ]]
sunos.pegar_node = function(pos)
	local node = minetest.get_node(pos)
	if node.name == "ignore" then
		minetest.get_voxel_manip():read_from_map(pos, pos)
		node = minetest.get_node(pos)
	end
	return node
end

-- Encontrar solo
--[[
	Essa função recebe uma pos e tenta encontrar
	o solo de terra com grama através de um loop que desce
	verificando a partir da altura da pos.
	Retorno:
		<pos> é a pos do solo encontrado ou nil caso não encontre
	Argumentos:
		<dist> OPCIONAL | é a distancia que o loop 
			acontece descendo (padrão é 10) 
		<subir> OPCIONAL | é uma distância para cima que o
			loop deve iniciar (padrão é 0) 
  ]]
sunos.pegar_solo = function(pos, dist, subir)
	sunos.checkvar(pos, "Coordenada nula para pegar altura do solo")
	sunos.checkvar(dist, subir, "Parametro(s) invalido(s) nula para pegar altura do solo")
	
	
	if dist == nil then dist = 10 end
	if subir == nil then subir = 0 end
	local np = {x=pos.x, y=pos.y+subir, z=pos.z}
	local y = 0
	local r = nil
	while y <= dist do
		local node = sunos.pegar_node({x=np.x, y=np.y-y, z=np.z})
		if node.name == "default:dirt_with_grass" or node.name == "sunos:rua_calcetada" then
			r = {x=np.x, y=np.y-y, z=np.z}
			break
		end
		y = y + 1
	end
	return r
end


-- Pegar rotação
sunos.pegar_rotat = function()
	local tb_rotat = {"0", "90", "180", "270"}
	return tb_rotat[math.random(1, 4)]
end


-- Verifica se tem jogador perto
-- Retorna nulo ou objeto se encontrar jogador
sunos.verif_player_perto = function(pos, dist)
	for _,obj in ipairs(minetest.get_objects_inside_radius(pos, dist)) do
		if obj:is_player() then
			return obj	
		end
	end
end


-- Verificar se uma area está pronta para fundamento
-- Retorna mensagens de acordo com o erro
sunos.verificar_area_para_fundamento = function(pos, dist)

	-- Verifica status do terreno
	local st = sunos.verif_terreno(pos, dist+1)
	
	-- Variaveis auxiliares
	local largura = (dist*2)+1
	
	-- Problema: em cima da faixa de solo existem obstrucoes (nao esta limpo e plano)
	if st == 1 then
		return S("O local precisa estar limpo e plano em uma area de @1x@2 blocos da largura", (largura+2), (largura+2))
	
	-- Problema: faixa de solo (superficial) falta blocos de terra
	elseif st == 2 then
		return S("O solo precisa estar plano e gramado em uma area de @1x@2 blocos da largura", (largura+2), (largura+2))
	
	-- Problema: faixa de subsolo (considerando 2 faixas) falta blocos de terra
	elseif st == 3 then
		return S("O subsolo precisa estar preenchido (ao menos 2 blocos de profundidade) em uma area de @1x@2 blocos da largura", (largura+2), (largura+2))
	end
	
	return true
end


-- Verificar vila abandonada
sunos.verificar_vila_existente = function(vila)
	-- Atualizar o banco de dados
	sunos.atualizar_bd_vila(vila)
	
	-- Verificar se ainda existe um banco de dados da vila
	if sunos.bd.verif("vila_"..vila, "numero") == true then
		return true
	end
	return false
end


-- Encontrar vila perto
-- Retorna o numero de uma vila encontrada
sunos.encontrar_vila = function(pos, dist)
	
	local nodes = minetest.find_nodes_in_area(vector.subtract(pos, dist), vector.add(pos, dist), {"sunos:fundamento"})	
	
	for _,fund in ipairs(nodes) do
		
		-- Pegar dados da vila encontrada
		local meta = minetest.get_meta(fund)
		local vila = meta:get_string("vila")
		
		-- Verificar se vila existe
		if sunos.verificar_vila_existente(vila) == true then
			return tonumber(vila)
		end
		
	end
	
end

-- Envia mensagem informativa no depurador se ativado
if sunos.var.debug_info ~= false then
	sunos.debug = function(msg)
		npc.log("DEBUG", "[Sunos] "..msg)
	end
else
	sunos.debug = function() end
end

-- Pegar uma arquivo de estrutura aleatoriamente
--[[
	Essa função retorna um nome aleatorio de arquivo para estrutura.
	Argumentos:
		<largura> Largura da estrutura
		<tipo> Tipo da estrutura
	Retorno:
		<nome> Nome da estrutura (Ex. casa_simples)
  ]]
sunos.pegar_arquivo = function(largura, tipo)
	sunos.checkvar(largura, tipo, "Parametro(s) invalido(s) para pegar arquivo")
	
	local estruturas = minetest.get_dir_list(modpath.."/schems/"..tipo)
	
	local validos = {}
	if estruturas ~= nil then
		for _,nome in ipairs(estruturas) do
			local n = string.split(nome, ".")
			if n[2] -- Tem valor apos segundo ponto
				and tonumber(n[2]) == tonumber(largura) -- Largura corresponde à exigida
				and not string.match(nome, "-step") -- evita arquivos tipo step
			then
				table.insert(validos, n[1])
			end
		end
	else
		return nil
	end
		
	
	if validos[1] then
		return validos[math.random(1, table.maxn(validos))]
	else
		return nil
	end
end


-- Mover pos para uma direcao
--[[
	Essa função calcula uma pos deslocada para uma direção
	definida.
	Retorno:
		<pos> é a pos deslocada
	Argumentos:
		<pos> é a pos de onde o descolamento ocorre
		<dir> é a string da direção que o deslocamento ocorre
			("x+", "x-", "z+" ou "z-")
		<dist> OPCIONAL | é a distância de deslocamento
			(padrão é 1)
  ]]
sunos.ir_dir = function(pos, dir, dist)
	
	if dist == nil then dist = 1 end
	
	if dir == "x+" then
		return {x=pos.x+dist, y=pos.y, z=pos.z}
	elseif dir == "x-" then
		return {x=pos.x-dist, y=pos.y, z=pos.z}
	elseif dir == "z+" then
		return {x=pos.x, y=pos.y, z=pos.z+dist}
	elseif dir == "z-" then
		return {x=pos.x, y=pos.y, z=pos.z-dist}
	else
		return pos
	end
end


-- Gira uma direcao
--[[
	Essa função calcula uma direção rotacionada.
	Para ajudar o entendimento, imagine que você
	(como jogador) está vidade para a direção "x+",
	caso vire para a esquerda estará virado para "z+".
	Essa é a lógica aqui.
	Retorno:
		<dir> é a direção rotacionada
	Argumentos:
		<dir> é a direção inicial
		<lado> é pra que lado ela deve virar
			("<"(direita) ou ">"(esquerda))
  ]]
sunos.girar_dir = function(dir, lado)
	
	if dir == "x+" then
		if lado == "<" then 
			return "z+"
		else
			return "z-"
		end 
	elseif dir == "x-" then
		if lado == "<" then 
			return "z-"
		else
			return "z+"
		end 
	elseif dir == "z+" then
		if lado == "<" then 
			return "x-"
		else
			return "x+"
		end 
	elseif dir == "z-" then
		if lado == "<" then 
			return "x+"
		else
			return "x-"
		end
	end
end


-- Pegar uma direcao aleatoriamente
--[[
	Essa função retona uma direção aleatoriamente
	Retorno:
		<dir> é uma direção aleatória
	Argumentos:
		<exeto> OPCIONAL | é uma tabela ordenada
			de direção que devem ser evitadas
			(ex. {"x+", "z-"})
  ]]
sunos.pegar_dir_aleatoria = function(exeto)
	local d = {"x+", "x-", "z+", "z-"}
	
	if exeto and table.maxn(exeto) > 0 then
		for _,dir2 in ipairs(exeto) do
			for n,dir in ipairs(d) do
				if dir == dir2 then
					table.remove(d, n)
				end
			end
		end
	end
	
	return d[math.random(1, table.maxn(d))]
end


-- Forçar tentar pegar solo
--[[
	Essa função é similar à sunos.pegar_solo, mas
	não força um retorno não nulo.
	Retorno:
		<pos> pos de um solo
	Argumentos:
		<pos> é uma pos onde será analizado
		<degrau> é um valor booleano para que retorne
			uma <pos> com apenas 1 de diferença de altura
			(util para montar diferença suave de alturas/degrais)
		<dist> OPCIONAL | é a distancia que o loop 
			acontece descendo (padrão é o mesmo de sunos.pegar_solo) 
		<subir> OPCIONAL | é uma distância para cima que o
			loop deve iniciar (padrão é 0)
  ]]
sunos.f_pegar_solo = function(p, degrau, dist, subir)

	if subir == nil then subir = 0 end
	local s = sunos.pegar_solo(p, dist, subir)
	if s == nil then
		s = p
		local pp = minetest.find_node_near(p, 2, {"default:cobble"})
		if pp then s.y = pp.y end
	end
	if degrau then
		if s.y > p.y then
			s.y = p.y + 1
		elseif s.y < p.y then
			s.y = p.y - 1
		end
	end
	return s
end

-- Verificar se uma estrutura esta inalterada
--[[
	Essa função verifica se uma estrutura esta inalterada 
	ou obstruida por um jogador (analizando apenas o entorno da estrutura)
	Retorno:
		<booleano> (true == inalterada | false == obstruida)
	Argumentos:
		<pos> é uma pos do fundamento da estrutura verificada
		<dist> do centro a borda da estrutura
  ]]
sunos.verificar_estrutura = function(pos, dist)
	sunos.checkvar(pos, dist, "Parametro(s) invalido(s) para verificar estrutura")
	
	-- Nodes de solo de entorno
	local nodes_solo_entorno = {"default:dirt_with_grass", "default:cobble"}
	
	-- Verificar o solo do entorno
	local nodes_solo_1 = minetest.find_nodes_in_area( -- X+
		{x=pos.x+dist+1, y=pos.y, z=pos.z-dist}, 
		{x=pos.x+dist+1, y=pos.y, z=pos.z+dist+1}, 
		nodes_solo_entorno
	)
	local nodes_solo_2 = minetest.find_nodes_in_area( -- X-
		{x=pos.x-dist-1, y=pos.y, z=pos.z-dist-1}, 
		{x=pos.x-dist-1, y=pos.y, z=pos.z+dist}, 
		nodes_solo_entorno
	)
	local nodes_solo_3 = minetest.find_nodes_in_area( -- Z+
		{x=pos.x-dist-1, y=pos.y, z=pos.z+dist+1}, 
		{x=pos.x+dist, y=pos.y, z=pos.z+dist+1}, 
		nodes_solo_entorno
	)
	local nodes_solo_4 = minetest.find_nodes_in_area( -- Z-
		{x=pos.x-dist, y=pos.y, z=pos.z-dist-1}, 
		{x=pos.x+dist+1, y=pos.y, z=pos.z-dist-1}, 
		nodes_solo_entorno
	)
	local total_nodes_solo = table.maxn(nodes_solo_1) + table.maxn(nodes_solo_2) + table.maxn(nodes_solo_3) + table.maxn(nodes_solo_4)
	
	-- Verificando a superficie do entorno
	local nodes_acima_solo_1 = minetest.find_nodes_in_area( -- X+
		{x=pos.x+dist+1, y=pos.y+1, z=pos.z-dist}, 
		{x=pos.x+dist+1, y=pos.y+1, z=pos.z+dist+1}, 
		{"air"}
	)
	local nodes_acima_solo_2 = minetest.find_nodes_in_area( -- X-
		{x=pos.x-dist-1, y=pos.y+1, z=pos.z-dist-1}, 
		{x=pos.x-dist-1, y=pos.y+1, z=pos.z+dist}, 
		{"air"}
	)
	local nodes_acima_solo_3 = minetest.find_nodes_in_area( -- Z+
		{x=pos.x-dist-1, y=pos.y+1, z=pos.z+dist+1}, 
		{x=pos.x+dist, y=pos.y+1, z=pos.z+dist+1}, 
		{"air"}
	)
	local nodes_acima_solo_4 = minetest.find_nodes_in_area( -- Z-
		{x=pos.x-dist, y=pos.y+1, z=pos.z-dist-1}, 
		{x=pos.x+dist+1, y=pos.y+1, z=pos.z-dist-1}, 
		{"air"}
	)
	local total_nodes_acima_solo = table.maxn(nodes_acima_solo_1) + table.maxn(nodes_acima_solo_2) + table.maxn(nodes_acima_solo_3) + table.maxn(nodes_acima_solo_4)
	
	-- Total de blocos verificados em cada faixa de altura
	local verificados_por_faixa = ( 2*(dist+1) ) * 4
	
	-- Tolerancia de obstruicao
	local tolerancia = 2*(dist) + 6
	
	if total_nodes_solo < verificados_por_faixa - tolerancia 
		or total_nodes_acima_solo < verificados_por_faixa - tolerancia 
	then
		return false
	else
		return true
	end
end

-- Verificar fundamentos de sunos por perto
--[[
	Essa função verifica se tem um fundamento de estrutura dos sunos
	muito perto de uma possivel nova estrutura.
	Retorno:
		<booleano> (true == aceitavel | false == obstruida)
	Argumentos:
		<pos> é a coordenada do fundamento da possivel nova estrutura
		<dist> do centro a borda da possivel nova estrutura
  ]]
sunos.verif_fundamento_muito_perto = function(pos, dist)
	sunos.checkvar(pos, dist, "Parametro(s) invalido(s) para verificar fundamento")
	
	-- Distancia a verificar
	-- Considerando a pior hipotese de uma estrutura de largura 13 e mais 1 bloco de espaço
	local dist_verif = (dist+1) + 7 + 1
	
	-- Pegar fundamento que podem interferir
	local nodes = minetest.find_nodes_in_area(
		{x=pos.x-dist_verif, y=pos.y-dist_verif, z=pos.z-dist_verif}, 
		{x=pos.x+dist_verif, y=pos.y+dist_verif, z=pos.z+dist_verif}, 
		{"sunos:fundamento"}
	)
	
	for _,pfund in ipairs(nodes) do
		local meta = minetest.get_meta(pfund)
		local dist_fund = tonumber(meta:get_string("dist"))
		local dist_pp = sunos.verif_dist_pos(pos, pfund)-- Distancia entre os fundamentos
		
		-- Verifica se tem espaço para as duas estruturas dos fundamentos
		if ((dist_fund+1) + 1 + (dist+1)) < dist_pp then
			return false
		end
	end
	
	return true
end




-- Verificar area carregada
--[[
	Verificar se todos os cantos de uma area esta carregada na memoria
	Retorno:
		<booleano> true para carregado e false para nao carregado
	Argumentos:
		<pos> pos central do chao da area
		<dist> distancia de centro a borda da area
  ]]
sunos.verif_carregamento = function(pos, dist)
	sunos.checkvar(pos, dist, "Parametro(s) invalido(s) para verificar carregamento")
	
	-- Pegar os 8 cantos da area
	local nn = {} -- nomes dos nodes
	local node = minetest.get_node({x=pos.x-dist, y=pos.y, z=pos.z-dist})
	nn[1] = node.name
	node = minetest.get_node({x=pos.x-dist, y=pos.y, z=pos.z+dist})
	nn[2] = node.name
	node = minetest.get_node({x=pos.x+dist, y=pos.y, z=pos.z+dist})
	nn[3] = node.name
	node = minetest.get_node({x=pos.x+dist, y=pos.y, z=pos.z+dist})
	nn[4] = node.name
	node = minetest.get_node({x=pos.x-dist, y=pos.y+14, z=pos.z-dist})
	nn[5] = node.name
	node = minetest.get_node({x=pos.x-dist, y=pos.y+14, z=pos.z+dist})
	nn[6] = node.name
	node = minetest.get_node({x=pos.x+dist, y=pos.y+14, z=pos.z+dist})
	nn[7] = node.name
	node = minetest.get_node({x=pos.x+dist, y=pos.y+14, z=pos.z+dist})
	nn[8] = node.name
	
	-- Verificar se algum node nao carregou
	for _,name in ipairs(nn) do
		if name == "ignore" then 
			return false
		end
	end
	return true
end

-- Verificar se uma estrutura existe na vila
-- Retorna o nome do arquivo da estrutura no banco ou nulo se nao existir a estrutura
-- Se houver mais de uma estrutura do tipo, retorna a primeira encontrada
sunos.verif_estrutura_existe = function(vila, estrutura)
	local lista = minetest.get_dir_list(minetest.get_worldpath() .. "/sunos/vila_" .. vila)
	for _,arquivo in ipairs(lista) do
		if string.match(arquivo, estrutura.."_") then
			return arquivo
		end
	end
end

-- Limpar NodeMetaData
sunos.limpar_metadados = function(pos1, pos2, nodes)
	for _,pos in ipairs(minetest.find_nodes_in_area(
		pos1, 
		pos2, 
		nodes or sunos.var.node_group.remover_metadados
	)) do
		local meta = minetest.get_meta(pos)
		meta:from_table() -- limpa metadados
	end
end

-- Verificar fundamento de um bau dos sunos
-- Coloca bau comum no lugar se der falha
sunos.verificar_fundamento_bau_sunos = function(pos)
	
	-- Força o caregamento do node
	local node = sunos.pegar_node(pos)
	
	local meta = minetest.get_meta(pos)	
	
	-- Verificar a coordenada do fundamento
	local pf = meta:get_string("pos_fundamento")
	if pf == "" then
		minetest.set_node(pos, {name="default:chest", param2=minetest.get_node(pos).param2})
		return
	end
	pf = minetest.deserialize(pf)
	
	-- Verificar se o fundamento ainda existe
	if minetest.get_node(pf).name ~= "sunos:fundamento" then
		minetest.set_node(pos, {name="default:chest", param2=minetest.get_node(pos).param2})
		return
	end
	return pf
end

-- Contar nodes estruturais na estrutura
sunos.contar_nodes_estruturais = function(pos, dist)
	dist = tonumber(dist)
	local pos1 = {x=pos.x-dist, y=pos.y, z=pos.z-dist}
	local pos2 = {x=pos.x+dist, y=pos.y+14, z=pos.z+dist}	
	
	return table.maxn(minetest.find_nodes_in_area(
		pos1, 
		pos2,	
		sunos.var.node_group.estrutura
	))
end 

-- Contar diferença de blocos estruturais originais e atuais
sunos.contar_blocos_destruidos = function(pos)
	
	local meta = minetest.get_meta(pos)
	local dist = tonumber(meta:get_string("dist"))
	
	-- Verifica integridade da estrutura
	local nd = tonumber(meta:get_string("nodes")) -- Numero de nodes inicial
	local ndrl = sunos.contar_nodes_estruturais(pos, dist) -- Numero de nodes real atual
	
	return (nd - ndrl)
end

-- Verificar nivel de acordo com a populacao
sunos.verif_nivel = function(pop, tb)
	if not pop then return end
	pop = tonumber(pop)
	for n,p in ipairs(tb) do
		-- Nivel maximo?
		if n == table.maxn(tb) and pop >= p then
			return n
		end
		-- Ultrapassou esse nivel?
		if pop >= p -- É maior que a pop desse nivel
			and pop < tb[n+1] -- Menor que o pop do proximo nivel
		then
			return n
		end
	end
	
	-- Não atingiu requisito pra nenhum nivel
	return 0
end

-- Remover todos os nodes em uma area
sunos.remover_todos_nodes_area = function(minp, maxp)
	local c_air = minetest.get_content_id"air"	
	
	-- Get the vmanip mapgen object and the nodes and VoxelArea
	local manip = minetest.get_voxel_manip()
	local e1, e2 = manip:read_from_map(minp, maxp)
	local area = VoxelArea:new{MinEdge=e1, MaxEdge=e2}
	local data = manip:get_data()
 
	-- Replace air with cobble
	for i in area:iter(
		minp.x, minp.y, minp.z,
		maxp.x, maxp.y, maxp.z
	) do
		data[i] = c_air
	end
 
	-- Return the changed nodes data, fix light and change map
	manip:set_data(data)
	manip:write_to_map()
	manip:update_map() -- update_map is deprecated soon
end

