--[[
	Mod Sunos para Minetest
	Copyright (C) 2018 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Casa dos sunos
  ]]

-- Tradução de strings
local S = sunos.S

-- Tabela global de Casa
sunos.estruturas.casa = {}

-- Esse tipo de estrutura tem população
sunos.estruturas.casa.pop = true

-- Diretrizes das casas (carregamento de script)
dofile(minetest.get_modpath("sunos").."/estruturas/casa/diretrizes.lua") 

-- Métodos para gerar tabelas de itens para reposição de nodes (carregamento de script)
dofile(minetest.get_modpath("sunos").."/estruturas/casa/repo_nodes.lua") 

-- Bau de casa dos sunos (carregamento de script)
dofile(minetest.get_modpath("sunos").."/estruturas/casa/bau.lua") 

-- Registros do NPC da casa (carregamento de script)
dofile(minetest.get_modpath("sunos").."/estruturas/casa/npc.lua") 

-- Registros do NPC da casa (carregamento de script)
dofile(minetest.get_modpath("sunos").."/estruturas/casa/interface.lua") 

-- Buscar nodes numa casa
sunos.estruturas.casa.buscar_nodes = function(pos, nodes)
	local meta = minetest.get_meta(pos)
	local dist = meta:get_string("dist")
	return minetest.find_nodes_in_area(
		{x=pos.x-dist, y=pos.y, z=pos.z-dist}, 
		{x=pos.x+dist, y=pos.y+14, z=pos.z+dist}, 
		nodes
	)
end

local set_bau = function(pos, vila, dist)

	-- Verifica se tem baus na estrutura montada
	local baus = minetest.find_nodes_in_area(
		{x=pos.x-dist, y=pos.y, z=pos.z-dist}, 
		{x=pos.x+dist, y=pos.y+14, z=pos.z+dist}, 
		{"sunos:bau_casa"}
	)
	-- Salva dados da estrutura no bau dela
	for _,pos_bau in ipairs(baus) do
		local meta = minetest.get_meta(pos_bau)
		meta:set_string("obs", "n") -- Verifica se esta obstruido
		meta:set_string("vila", vila) -- Numero da vila
		meta:set_string("pos_fundamento", minetest.serialize(pos)) -- Pos do fundamento
		meta:set_string("infotext", S("Bau da Casa dos Sunos"))
		
		-- Configura cronograma do bau
		local occupation, checkin = sunos.estruturas.casa.select_occupation(pos_bau, vila)
		sunos.npcnode.set_npcnode(pos_bau, {
			tipo = "caseiro",
			occupation = occupation,
			checkin = checkin,
		})
		-- Data da ocupação
		meta:set_string("occupation_date", minetest.get_day_count())
	end
	
end

-- Construir casa de sunos
--[[
	Essa função construi uma casa de sunos e configura o fundamento
	Retorno:
		^ true caso ocorra tudo bem
		^ string de erro caso algo de errado
	Argumentos:
		<pos> é a coordenada do fundamento da estrutura
		<dist> distancia centro a borda da nova estrutura
		<vila> é o numero da vila a qual a casa pertence
  ]]
sunos.estruturas.casa.construir = function(pos, dist, vila)
	
	-- Escolhe uma rotação aleatória
	local rotat = minetest.get_meta(pos):get_string("rotat")
	if rotat == "" then
		rotat = sunos.pegar_rotat()
	end
	
	-- Largura
	local largura = (2*dist+1)
	
	-- Pega ou gera nome aleatório
	local schem = minetest.get_meta(pos):get_string("schem")
	if schem == "" then
		schem = sunos.pegar_arquivo(largura, "casa")
	end
	
	-- Variaveis auxiliares
	local largura = (dist*2)+1
	local pos1 = {x=pos.x-dist, y=pos.y, z=pos.z-dist}
	local pos2 = {x=pos.x+dist, y=pos.y+14, z=pos.z+dist}
	
	-- Limpar metadados dos nodes que possam estar la
	sunos.limpar_metadados(pos1, pos2)
	
	-- Cria estrutura
	local rm = sunos.montar_estrutura(pos, dist, "casa", rotat, schem)
	
	-- Recoloca itens reais (apartir dos itens de reposição)
	sunos.decor_repo(pos, dist, sunos.estruturas.casa.gerar_itens_repo[tostring(dist)]())
	
	-- Colocar saidas para rua
	sunos.saida_para_rua(pos, dist)
	
	-- Ajustar fornos
	sunos.ajustar_fornos(pos, dist)
	
	-- Ajustar estantes
	sunos.ajustar_estantes_livro(pos, dist, sunos.estruturas.casa.var.estante_livros) -- livros
	sunos.ajustar_estantes_frasco(pos, dist, sunos.estruturas.casa.var.estante_frascos) -- frascos
	
	-- Numero da estrutura da nova casa
	local n_estrutura = sunos.nova_estrutura(vila) -- Numero da nova estrutura
	
	-- Colocar fundamento e configurar
	sunos.colocar_fundamento(pos, {
		vila = vila,
		tipo = "casa",
		dist = dist,
		num = n_estrutura,
		schem = schem,
		rotat = rotat,
	})
	
	-- Registros a serem salvos
	local registros = {
		numero = n_estrutura,
		tipo = "casa",
		pop = sunos.estruturas.casa.var.tb_pop_casa[tostring(largura)] or 1,
		estrutura = {
			dist = dist,
			largura = largura,
			pos = pos
		}
	}
	
	-- Salva no banco de dados
	sunos.bd.salvar("vila_"..vila, "casa_"..n_estrutura, registros)
	
	-- Salvar novo total de estruturas da vila
	sunos.bd.salvar("vila_"..vila, "estruturas", n_estrutura)
	
	-- Configurar bau de casas
	minetest.after(1, set_bau, {x=pos.x,y=pos.y,z=pos.z}, vila, dist)
	
	-- Remover jogadores da area construida (evitar travar em paredes)
	sunos.ajustar_jogadores(pos)
	
	-- Atualiza banco de dados com nova estrutura (ajuste de população)
	sunos.atualizar_bd_vila(vila)
	
	return true
end

-- Executado apos reestruturar casa
sunos.estruturas.casa.apos_restaurar_estrutura = function(pos)
	
	local meta = minetest.get_meta(pos)
	local dist = tonumber(meta:get_string("dist"))
	local vila = meta:get_string("vila")
	
	-- Troca os itens de reposição
	sunos.decor_repo(pos, dist, sunos.estruturas.casa.gerar_itens_repo[tostring(dist)]())	
	meta:set_string("nodes", sunos.contar_nodes_estruturais(pos, dist)) -- Atualiza nodes estruturais
	
	-- Configura novos baus
	set_bau({x=pos.x,y=pos.y,z=pos.z}, vila, dist)
end

-- Verificação de estrutura defendida
sunos.estruturas.casa.defendido = function(pos)
	
	-- Sempre protegido
	return true
	
end

-- Nodes (carregamento de script)
dofile(minetest.get_modpath("sunos").."/estruturas/casa/fundamento.lua") 

