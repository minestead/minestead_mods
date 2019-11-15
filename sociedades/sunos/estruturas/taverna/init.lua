--[[
	Mod Sunos para Minetest
	Copyright (C) 2018 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	taverna dos sunos
  ]]

-- Tradução de strings
local S = sunos.S

-- Tabela global de taverna
sunos.estruturas.taverna = {}

-- Caminho do diretório do mod
local modpath = minetest.get_modpath("sunos")

-- Diretrizes (carregamento de script)
dofile(minetest.get_modpath("sunos").."/estruturas/taverna/diretrizes.lua") 

-- Fundamento de taverna (carregamento de script)
dofile(minetest.get_modpath("sunos").."/estruturas/taverna/fundamento.lua") 

-- Placa de taverna (carregamento de script)
dofile(minetest.get_modpath("sunos").."/estruturas/taverna/placa.lua") 

-- Barril de taverna (carregamento de script)
dofile(minetest.get_modpath("sunos").."/estruturas/taverna/barril.lua") 

-- Nectar de frutas (carregamento de script)
dofile(minetest.get_modpath("sunos").."/estruturas/taverna/nectar.lua") 

-- Petisco de frutas (carregamento de script)
dofile(minetest.get_modpath("sunos").."/estruturas/taverna/petisco.lua") 

-- bau (carregamento de script)
dofile(minetest.get_modpath("sunos").."/estruturas/taverna/bau.lua") 

-- npc (carregamento de script)
dofile(minetest.get_modpath("sunos").."/estruturas/taverna/npc.lua")

-- Geradores de itens de reposição (carregamento de script)
dofile(minetest.get_modpath("sunos").."/estruturas/taverna/repo_nodes.lua")


local set_bau = function(pos, vila, dist)

	-- Verifica se tem baus na estrutura montada
	local baus = minetest.find_nodes_in_area(
		{x=pos.x-dist, y=pos.y, z=pos.z-dist}, 
		{x=pos.x+dist, y=pos.y+14, z=pos.z+dist}, 
		{"sunos:bau_taverna"}
	)
	-- Salva dados da estrutura no bau dela
	for _,pos_bau in ipairs(baus) do
		local meta = minetest.get_meta(pos_bau)
		meta:set_string("obs", "n") -- Verifica se esta obstruido
		meta:set_string("vila", vila) -- Numero da vila
		meta:set_string("pos_fundamento", minetest.serialize(pos)) -- Pos do fundamento
		meta:set_string("infotext", S("Bau de Taverna dos Sunos"))
		
		sunos.npcnode.set_npcnode(pos_bau, {
			tipo = "barman",
			occupation = "sunos:barman",
			checkin = sunos.npc_checkin.montar_checkin_simples(pos_bau),
		})
	end
	
end


