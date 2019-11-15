--[[
	Mod Sunos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Métodos para verificação de estruturas
  ]]

-- Contabilizar blocos estruturais
--[[
	Contabiliza quantos blocos estruturais tem na estrutura
	do fundamento da pos informada
	Retorno:
		Nenhum
	Argumentos:
		<pos> é a coordenada do fundamento da estrutura
		[nodes] é uma tabela ordenada com os nomes dos nodes a ser considerados estruturais
  ]]
sunos.contabilizar_blocos_estruturais = function(pos, nodes)
	sunos.checkvar(pos, nodes, "Parametro(s) invalido(s) para contabilizar nodes estruturais")
	
	
	local meta = minetest.get_meta(pos)
	local dist = tonumber(meta:get_string("dist"))
	
	local n = minetest.find_nodes_in_area(
		{x=pos.x-dist, y=pos.y, z=pos.z-dist}, 
		{x=pos.x+dist, y=pos.y+15, z=pos.z+dist}, 
		nodes or sunos.var.nodes_estruturais
	)
	
	meta:set_string("nodes", table.maxn(n))
end

-- Verifica quantidade de blocos estruturais
--[[
	Verifica quantos blocos estruturais tem na estrutura
	do fundamento da pos informada e compara com a quatidade
	armazenada para verificar obstrução
	Retorno:
		numero de nodes encontrados
	Argumentos:
		<pos> é a coordenada do fundamento da estrutura
		[nodes] é uma tabela ordenada com os nomes dos nodes a ser considerados estruturais
  ]]
sunos.verificar_blocos_estruturais = function(pos, nodes)
	sunos.checkvar(pos, nodes, "Parametro(s) invalido(s) para verificar nodes estruturais")
	
	-- Acessar metadados do fundamento
	local meta = minetest.get_meta(pos)
	
	-- Pegar distancia centro a borda da estrutura
	local dist = meta:get_string("dist")
	
	-- Pega todos os nodes estruturais presentes na estrutura atual
	local n = minetest.find_nodes_in_area(
		{x=pos.x-dist, y=pos.y, z=pos.z-dist}, 
		{x=pos.x+dist, y=pos.y+14, z=pos.z+dist}, 
		nodes or sunos.var.nodes_estruturais
	)
	
	return table.maxn(n)
end
