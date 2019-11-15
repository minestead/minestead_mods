--[[
	Mod Sunos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Verificar um terreno para construir
  ]]

-- Metodo para verificar se um terreno esta obstruido para construir
--[[
	Argumentos
		'pos' é a coordenada do centro do solo (primeira camada (de terra))
		'dist' distancia de blocos que vai do centro a cada direção 
	Retornos
		'0' sem obtrucoes
		'1' em cima da faixa de solo existem obstrucoes (nao esta limpo e plano)
		'2' faixa de solo (superficial) falta blocos de terra
		'3' faixa de subsolo (considerando 2 faixas) falta blocos de terra
  ]]
sunos.verif_terreno = function(pos, dist)
	sunos.checkvar(pos, dist, "Parametro(s) invalido(s) para verificar terreno")
	
	
	-- Verificar faixa de solo superficial
	do
		-- Pegar nodes de toda a area acima do solo onde ficara a estrutura
		local superf = minetest.find_nodes_in_area(
			{x=pos.x-dist, y=pos.y+1, z=pos.z-dist}, 
			{x=pos.x+dist, y=pos.y+14, z=pos.z+dist}, 
			{"air", "group:flower", "group:grass"}
		)
	
		if table.maxn(superf) < ((2*dist+1)^2)*14 then
			return 1
		end
	end
	
	-- Verificar faixa de solo superficial
	do
		-- Pegar nodes da faixa de terra
		local solo = minetest.find_nodes_in_area(
			{x=pos.x-dist, y=pos.y, z=pos.z-dist}, 
			{x=pos.x+dist, y=pos.y, z=pos.z+dist}, 
			{"default:dirt", "group:spreading_dirt_type"}
		)
	
		if table.maxn(solo) < ((2*dist+1)^2) then
			return 2
		end
	end
	
	-- Verificar faixa de subsolo considerando 2 faixas
	do
		-- Pegar nodes da faixa de terra
		local subsolo = minetest.find_nodes_in_area(
			{x=pos.x-dist, y=pos.y-2, z=pos.z-dist}, 
			{x=pos.x+dist, y=pos.y-1, z=pos.z+dist}, 
			{"group:stone", "group:cobble", "default:dirt", "group:spreading_dirt_type", "default:stone_with_coal", "default:gravel", "default:sandstone"}
		)
	
		if table.maxn(subsolo) < ( ((2*dist+1)^2) * 2) then
			return 3
		end
	end
	
	-- Retorna sem erros
	return 0
end