-- Construir taverna de sunos
--[[
	Essa função construi uma taverna de sunos e configura o fundamento
	Retorno:
		^ true caso ocorra tudo bem
		^ string de erro caso algo de errado
	Argumentos:
		<pos> é a coordenada do fundamento da estrutura
		<vila> OPCIONAL | é o numero da vila a qual a estrutura decorativa pertence
		<verif_area> OPCIONAL | true verificar a area antes de montar a estrutura (retorna strings dos erros)
		<itens_repo> OPCIONAL | Repassado ao comando sunos.decor_repo para substituir itens de reposição
]]
sunos.estruturas.taverna.construir = function(pos, dist, vila)
	
	-- Remover jogadores da area construida (evitar travar em paredes)
	sunos.ajustar_jogadores(pos)
	
	-- Armazena dados do antigo fundamento caso exista
	local old_meta_tb = nil
	if minetest.get_node(pos).name == "sunos:fundamento" then
		old_meta_tb = minetest.get_meta(pos):to_table()
		if old_meta_tb.tipo ~= "taverna" then old_meta_tb = nil end
	end
	
	-- Distancia centro a borda padrão
	dist = 5 
	
	-- Pegar nivel
	local nivel = sunos.verif_nivel(sunos.bd.pegar("vila_"..vila, "pop_total"), sunos.estruturas.taverna.var.niveis)
	if nivel == 0 then nivel = 1 end -- evita pegar nivel 0
	
	-- Criar casa taverna
	
	local rotat = sunos.pegar_rotat()
	local schem = "nivel_"..nivel
	
	-- Pega schem ja existente
	-- Atualizar schem do nivel
	if old_meta_tb ~= nil and old_meta_tb.schem ~= nil then
		rotat = old_meta_tb.rotat
		schem = old_meta_tb.schem
	end
	
	-- Atualizar schem do nivel
	local schem = "nivel_" .. nivel
	
	-- Caminho do arquivo da estrutura
	local caminho_arquivo = modpath.."/schems/taverna/"..schem..".11.mts"
	
	-- Variaveis auxiliares
	local largura = 11
	local pos1 = {x=pos.x-dist, y=pos.y, z=pos.z-dist}
	local pos2 = {x=pos.x+dist, y=pos.y+14, z=pos.z+dist}
	
	-- Limpar metadados dos nodes que possam estar la
	sunos.limpar_metadados(pos1, pos2)
	
	-- Criar estrutura
	minetest.place_schematic({x=pos.x-dist,y=pos.y,z=pos.z-dist}, caminho_arquivo, rotat, sunos.var.nodes_trocados, true)
	
	-- Colocar saidas para rua
	sunos.saida_para_rua(pos, dist)
	
	-- Recoloca itens reais (apartir dos itens de reposição)
	sunos.decor_repo(pos, dist, sunos.estruturas.taverna.gerar_itens_repo[tostring(nivel)]())
	
	-- Verifica se já tem fundamento
	if old_meta_tb ~= nil then
		-- Reestabelece fundamento
		minetest.set_node(pos, {name="sunos:fundamento"})
		local meta = minetest.get_meta(pos)
		meta:from_table(old_meta_tb) -- recoloca metadados no novo fumdamento
		-- Atualiza dados no fundamento
		meta:set_string("schem", schem) -- Nome do arquivo da esquematico da estrutura
		
	-- Novo fundamento
	else
		-- Colocar fundamento e configurar
		sunos.colocar_fundamento(pos, {
			vila = vila,
			tipo = "taverna",
			dist = dist,
			num = sunos.nova_estrutura(vila),
			schem = schem,
			rotat = rotat,
		})
	end
	
	-- Configura alguns metadados adicionais
	local meta = minetest.get_meta(pos)
	meta:set_string("nivel", nivel) -- Nivel da taverna
	
	-- Salvar novos dados da estrutura no banco de dados da vila
	local registros = {
		vila = vila, -- Numero da vila
		nivel = nivel, -- Nivel da Taverna
		estrutura = {
			dist = dist,
			largura = largura,
			pos = pos
		}
	}
	sunos.bd.salvar("vila_"..vila, "taverna", registros)
	
	-- Remover jogadores da area construida (evitar travar em paredes)
	sunos.ajustar_jogadores(pos)
	
	-- Ajustar nodes da estrutura
	
	-- Ajustar baus
	set_bau(pos, vila, dist)
	
	return true
end

-- Executado apos reestruturar casa
sunos.estruturas.taverna.apos_restaurar_estrutura = function(pos)
	
	local meta = minetest.get_meta(pos)
	local dist = tonumber(meta:get_string("dist"))
	local vila = meta:get_string("dist")
	
	-- Recoloca itens reais (apartir dos itens de reposição)
	sunos.decor_repo(pos, dist, sunos.estruturas.taverna.gerar_itens_repo[meta:get_string("nivel")]())
	meta:set_string("nodes", sunos.contar_nodes_estruturais(pos, dist)) -- Atualiza nodes estruturais
	
	-- Configura novos baus
	set_bau({x=pos.x,y=pos.y,z=pos.z}, vila, dist)
end

-- Verificação do fundamento
sunos.estruturas.taverna.verificar = function(pos)

	local meta = minetest.get_meta(pos)
	local vila = meta:get_string("vila")
	local dist = tonumber(meta:get_string("dist"))
	
	-- Verificar nivel minimo
	if sunos.verif_nivel(sunos.bd.pegar("vila_"..vila, "pop_total"), sunos.estruturas.taverna.var.niveis) == 0 then
		return false
	end
	
	-- Atualizar nivel
	-- Pegar nivel que a estrutura está
	local nivel_atual = meta:get_string("nivel")
	-- Pegar nivel que deve estar
	local nivel_novo = sunos.verif_nivel(sunos.bd.pegar("vila_"..vila, "pop_total"), sunos.estruturas.taverna.var.niveis)
	if tonumber(nivel_atual) ~= tonumber(nivel_novo) then
		-- Atualiza fundamento
		minetest.get_meta(pos):set_string("schem", "nivel_"..nivel_novo)
		sunos.estruturas.taverna.construir(pos, dist, vila)
	end
	
	return true
end

-- Verificação de estrutura defendida
sunos.estruturas.taverna.defendido = function(pos)
	
	-- Sempre protegido
	return true
	
end


