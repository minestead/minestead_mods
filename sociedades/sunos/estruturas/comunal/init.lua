--[[
	Mod Sunos para Minetest
	Copyright (C) 2018 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Casa comunal
  ]]

-- Tradução de strings
local S = sunos.S

-- Diretorio do mod
local modpath = minetest.get_modpath("sunos")

-- Tabela global de Casa Comunal
sunos.estruturas.comunal = {}

-- Diretrizes
dofile(modpath.."/estruturas/comunal/diretrizes.lua") 

-- Bau de casa dos sunos (carregamento de script)
dofile(modpath.."/estruturas/comunal/bau.lua") 

-- Registros do NPC da casa (carregamento de script)
dofile(modpath.."/estruturas/comunal/npc.lua") 

-- Interface de atendimento da casa comunal (carregamento de script)
dofile(modpath.."/estruturas/comunal/interface.lua") 

-- Fundamento para colocação da casa comunal
dofile(modpath.."/estruturas/comunal/fundamento.lua") 

-- Nodes estruturais
local nodes_estruturais = sunos.estruturas.comunal.var.nodes_estruturais

local function pegar_node(pos)
	local node = minetest.get_node(pos)
	if node.name == "ignore" then
		minetest.get_voxel_manip():read_from_map(pos, pos)
		node = minetest.get_node(pos)
	end
	return node
end


-- Configurar baus de uma estrutura
local set_bau = function(pos, vila, dist)

	-- Ajustar baus
	-- Verifica se tem baus na estrutura montada
	local baus = minetest.find_nodes_in_area(
		{x=pos.x-dist, y=pos.y, z=pos.z-dist}, 
		{x=pos.x+dist, y=pos.y+15, z=pos.z+dist}, 
		{"default:chest"}
	)
	-- Salva dados da estrutura no bau dela
	for _,pos_bau in ipairs(baus) do
		local node = minetest.get_node(pos_bau)
		minetest.set_node(pos_bau, {name="sunos:bau_comunal", param2=node.param2})
		local meta = minetest.get_meta(pos_bau)
		meta:set_string("vila", vila) -- Numero da vila
		meta:set_string("pos_fundamento", minetest.serialize(pos)) -- Pos do fundamento
		meta:set_string("infotext", S("Bau da Casa Comunal dos Sunos"))
		
		sunos.npcnode.set_npcnode(pos_bau, {
			tipo = "comunal",
			occupation = "sunos:atendente_comunal",
			checkin = sunos.npc_checkin.montar_checkin_simples(pos_bau),
		})
	end
end

-- Construir casa comunal
--[[
	Essa função construi uma casa comunal e configura o fundamento
	Retorno:
		^ true caso ocorra tudo bem
		^ string de erro caso algo de errado
	Argumentos:
		<pos> é a coordenada do fundamento da estrutura
		<dist>
		<vila> é o numero da vila a qual a casa comunal pertence
  ]]
sunos.estruturas.comunal.construir = function(pos, dist, vila)
	
	-- Remover jogadores da area construida (evitar travar em paredes)
	sunos.ajustar_jogadores(pos)
	
	-- Armazena dados do antigo fundamento caso exista
	local old_meta_tb = nil
	if minetest.get_node(pos).name == "sunos:fundamento" then
		old_meta_tb = minetest.get_meta(pos):to_table()
		if old_meta_tb.tipo ~= "comunal" then old_meta_tb = nil end
	end
	
	-- Distancia centro a borda padrão
	dist = 6 
	
	-- Pegar nivel
	local nivel = sunos.verif_nivel(sunos.bd.pegar("vila_"..vila, "pop_total"), sunos.estruturas.comunal.var.niveis)
	if nivel == 0 then nivel = 1 end -- evita pegar nivel 0
	
	-- Criar casa comunal
	
	local rotat = sunos.pegar_rotat()
	local schem = "nivel_"..nivel
	
	-- Pega schem ja existente
	-- Atualizar schem do nivel
	if old_meta_tb ~= nil and old_meta_tb.schem ~= nil then
		rotat = old_meta_tb.rotat
		schem = old_meta_tb.schem
	end
	
	-- Caminho do arquivo da estrutura
	local caminho_arquivo = modpath.."/schems/comunal/"..schem..".13.mts"
	
	-- Variaveis auxiliares
	local largura = 13
	local pos1 = {x=pos.x-dist, y=pos.y, z=pos.z-dist}
	local pos2 = {x=pos.x+dist, y=pos.y+14, z=pos.z+dist}
	
	-- Limpar metadados dos nodes que possam estar la
	sunos.limpar_metadados(pos1, pos2)
	
	-- Criar estrutura
	minetest.place_schematic({x=pos.x-dist,y=pos.y,z=pos.z-dist}, caminho_arquivo, rotat, sunos.var.nodes_trocados, true)
	
	-- Colocar saidas para rua
	sunos.saida_para_rua(pos, dist)
	
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
			tipo = "comunal",
			dist = dist,
			num = sunos.nova_estrutura(vila),
			schem = schem,
			rotat = rotat,
		})
	end
	
	-- Configura alguns metadados adicionais
	local meta = minetest.get_meta(pos)
	meta:set_string("nivel", nivel) -- Nivel da casa comunal
	
	-- Salvar novos dados da estrutura no banco de dados da vila
	local registros = {
		vila = vila, -- Numero da vila
		nivel = nivel, -- Nivel da Casa Comunal
		estrutura = {
			dist = 6,
			largura = 13,
			pos = pos
		}
	}
	sunos.bd.salvar("vila_"..vila, "comunal", registros)
	
	-- Ajustar nodes da estrutura
	
	-- Ajustar baus
	set_bau(pos, vila, dist)
	
	return true
end

-- Executado apos reestruturar casa
sunos.estruturas.comunal.apos_restaurar_estrutura = function(pos)
	
	local meta = minetest.get_meta(pos)
	local dist = tonumber(meta:get_string("dist"))
	local vila = tonumber(meta:get_string("vila"))
	
	-- Configura novos baus
	set_bau({x=pos.x,y=pos.y,z=pos.z}, vila, dist)
end

-- Verifica estrutura caso suba de nivel
sunos.estruturas.comunal.verificar = function(pos)
	
	local meta = minetest.get_meta(pos)
	local vila = meta:get_string("vila")
	local dist = tonumber(meta:get_string("dist"))
	
	-- Verificar nivel minimo
	if sunos.verif_nivel(sunos.bd.pegar("vila_"..vila, "pop_total"), sunos.estruturas.comunal.var.niveis) == 0 then
		return false
	end
	
	-- Atualizar nivel
	-- Pegar nivel que a estrutura está
	local nivel_atual = meta:get_string("nivel")
	-- Pegar nivel que deve estar
	local nivel_novo = sunos.verif_nivel(sunos.bd.pegar("vila_"..vila, "pop_total"), sunos.estruturas.comunal.var.niveis)
	if tonumber(nivel_atual) ~= tonumber(nivel_novo) then
		-- Atualiza fundamento
		minetest.get_meta(pos):set_string("schem", "nivel_"..nivel_novo)
		sunos.estruturas.comunal.construir(pos, dist, vila)
	end
	
	return true
end

-- Verificação de estrutura defendida
sunos.estruturas.comunal.defendido = function(pos)
	
	-- Sempre protegido
	return true
	
end
