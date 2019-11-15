--[[
	Mod Sunos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Montagem de vilas
  ]]

-- Direções
local dirs = {
	"x+", -- 1
	"x-", -- 2
	"z+", -- 3
	"z-", -- 4
}

-- Validar bando de dados
if sunos.bd.verif("geral", "vilas") ~= true then
	sunos.bd.salvar("geral", "vilas", 0)
end

-- Registrar nova vila (retorna o numero da vila registrada)
local registrar_vila = function()
	
	-- Pegar quantidade vilas
	local n = tonumber(sunos.bd.pegar("geral", "vilas"))
	
	n = n + 1
	
	-- Criar registro
	sunos.bd.salvar("vila_"..n, "numero", n)
	
	-- Salvar versao
	sunos.bd.salvar("vila_"..n, "versao", sunos.versao)
	
	-- Salvar numero incial de estruturas
	sunos.bd.salvar("vila_"..n, "estruturas", 0)
	
	-- Atualizar quantidade de vilas
	sunos.bd.salvar("geral", "vilas", n)
	
	return n
end

-- Registrar nova estrutura (retorna o numero da estrutura registrada)
sunos.nova_estrutura = function(vila)
	if not vila then
		minetest.log("error", "[Sunos] vila nula (em sunos.nova_estrutura)")
		return false
	end
	-- Verificar se a vila ainda existe no banco de dados
	if sunos.bd.verif("vila_"..vila, "estruturas") ~= true then
		minetest.log("error", "[Sunos] A vila não existe no banco de dados (em sunos.nova_estrutura)")
		return false
	end
	
	-- Pega o numero atual de estruturas
	local n = sunos.bd.pegar("vila_"..vila, "estruturas")
	
	-- Soma 1
	n = n + 1
	
	-- Salva o novo numero de estruturas
	sunos.bd.salvar("vila_"..vila, "estruturas", n)
	
	-- Retorna o novo total
	return n
end

-- Node de assentamentos
minetest.register_node("sunos:assentamento_3", {
	description = "Assentamento 3",
	tiles = {"default_cloud.png"},
	is_ground_content = false,
	sounds = default.node_sound_defaults(),
	groups = {not_in_creative_inventory = 1, oddly_breakable_by_hand = 2},
	drop = "",
})
minetest.register_node("sunos:assentamento_5", {
	description = "Assentamento 5",
	tiles = {"default_cloud.png"},
	is_ground_content = false,
	sounds = default.node_sound_defaults(),
	groups = {not_in_creative_inventory = 1, oddly_breakable_by_hand = 2},
	drop = "",
})
minetest.register_node("sunos:assentamento_7", {
	description = "Assentamento 7",
	tiles = {"default_cloud.png"},
	is_ground_content = false,
	sounds = default.node_sound_defaults(),
	groups = {not_in_creative_inventory = 1, oddly_breakable_by_hand = 2},
	drop = "",
})
minetest.register_node("sunos:assentamento_9", {
	description = "Assentamento 9",
	tiles = {"default_cloud.png"},
	is_ground_content = false,
	sounds = default.node_sound_defaults(),
	groups = {not_in_creative_inventory = 1, oddly_breakable_by_hand = 2},
	drop = "",
})
minetest.register_node("sunos:assentamento_11", {
	description = "Assentamento 11",
	tiles = {"default_cloud.png"},
	is_ground_content = false,
	sounds = default.node_sound_defaults(),
	groups = {not_in_creative_inventory = 1, oddly_breakable_by_hand = 2},
	drop = "",
})
-- Remove nodes que ficarem jogados pelo mapa
local limpar_assent = function(pos)
	if not pos then return end
	local n = minetest.get_node(pos).name
	if n == "sunos:assentamento_3"
		or n == "sunos:assentamento_5"
		or n == "sunos:assentamento_7"
		or n == "sunos:assentamento_9"
		or n == "sunos:assentamento_11"
	then
		minetest.remove_node(pos)
	end
end
minetest.register_abm({
	nodenames = {
		"sunos:assentamento_3", 
		"sunos:assentamento_5", 
		"sunos:assentamento_7", 
		"sunos:assentamento_9",
		"sunos:assentamento_11"
	},
	interval = 5,
	chance = 1,
	action = function(pos)
		minetest.after(2, limpar_assent, {x=pos.x, y=pos.y, z=pos.z})	
	end,
})

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

