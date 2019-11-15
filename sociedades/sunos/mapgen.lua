--[[
	Mod Sunos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Analize de mapgen
  ]]


-- Pega ignore apenas se bloco nao foi gerado
local function pegar_node(pos)
	local node = minetest.get_node(pos)
	if node.name == "ignore" then
		minetest.get_voxel_manip():read_from_map(pos, pos)
		node = minetest.get_node(pos)
	end
	return node
end


-- Encontrar solo
--[[
	Verifica 80 blocos de uma coluna.
	Feita para verificar MapBlocks (blocos de mapa)
  ]]
local function pegar_solo(pos)
	local y = 0
	local r = nil
	while y <= 79 do
		local node = pegar_node({x=pos.x, y=pos.y-y, z=pos.z})
		if node.name == "default:dirt_with_grass" then
			r = {x=pos.x, y=pos.y-y, z=pos.z}
			break
		end
		y = y + 1
	end
	return r
end


-- Verifica se um ponto existe na malha
local function verificar_ponto(x, z)
	if x < 1 or x > 7 or z < 1 or z > 7 then 
		return false
	else
		return true
	end
end

-- Comparar valor max
local function comparar_max(max, n)
	if max == nil then
		return n
	elseif max < n then
		return n
	else
		return max
	end
end

-- Comparar valor min
local function comparar_min(min, n)
	if min == nil then
		return n
	elseif min > n then
		return n
	else
		return min
	end
end

-- Montar malha e coletar dados nos pontos
local pegar_malha = function(minp, maxp)	
	local vetor = {}
	
	-- Vetor de dados
	for x=1, 7 do
		vetor[x] = {}
		for z=1, 7 do
			vetor[x][z] = {}
		end
	end
	
	-- Pegando dados para cada posicao
	for x,_ in ipairs(vetor) do
		for z,_ in ipairs(vetor[x]) do
		
			-- Pegar solo
			vetor[x][z].p = pegar_solo({x=minp.x+(10*x), y=maxp.y, z=minp.z+(10*z)})
			
			-- Calcular variacao dos pontos adjacentes
			local max, min = nil, nil
			local div = 0
			for xi=-1, 1 do
				for zi=-1, 1 do
					local xn, zn = x+xi, z+zi
					if verificar_ponto(xn, zn) then
						if vetor[xn][zn].p then
							max = comparar_max(max, vetor[xn][zn].p.y)
							min = comparar_min(min, vetor[xn][zn].p.y)
							div = div + 1
						end
					end
				end
			end
			if div >= 5 then
				vetor[x][z].var = max - min
			else
				vetor[x][z].var = nil
			end
		end
	end
	
	return vetor
end


-- Chamada de função para verificar mapa gerado
--[[
	São feita algumas verificações prévias importantes e 
	extração de posições de chão plano.
	Deve-se ter cuidado para evitar alto uso de memoria nas verificações
  ]]
local verificar_mapa_gerado = function(minp, maxp)
	
	if sunos.var.CHANCE < 1 then return end
	
	-- Verificar altura
	if minp.y < -70 or minp.y > 120 then return end
	
	-- Verificar se tem terra com grama no centro do bloco gerado
	local solo_central = pegar_solo({x=minp.x+40, y=maxp.y, z=minp.z+40}) -- Solo encontrado no centro
	if solo_central == nil then return end
	
	-- Evitar outras vilas dos sunos
	if minetest.find_node_near(solo_central, 100, {"group:sunos"}) ~= nil then return end 
	
	-- Evitar florestas
	--[[
		Se tiver arvore perto do centro, será descartado pois
		a area central é a area mais util do bloco.
		Agua tambem é evitada nessa parte.
	  ]]
	if minetest.find_node_near(solo_central, 10, {"group:tree", "group:water"}) ~= nil then return end
	
	
	-- Pegar malha
	local malha = pegar_malha(minp, maxp)
	
	-- Verificar quantidade de pontos em areas planos
	--[[
		Isso é uma analize de pontos da malha
	  ]]
	local rel = {nul=0,bom=0,ruim=0}
	local min = nil
	local pos = nil
	local vpos = {}
	for x,_ in ipairs(malha) do
		for z,_ in ipairs(malha[x]) do
			local po = malha[x][z]
			if po.var == nil then
				rel.nul = rel.nul + 1
			elseif po.var <= 3 then
				rel.bom = rel.bom + 1
				if malha[x][z].p then 
					table.insert(vpos, malha[x][z].p) 
				end
			else
				rel.ruim = rel.ruim + 1
			end
			if malha[x][z].p then
				if malha[x][z].var and min ~= comparar_min(min, malha[x][z].var) then
					min = comparar_min(min, malha[x][z].var)
					pos = malha[x][z].p
				elseif pos == nil then
					pos = malha[x][z].p
				end
			end
			
		end
	end
	
	-- Verifica quantidade aceitavel de areas planas
	if rel.bom < 10 then return end
	
	-- Sortear chance de criar vila
	if math.random(1, 100) > sunos.var.CHANCE then return end
	
	-- Criar vila
	sunos.criar_vila(pos, vpos)
end

-- A verificação é feita apos um intervalo de tempo para garantir que o mapa foi corretamente gerado
minetest.register_on_generated(function(minp, maxp, seed)
	minetest.after(5, verificar_mapa_gerado, minp, maxp)
end)
