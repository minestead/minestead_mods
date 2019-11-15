--[[
	Mod Sovagxas para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Arvore
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

-- Verifica se toda a area da arvore já está carregada
local function verificar_area_carregada(pos)
	local n1 = pegar_node({x=pos.x-10, y=pos.y+30, z=pos.z-10})
	local n2 = pegar_node({x=pos.x-10, y=pos.y+30, z=pos.z+10})
	local n3 = pegar_node({x=pos.x+10, y=pos.y+30, z=pos.z-10})
	local n4 = pegar_node({x=pos.x+10, y=pos.y+30, z=pos.z+10})
	local n5 = pegar_node({x=pos.x-10, y=pos.y, z=pos.z-10})
	local n6 = pegar_node({x=pos.x-10, y=pos.y, z=pos.z+10})
	local n7 = pegar_node({x=pos.x+10, y=pos.y, z=pos.z-10})
	local n8 = pegar_node({x=pos.x+10, y=pos.y, z=pos.z+10})
	
	if n1.name == "ignore" 
		or n2.name == "ignore"
		or n3.name == "ignore"
		or n4.name == "ignore"
		or n5.name == "ignore"
		or n6.name == "ignore"
		or n7.name == "ignore"
		or n8.name == "ignore"
	then
		return false
	else
		return true
	end
end

-- Colocar uma arvore dos sovagxas
sovagxas.montar_arvore = function(pos)
	
	-- Verificar se está corretamente carregada
	if verificar_area_carregada(pos) == false then return end
	
	-- Parametros
	local altura_piso = 10
	local largura_piso = math.random(3,5)
	
	-- Montar copa
	-- colocar folhas
	local limx, limy, limz = pos.x + 8, pos.y + 6+8, pos.z + 8
	local x = pos.x - 8
	while x <= limx do
	
		local y = pos.y + 8
		while y <= limy do
		
			local z = pos.z - 8
			while z <= limz do
				
				if math.random(1,3) > 1 then
					minetest.set_node({x=x, y=y, z=z}, {name="sovagxas:jungleleaves"})
				end
				
				z = z + 1
			end
			
			y = y + 1
		end
		
		x = x + 1
	end
	-- colocar troncos (para manter as folhas)
	limx, limy, limz = pos.x + 7, pos.y + 6+8-1, pos.z + 7
	x = pos.x - 7
	while x <= limx do
	
		local y = pos.y + 8+1
		while y <= limy do
		
			local z = pos.z - 7
			while z <= limz do
				
				if math.random(1,50) <= 3 then
					minetest.set_node({x=x, y=y, z=z}, {name="default:jungletree"})
				end
				
				z = z + 1
			end
			
			y = y + 1
		end
		
		x = x + 1
	end
	
	-- Remover rebarbas da copa na parte de cima
	-- Remover pelo eixo Z
	limx, limy, limz = pos.x + 8, pos.y + 6+8, pos.z + 8
	y = pos.y + 6+8
	x = pos.x - 8
	while x <= limx do
	
		local z = pos.z - 8
		while z <= limz do
			
			minetest.remove_node({x=x, y=y, z=z})
			
			z = z + 16
		end
		
		x = x + 1
	end
	-- Remover pelo eixo X
	limx, limy, limz = pos.x + 8, pos.y + 6+8, pos.z + 8
	y = pos.y + 6+8
	x = pos.x - 8
	while x <= limx do
	
		local z = pos.z - 8
		while z <= limz do
			
			minetest.remove_node({x=x, y=y, z=z})
			
			z = z + 1
		end
		
		x = x + 16
	end
	
	-- Remover rebarbas laterais
	limx, limy, limz = pos.x + 8, pos.y + 6+8, pos.z + 8
	x = pos.x - 8
	while x <= limx do
	
		local y = pos.y + 8
		while y <= limy do
		
			local z = pos.z - 8
			while z <= limz do
				
				minetest.remove_node({x=x, y=y, z=z})
				
				z = z + 16
			end
			
			y = y + 1
		end
		
		x = x + 16
	end
	-- Remover rebarbas laterais superiores (com leve redução das distancias ao centro)
	limx, limz = pos.x + 7, pos.z + 7
	y = pos.y + 6+8
	x = pos.x - 7
	while x <= limx do
		
		local z = pos.z - 7
		while z <= limz do
			
			minetest.remove_node({x=x, y=y, z=z})
			
			z = z + 14
		end
		
		x = x + 14
	end
	
	-- Colocar faixa de folhas reduzida em cima
	limx, limz = pos.x + 5, pos.z + 5
	y = pos.y + 6+8+1
	x = pos.x - 5
	while x <= limx do
		
		local z = pos.z - 5
		while z <= limz do
			
			if math.random(0,1) > 0 then
				minetest.set_node({x=x, y=y, z=z}, {name="sovagxas:jungleleaves"})
			end
			
			z = z + 1
		end
		
		x = x + 1
	end
	
	-- Colocar faixa de folhas reduzida em baixo
	limx, limz = pos.x + 6, pos.z + 6
	y = pos.y + 8-1
	x = pos.x - 6
	while x <= limx do
		
		local z = pos.z - 6
		while z <= limz do
			
			if math.random(0,1) > 0 then
				minetest.set_node({x=x, y=y, z=z}, {name="sovagxas:jungleleaves"})
			end
			
			z = z + 1
		end
		
		x = x + 1
	end
	
	-- montar piso da copa da arvore
	local x = pos.x - largura_piso
	while x <= pos.x + largura_piso do
		
		local z = pos.z - largura_piso
		while z <= pos.z + largura_piso do
		
			minetest.set_node({x=x, y=pos.y+altura_piso, z=z}, {name="default:junglewood"})
			minetest.set_node({x=x, y=pos.y+altura_piso+1, z=z}, {name="air"})
			minetest.set_node({x=x, y=pos.y+altura_piso+2, z=z}, {name="air"})
			
			z = z + 1
		end
		
		x = x + 1
	end
	
	-- tocos para sugerar as folhas
	minetest.set_node({x=pos.x+largura_piso+1, y=pos.y+altura_piso+1, z=pos.z+largura_piso+1}, {name="default:jungletree"})
	minetest.set_node({x=pos.x-largura_piso-1, y=pos.y+altura_piso+1, z=pos.z+largura_piso+1}, {name="default:jungletree"})
	minetest.set_node({x=pos.x+largura_piso+1, y=pos.y+altura_piso+1, z=pos.z-largura_piso-1}, {name="default:jungletree"})
	minetest.set_node({x=pos.x-largura_piso-1, y=pos.y+altura_piso+1, z=pos.z-largura_piso-1}, {name="default:jungletree"})
	
	-- montar tronco
	local i = 1
	minetest.set_node({x=pos.x+1, y=pos.y, z=pos.z}, {name="default:jungletree"}) -- aprofundando raizes
	minetest.set_node({x=pos.x, y=pos.y, z=pos.z+1}, {name="default:jungletree"})
	while (i <= altura_piso) do
		minetest.set_node({x=pos.x+1, y=pos.y+i, z=pos.z}, {name="default:jungletree"})
		minetest.set_node({x=pos.x, y=pos.y+i, z=pos.z+1}, {name="default:jungletree"})
		minetest.set_node({x=pos.x, y=pos.y+i, z=pos.z}, {param1 = 93, name = "default:ladder", param2 = 2})
		i = i + 1
	end
	minetest.set_node({x=pos.x, y=pos.y+altura_piso+1, z=pos.z}, {name = "doors:trapdoor"}) -- alcapao
	
	-- tochas da copa da arvore
	local p_tocha = minetest.find_nodes_in_area({x=pos.x-largura_piso+1, y=pos.y+altura_piso, z=pos.z-largura_piso+1}, {x=pos.x+largura_piso-1, y=pos.y+altura_piso, z=pos.z+largura_piso-1}, {"default:junglewood"})
	local i = 1
	while i <= 7 do
		local p = p_tocha[math.random(1, table.maxn(p_tocha))]
		if p_tocha then
			minetest.set_node({x=p.x, y=p.y+1, z=p.z}, {name = "default:torch", param2 = 1})
		end
		i = i + 1
	end
	
	-- tochas no pe do tronco
	local p_tocha = minetest.find_nodes_in_area({x=pos.x-4, y=pos.y-4, z=pos.z-4}, {x=pos.x+4, y=pos.y+4, z=pos.z+4}, {"default:dirt_with_grass"})
	if p_tocha[1] then
		local tentativas = 0
		while tentativas <= 6 do
			tentativas = tentativas + 1
			local p = p_tocha[math.random(1, table.maxn(p_tocha))]
			
			if p_tocha then
				local node = minetest.get_node({x=p.x, y=p.y+1, z=p.z})
				if node.name == "air" then
					minetest.set_node({x=p.x, y=p.y+1, z=p.z}, {name = "default:torch", param2 = 1})
				end
			end
		end
	end
	
	-- Mobilia (definida por ordem de prioridade)
	-- definir lugares disponiveis
	local slots_mobilia = {
		-- lado +X
		{{x=pos.x+largura_piso, y=pos.y+altura_piso+1, z=pos.z-2}, 1},
		{{x=pos.x+largura_piso, y=pos.y+altura_piso+1, z=pos.z-1}, 1},
		{{x=pos.x+largura_piso, y=pos.y+altura_piso+1, z=pos.z}, 1},
		{{x=pos.x+largura_piso, y=pos.y+altura_piso+1, z=pos.z+1}, 1},
		{{x=pos.x+largura_piso, y=pos.y+altura_piso+1, z=pos.z+2}, 1},
		-- lado -X
		{{x=pos.x-largura_piso, y=pos.y+altura_piso+1, z=pos.z-2}, 3},
		{{x=pos.x-largura_piso, y=pos.y+altura_piso+1, z=pos.z-1}, 3},
		{{x=pos.x-largura_piso, y=pos.y+altura_piso+1, z=pos.z}, 3},
		{{x=pos.x-largura_piso, y=pos.y+altura_piso+1, z=pos.z+1}, 3},
		{{x=pos.x-largura_piso, y=pos.y+altura_piso+1, z=pos.z+2}, 3},
		-- lado +Z
		{{x=pos.x+2, y=pos.y+altura_piso+1, z=pos.z+largura_piso}, 0},
		{{x=pos.x+1, y=pos.y+altura_piso+1, z=pos.z+largura_piso}, 0},
		{{x=pos.x, y=pos.y+altura_piso+1, z=pos.z+largura_piso}, 0},
		{{x=pos.x-1, y=pos.y+altura_piso+1, z=pos.z+largura_piso}, 0},
		{{x=pos.x-2, y=pos.y+altura_piso+1, z=pos.z+largura_piso}, 0},
		-- lado -Z
		{{x=pos.x+2, y=pos.y+altura_piso+1, z=pos.z-largura_piso}, 2},
		{{x=pos.x+1, y=pos.y+altura_piso+1, z=pos.z-largura_piso}, 2},
		{{x=pos.x, y=pos.y+altura_piso+1, z=pos.z-largura_piso}, 2},
		{{x=pos.x-1, y=pos.y+altura_piso+1, z=pos.z-largura_piso}, 2},
		{{x=pos.x-2, y=pos.y+altura_piso+1, z=pos.z-largura_piso}, 2}
	}
	
	-- colocar 1 bau
	if slots_mobilia[1] then
		local i = math.random(1, table.maxn(slots_mobilia))
		minetest.set_node(slots_mobilia[i][1], {name = "default:chest", param2 = slots_mobilia[i][2]})
		table.remove(slots_mobilia, i)
	end
	
	-- colocar 1 bau dos sovagxas
	if slots_mobilia[1] then
		local i = math.random(1, table.maxn(slots_mobilia))
		minetest.set_node(slots_mobilia[i][1], {name = "sovagxas:bau", param2 = slots_mobilia[i][2]})
		
		local meta = minetest.get_meta(slots_mobilia[i][1])
		meta:set_string("arvore", minetest.serialize({x=pos.x,y=pos.y+altura_piso+1,z=pos.z}))
		
		-- limpa em cima para poder spawnar melhor
		minetest.set_node({x=slots_mobilia[i][1].x, y=slots_mobilia[i][1].y+2, z=slots_mobilia[i][1].z}, {name="air"})
		minetest.set_node({x=slots_mobilia[i][1].x, y=slots_mobilia[i][1].y+2, z=slots_mobilia[i][1].z+1}, {name="air"})
		minetest.set_node({x=slots_mobilia[i][1].x, y=slots_mobilia[i][1].y+2, z=slots_mobilia[i][1].z-1}, {name="air"})
		minetest.set_node({x=slots_mobilia[i][1].x+1, y=slots_mobilia[i][1].y+2, z=slots_mobilia[i][1].z}, {name="air"})
		minetest.set_node({x=slots_mobilia[i][1].x-1, y=slots_mobilia[i][1].y+2, z=slots_mobilia[i][1].z}, {name="air"})
		minetest.set_node({x=slots_mobilia[i][1].x, y=slots_mobilia[i][1].y+3, z=slots_mobilia[i][1].z}, {name="air"})
		minetest.set_node({x=slots_mobilia[i][1].x, y=slots_mobilia[i][1].y+3, z=slots_mobilia[i][1].z+1}, {name="sovagxas:jungleleaves"})
		minetest.set_node({x=slots_mobilia[i][1].x, y=slots_mobilia[i][1].y+3, z=slots_mobilia[i][1].z-1}, {name="sovagxas:jungleleaves"})
		minetest.set_node({x=slots_mobilia[i][1].x+1, y=slots_mobilia[i][1].y+3, z=slots_mobilia[i][1].z}, {name="sovagxas:jungleleaves"})
		minetest.set_node({x=slots_mobilia[i][1].x-1, y=slots_mobilia[i][1].y+3, z=slots_mobilia[i][1].z}, {name="sovagxas:jungleleaves"})
		
		-- Realiza procedimento para spawnar um NPC no bau
		minetest.after(2, sovagxas.verif_bau_sovagxa, slots_mobilia[i][1])
		
		table.remove(slots_mobilia, i)
	end
	
	-- colocar 1 Totem sovagxa
	if slots_mobilia[1] then
		local i = math.random(1, table.maxn(slots_mobilia))
		minetest.set_node(slots_mobilia[i][1], {name = "default:jungletree", param2 = slots_mobilia[i][2]})
		minetest.set_node({x=slots_mobilia[i][1].x, y=slots_mobilia[i][1].y+1, z=slots_mobilia[i][1].z}, {name = "sovagxas:totem_nodrop", param2 = slots_mobilia[i][2]})
		table.remove(slots_mobilia, i)
	end
	
	-- colocar Bancada de craftar Sovagxa
	if slots_mobilia[1] then
		local i = math.random(1, table.maxn(slots_mobilia))
		minetest.set_node(slots_mobilia[i][1], {name = "sovagxas:bancada_nodrop"})
		table.remove(slots_mobilia, i)
	end
	
	-- colocar 1 ou 2 fornos
	if slots_mobilia[1] then
		local qtd = math.random(1, 2)
		while qtd >= 1 do
			local i = math.random(1, table.maxn(slots_mobilia))
			minetest.set_node(slots_mobilia[i][1], {name = "default:furnace", param2 = slots_mobilia[i][2]})
			table.remove(slots_mobilia, i)
			qtd = qtd - 1
		end
	end
	
	-- colocar 1 Muda de arvore selvagem
	if slots_mobilia[1] then
		local i = math.random(1, table.maxn(slots_mobilia))
		minetest.set_node(slots_mobilia[i][1], {name = "default:junglesapling"})
		table.remove(slots_mobilia, i)
	end
	
	-- colocar 1 a 3 Arbusto selvagem
	if slots_mobilia[1] then
		local qtd = math.random(1, 3)
		while qtd >= 1 do
			local i = math.random(1, table.maxn(slots_mobilia))
			minetest.set_node(slots_mobilia[i][1], {name = "default:junglegrass"})
			table.remove(slots_mobilia, i)
			qtd = qtd - 1
		end
	end
	
	-- Coloca novo npc
	do
		local pos_bau = minetest.find_node_near({x=pos.x, y=pos.y+altura_piso, z=pos.z}, 10, {"sovagxas:bau"})
		if pos_bau then
			local node_bau = minetest.get_node(pos_bau)
			local p = minetest.facedir_to_dir(node_bau.param2)
			local spos = {x=pos_bau.x-p.x,y=pos_bau.y+1.5,z=pos_bau.z-p.z}
			local obj = minetest.add_entity(spos, "sovagxas:npc") -- Cria o mob
	
			-- Salva alguns dados na entidade inicialmente
			if obj then
				local ent = obj:get_luaentity()
				ent.versao = sovagxas.versao
				ent.temp = 0 -- Temporizador
				ent.pos_bau = pos_bau -- Pos do bau
			end
		end
	end
end