-- Preencher com rua
local preencher_com_rua = function(vetor)
	for _,p in ipairs(vetor) do
		minetest.set_node(p, {name="sunos:rua_calcetada"})
	end
end

-- Verifica se o node é e retorna a altura y do degrau aceitavel
local ver_node_degrau = function(pos)
	-- Verifica se deve manter a altura
	if minetest.get_node(pos).name == "default:dirt_with_grass" 
		or minetest.get_node(pos).name == "sunos:rua_calcetada"  then return pos.y
	-- Verifica se deve subir
	elseif minetest.get_node(pos).name == "default:dirt" 
		or minetest.get_node(pos).name == "default:stone" then return pos.y + 1
	-- Verifica se deve descer
	elseif minetest.get_node(pos).name == "air" 
		and minetest.get_node({x=pos.x,y=pos.y-1,z=pos.z}).name == "default:dirt_with_grass" then return pos.y - 1
	else
		return pos.y
	end
end

-- Montar uma rua de p1 até p2 com vetores x ou z constante
local montar_rua = function(p1, p2)
	
	local v = {x=p1.x, y=p1.y, z=p1.z}
	
	if p1.x == p2.x then -- Movimento no eixo z
		if p1.z < p2.z then -- Movimento baseado em somas
			while v.z <= p2.z do
				v.y = ver_node_degrau(v) -- Atualiza a melhor altura do bloco de rua
				colocar_rua(v)
				v.z = v.z + 1
			end
			-- Arruma a coordenada v para corresponder corretamente à ultima coordenada de rua no solo
			v.z = v.z - 1
			
		else -- Movimento baseado em subtrações
			while v.z >= p2.z do
				v.y = ver_node_degrau(v) -- Atualiza a melhor altura do bloco de rua
				colocar_rua(v)
				v.z = v.z - 1
			end
			-- Arruma a coordenada v para corresponder corretamente à ultima coordenada de rua no solo
			v.z = v.z + 1
		end
	else -- Movimento no eixo x
		if p1.x < p2.x then -- Movimento baseado em somas
			while v.x <= p2.x do
				v.y = ver_node_degrau(v) -- Atualiza a melhor altura do bloco de rua
				colocar_rua(v)
				v.x = v.x + 1
			end
			-- Arruma a coordenada v para corresponder corretamente à ultima coordenada de rua no solo
			v.x = v.x - 1
			
		else -- Movimento baseado em subtrações
			while v.x >= p2.x do
				v.y = ver_node_degrau(v) -- Atualiza a melhor altura do bloco de rua
				colocar_rua(v)
				v.x = v.x - 1
			end
			-- Arruma a coordenada v para corresponder corretamente à ultima coordenada de rua no solo
			v.x = v.x + 1
		end
	end
	
	return v
end

-- Verificar se uma direção está obstruida (para montar uma rua até la)
--[[
	Argumentos:
		<pos> coordenada de onde a direção parte
		<dir> direção a ser analizada
		<dist> distancia de deslocamento na direção escolhida
	Retornos:
		<booleano> true caso nao esteja obstruida e false para caso esteja
  ]]
local verif_obs_dir = function(pos, dir, dist)
	local npos = sunos.ir_dir(pos, dir, 5)
	
	npos = sunos.pegar_solo(npos, 10, 5)
	
	if not npos 
		or npos.y > pos.y+1 
		or npos.y < pos.y-1 
		-- Evitar Arvores e agua
		or minetest.find_node_near(npos, 10, {"group:tree", "group:water"}) ~= nil
		-- Evitar que a rua fique colada em estruturas e outros
		or table.maxn(minetest.find_nodes_in_area({x=npos.x-1, y=npos.y-3, z=npos.z-1}, {x=npos.x+1, y=npos.y+3, z=npos.z+1}, {"group:spreading_dirt_type"})) ~= 9
		-- Verifica outros assentamentos perto
		--[[
			Considera-se uma area onde não deve existir determinado assentamentos
				+2 solo livre entre rua e assentamento
				+<distancia de deslocamento de cada centro:1,2,3,4 e 5>
		  ]]
		or minetest.find_node_near(npos, 3, {"sunos:assentamento_3"})
		or minetest.find_node_near(npos, 4, {"sunos:assentamento_5"})
		or minetest.find_node_near(npos, 5, {"sunos:assentamento_7"})
		or minetest.find_node_near(npos, 6, {"sunos:assentamento_9"})
		or minetest.find_node_near(npos, 7, {"sunos:assentamento_11"})
	then
		return false
	else
		return true
	end
