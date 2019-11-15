--[[
	Mod Sovagxas para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Mapgen
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
		if node.name == "default:dirt" then
			r = {x=pos.x, y=pos.y-y, z=pos.z}
			break
		end
		y = y + 1
	end
	return r
end

-- Chamada de função para verificar mapa gerado
--[[
	São feita algumas verificações prévias importantes e 
	extração de posições de chão plano.
	Deve-se ter cuidado para evitar alto uso de memoria nas verificações
  ]]
local verificar_mapa_gerado = function(minp, maxp)
	
	if sovagxas.CHANCE < 1 then return end
	
	-- Verificar altura
	if minp.y < -70 or minp.y > 120 then return end
	
	-- Procura um tronco de arvore selvagem no bloco de mapa gerado
	local t = minetest.find_node_near({x=minp.x+20, y=minp.y+40, z=minp.z+20}, 8, {"default:jungletree"})
	
	-- Verifica se encontrou um tronco
	if not t then return end
	
	-- Verifica se etá muito perto de outra árvore mãe (varredura do tamanho de um bloco de mapa)
	if minetest.find_node_near(t, 80, {"sovagxas:bau"}) then return end
	
	-- Pega a coordenada do solo do tronco encontrado
	local pos = pegar_solo(t)
	
	-- Verifica se encontrou um solo
	if not pos then return end
	
	-- Verifica se tem terra ou pedra no local onde vai ficar a copa da arvore
	if minetest.find_node_near({x=pos.x, y=pos.y+15, z=pos.z}, 10, {"group:stone", "group:dirt", "group:sand"}) then return end
	
	-- Sortear chance de criar arvore
	if math.random(1, 100) > sovagxas.CHANCE then return end
	
	-- gerar arvore no local
	sovagxas.montar_arvore(pos)
end

minetest.register_on_generated(function(minp, maxp, seed)
	
	-- A verificação é feita apos um intervalo de tempo para garantir que o mapa foi corretamente gerado
	minetest.after(2, verificar_mapa_gerado, minp, maxp)
end)



