end

-- Verificar se pode criar um assentamento (maior possivel) num local
--[[
	Argumentos:
		<pos> coordenada da rua que passa ao lado do assentamento
		<dir> direção da rua para onde se pretende verificar um assentamento
		<dist> distancia centro-a-borda do assentamento desejado
	Retornos:
		<dist> distancia centro-a-borda em que o assentamento pode ser feito (zero para lugar obstruido)
		[pos] coordenada do centro do solo do assentamento possivel (caso seja maior que zero)
  ]]
local verif_obs_assent = function(pos, dir, dist)
	
	-- Distancia centro-a-borda validada do assentamento (inicilamente nenhum foi validado)
	local dv = 0
	
	-- Laço que vai aumentando a largura do assentamento até atingir o mais proximo do desejado
	repeat 
	
		-- Distancia a ser analizada
		local d = dv + 1
		
		-- Calcular a coordenada do solo do assentamento
		--[[ 
			Inicialmente supoe-se que o assentamento seja de largura 3
			sendo assim deve-se deslocar da rua 
				+4 (vai até o primeiro bloco do assentamento deixando 3 bloco livre entre assentamento e rua)
				+d (vai ao centro do assentamento)
		  ]]
		local npos = sunos.ir_dir(pos, dir, (4+d))
		
		-- Verifica se tem blocos de solo nas faixas de terra aceitavel para a estrutura +4 de borda
		if table.maxn(minetest.find_nodes_in_area({x=npos.x-d-4, y=npos.y-1, z=npos.z-d-4}, {x=npos.x+d+4, y=npos.y+1, z=npos.z+d+4}, {"group:spreading_dirt_type"})) == (d*2+1+8)^2 
			-- Verifica se tem rua perto demais
			and minetest.find_node_near(npos, 3+d, {"sunos:rua_calcetada"}) == nil
			-- Verifica outros assentamentos perto
			--[[
				Considera-se uma area onde não deve existir determinado assentamentos
					+4 solo livre entre rua e assentamento
					+<distancia de deslocamento de cada centro:1,2,3,4 e 5> (+1 de teste)
					+d
			  ]]
			and minetest.find_node_near(npos, 6+d, {"sunos:assentamento_3"}) == nil
			and minetest.find_node_near(npos, 7+d, {"sunos:assentamento_5"}) == nil
			and minetest.find_node_near(npos, 8+d, {"sunos:assentamento_7"}) == nil
			and minetest.find_node_near(npos, 9+d, {"sunos:assentamento_9"}) == nil
			and minetest.find_node_near(npos, 10+d, {"sunos:assentamento_11"}) == nil
		then
			dv = d
		else
			-- Interrompe pois achou o ultimo tamanho valido
			break
		end
		
	until dv == dist
	
	-- Retorna os resultados
	if dv == 0 then
		return dv
	else
		-- Calcula o centro do assentamento final validado
		local np = sunos.ir_dir(pos, dir, (3+dv))
		return dv, np
	end
	
end

-- Montar rua em volta de estrutura
--[[
	O objetivo é criar umafaixa de rua em volta da estrutura 
	com 1 bloco livre
	Argumentos:
		<pos> coordenada do centro do solo da estrutura
		<dist> distancia de centro a borda da estrutura
  ]]
local montar_rua_estrutura = function(pos, dist)

	-- Movimentação no eixo z
	-- Vetor z é variavel e inicia na parte mais negaiva com um desconto de 1 bloco livre mais 1 da propria faixa
	do
		local z = pos.z - dist - 2
		while z <= pos.z+dist+2 do
		
			-- Pega a coordenada do solo
			local p1a = sunos.f_pegar_solo({x=pos.x-dist-2, y=pos.y, z=z}, false, 6, 3) -- com x-
			local p1b = sunos.f_pegar_solo({x=pos.x-dist-3, y=pos.y, z=z}, false, 6, 3) -- com x--
			local p2a = sunos.f_pegar_solo({x=pos.x+dist+2, y=pos.y, z=z}, false, 6, 3) -- com x+
			local p2b = sunos.f_pegar_solo({x=pos.x+dist+3, y=pos.y, z=z}, false, 6, 3) -- com x++
			
			-- Troca o node
			if p1a then colocar_rua(p1a) end
			if p1b then colocar_rua(p1b) end
			if p2a then colocar_rua(p2a) end
			if p2b then colocar_rua(p2b) end
		
			z = z + 1
		end
	end
	
	-- Movimentação no eixo x
	-- Vetor x é variavel e inicia na parte mais negaiva com um desconto de 1 bloco livre mais 1 da propria faixa
	do
		local x = pos.x - dist - 2
		while x <= pos.x+dist+2 do
		
			-- Pega a coordenada do solo
			local p1a = sunos.f_pegar_solo({x=x, y=pos.y, z=pos.z-dist-2}, false, 5, 2) -- com z-
			local p1b = sunos.f_pegar_solo({x=x, y=pos.y, z=pos.z-dist-3}, false, 5, 2) -- com z--
			local p2a = sunos.f_pegar_solo({x=x, y=pos.y, z=pos.z+dist+2}, false, 5, 2) -- com z+
			local p2b = sunos.f_pegar_solo({x=x, y=pos.y, z=pos.z+dist+3}, false, 5, 2) -- com z++
			
			-- Troca o node
			if p1a then colocar_rua(p1a) end
			if p1b then colocar_rua(p1b) end
			if p2a then colocar_rua(p2a) end
			if p2b then colocar_rua(p2b) end
		
			x = x + 1
		end
	end
end


-- Montar uma vila
--[[
	Descrição:
		Essa função cria uma vila em um lugar
	Argumentos:
		<pos_ref> é uma coordenada de referencia do local onde a vila será criada
  ]]
sunos.criar_vila = function(pos_ref)
	sunos.checkvar(pos_ref, "Coordenada de referencia nula ao criar uma vila")
	
	local pos = { -- Pos do vetor de movimentação
		x=pos_ref.x,
		y=pos_ref.y,
		z=pos_ref.z
	}
	
	-- Quantidades de assentamentos de acordo com suas larguras
	local larg_assent = {
		0, -- 3
		0, -- 5
		0, -- 7
		0, -- 9
		0  -- 11
	}
	
	-- Vetor de coordenada que se movimenta sempre na faixa de altura do solo
	pos = sunos.f_pegar_solo(pos, false, 30, 15) 
	
	local assent = {} -- tabela de coordenadas de assentamentos criados
	
	--[[ 
		Um loop irá fazer com que um vetor de coordenada "movimente-se" pelo local (sempre na camada de solo) 
		desenhando a rua da vila e tentando colocar estruturas ao lado da rua
	  ]]
	do
	
		local dir = nil -- Direção do movimento atual
		
		-- Loop que realiza os movimentos
		for n = 1 , 12 do
			
			--
			-- Realizar movimento em alguma direção
			--
			
			-- Verifica quais lados estão disponíveis para a rua seguir
			local dir_ok = {} -- É uma tabela ordenada que pode conter todas ou nenhuma direção possivel
			for i,d in ipairs(dirs) do
				if verif_obs_dir(pos, d, 5) then
					table.insert(dir_ok, d)
				end
			end
			
			-- Sorteira uma das direções que estão ok
			if table.maxn(dir_ok) > 0 then
				dir = dir_ok[math.random(1, table.maxn(dir_ok))] -- Salva a direção sorteada
			else
				break
			end
			
			-- Pega a coordenada para onde o vetor 'pos' vai se movimentar
			local npos = sunos.ir_dir(pos, dir, 5)
			
			-- Monta uma rua entre npos e pos e ja pega a coordenada do solo da nova coordenada
			npos = montar_rua(pos, npos)
			
			-- Atualiza a nova coordenada do vetor pos
			pos = npos
			
			--
			-- Tentar colocar node de assentamento nos lados da rua
			--
			
			-- Sorteia uma direção
			local dir_sort = dirs[math.random(1,4)]
			
			-- Calcula as condições do possivel assentamento
			local d_assent, p_assent = verif_obs_assent(pos, dir_sort, 4)
			
			-- Planifica assentamento
			if d_assent ~= 0 then
				sunos.planificar(p_assent, "quadrada", (d_assent*2+1), 10, {solo="default:dirt_with_grass", subsolo="default:dirt", rocha="default:stone"}, 3, true, true)
				-- Atualiza a coordenada do solo
				p_assent = sunos.pegar_solo(p_assent, 8, 4) or p_assent
			end
			
			-- Verifica se o assentamento foi validade
			if d_assent == 1 then 
				-- Colocar node que demarca o assentamento 2 nodes acima do solo
				minetest.set_node({x=p_assent.x, y=p_assent.y+2, z=p_assent.z}, {name="sunos:assentamento_3"})
			elseif d_assent == 2 then 
				-- Colocar node que demarca o assentamento 2 nodes acima do solo
				minetest.set_node({x=p_assent.x, y=p_assent.y+2, z=p_assent.z}, {name="sunos:assentamento_5"})
			elseif d_assent == 3 then 
				-- Colocar node que demarca o assentamento 2 nodes acima do solo
				minetest.set_node({x=p_assent.x, y=p_assent.y+2, z=p_assent.z}, {name="sunos:assentamento_7"})
			elseif d_assent == 4 then 
				-- Colocar node que demarca o assentamento 2 nodes acima do solo
				minetest.set_node({x=p_assent.x, y=p_assent.y+2, z=p_assent.z}, {name="sunos:assentamento_9"})
			elseif d_assent == 5 then 
				-- Colocar node que demarca o assentamento 2 nodes acima do solo
				minetest.set_node({x=p_assent.x, y=p_assent.y+2, z=p_assent.z}, {name="sunos:assentamento_11"})
			end
			-- Criar node de assentamento em um lugar que puder (esboço)
			
			-- Salva coordenada do assentamento
			if d_assent ~= 0 then
				table.insert(assent, {pos=p_assent,dist=d_assent})
				
				-- Salva o numero de assentamentos com a largura atual
				larg_assent[d_assent] = larg_assent[d_assent]+1
			end
			
		end
	end
	
	-- Montar estruturas nos assentamentos criados
	--[[
		Nessa etapa é verificado se os assentamentos são aceitaveis para uma vila
	  ]]
	if larg_assent[2]+larg_assent[3]+larg_assent[4]+larg_assent[5] >= 2 then
		
		-- Variavel que verifica se ja colocou ao menos uma casa
		local tem_casa = false
		
		-- Registra a nova vila
		local vila = registrar_vila(table.maxn(assent))
		
		-- Cria cada casa
		for n,dados in ipairs(assent) do
			
			-- Tipo
			local tipo = "casa"
			
			-- Largura
			local largura = dados.dist*2+1
		
			-- Verifica se deve colocar uma feirinha
			--if largura == 5 and tem_casa and tem_loja == false then tipo = "loja" end
			
			-- Troca o tipo para decor caso a largura seja 3
			if largura == 3 then tipo = "decor" end
			
			-- Colocar rua em volta da estrutura montada
			montar_rua_estrutura(dados.pos, dados.dist)
			
			if tipo == "casa" then
				
				-- Montar casa
				sunos.estruturas.casa.construir(dados.pos, dados.dist, vila, false, true, false, true)
				tem_casa = true
				
			elseif tipo == "decor" then
				
				-- Montar estrutura decorativa
				sunos.estruturas.decor.construir(dados.pos, dados.dist, vila)
				
				-- Preencher o entorno com ruas
				preencher_com_rua(minetest.find_nodes_in_area(
					{x=dados.pos.x-dados.dist-1, y=dados.pos.y, z=dados.pos.z-dados.dist-1}, 
					{x=dados.pos.x+dados.dist+1, y=dados.pos.y, z=dados.pos.z+dados.dist+1}, 
					{"default:dirt_with_grass"}
				))
				
			elseif tipo == "loja" then
				
				sunos.estruturas.loja.construir(dados.pos, dados.dist, vila, false, true)
				
				tem_loja = true
			end
			
		end
		
		-- Atualizar banco de dados
		sunos.atualizar_bd_vila(vila)
	
	else -- Assentamentos rejeitados. Montar ruinas nos lugares dos assentamentos
		
		-- Montar estrutura de ruina
		for _, dados in ipairs(assent) do
			sunos.montar_estrutura(dados.pos, dados.dist, "ruina")
		end
		
	end
end
