--[[
	Mod Sunos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Fundamento dos sunos
  ]]

-- Tradução de strings
local S = sunos.S

-- Diretorio do mundo
local worldpath = minetest.get_worldpath()

-- Fundamento dos sunos
--[[
	Esse é o node de fundamento das estruturas dos sunos
]]
minetest.register_node("sunos:fundamento", {
	description = S("Fundamento dos Sunos"),
	tiles = {"default_cobble.png^sunos_fundamento.png", "default_cobble.png", "default_cobble.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 1, not_in_creative_inventory=1},
	sounds = default.node_sound_wood_defaults(),
	drop = "default:cobble",
	
	-- Nao pode ser escavado/quebrado por jogadores
	on_dig = function() end,
	
	-- Clique direito para restaurar
	on_rightclick = function(pos, node, player, itemstack, pointed_thing)	
		sunos.verificar_fundamento(pos)
		local meta = minetest.get_meta(pos)
		local vila = meta:get_string("vila")
		local tipo = meta:get_string("tipo")
		
		if vila == "" or tipo == "" then return end
		
		-- Verificar se a estrutura está registrada
		if not sunos.estruturas[tipo] then return end
		
		-- Executar on_rightclick personalizado
		if sunos.estruturas[tipo].fund_on_rightclick then
			sunos.estruturas[tipo].fund_on_rightclick(pos, node, player, itemstack, pointed_thing)
		end
	
	end,
	
	-- Chamada ao ser removido do mapa
	on_destruct = function(pos)
		local meta = minetest.get_meta(pos)
		local versao = meta:get_string("versao")
		
		-- Verificar versao antes de tudo
		if sunos.verif_comp(versao) == false then return end
		
		local vila = meta:get_string("vila")
		local tipo = meta:get_string("tipo")
		local dist = meta:get_string("dist")
		
		if vila == "" or tipo == "" then return end
		
		-- Verificar se a estrutura está registrada
		if not sunos.estruturas[tipo] then return end
		
		-- Executa on_destruct personalizado
		if sunos.estruturas[tipo].fund_on_destruct then
			sunos.estruturas[tipo].fund_on_destruct(pos)
		end
		
		-- Remover do banco de dados caso o bloco seja removido
		sunos.bd.remover("vila_"..meta:get_string("vila"), tipo.."_"..meta:get_string("estrutura"))
		
		minetest.after(0.1, sunos.atualizar_bd_vila, vila)
	end,
	
	-- Impede explosão
	on_blast = function() end,
})

-- Funcao para verificar fundamentos
sunos.verificar_fundamento = function(pos)

	if not pos then return end
	
	local node = minetest.get_node(pos)
	
	if node.name ~= "sunos:fundamento" then return end
	
	local meta = minetest.get_meta(pos)
	
	local meta = minetest.get_meta(pos)
	local vila = meta:get_string("vila")
	if not vila then return end
	vila = tonumber(vila)
	local tipo = meta:get_string("tipo")
	local numero = meta:get_string("estrutura")
	local dist = tonumber(meta:get_string("dist"))
	
	-- Verificar mapa carregado antes de verificar estruturas
	if sunos.verif_carregamento(pos, tonumber(dist)) == false then
		return
	end
	
	-- Verifica se o registro da vila ainda existe no banco de dados
	if table.maxn(minetest.get_dir_list(worldpath.."/sunos/vila_"..vila)) == 0 then
		-- Trocar bloco de fundamento por madeira
		minetest.set_node(pos, {name="default:cobble"})
		-- Montar ruinas
		sunos.montar_ruinas(pos, dist)
		return
	end
	
	-- Verifica se o registro da estrutura ainda existe
	if sunos.bd.verif("vila_"..vila, tipo.."_"..numero) == false -- Caso seja uma estrutura repetivel
		and sunos.bd.verif("vila_"..vila, tipo) == false -- Caso seja uma estrutura única
	then
		-- Trocar bloco de fundamento por madeira
		minetest.set_node(pos, {name="default:cobble"})
		-- Montar ruinas
		sunos.montar_ruinas(pos, dist)
		return
	end
	
	-- Verifica se o registro no BD coincide na coordenada (podem existir estruturas duplicadas) apenas estruturas unicas
	if sunos.bd.verif("vila_"..vila, tipo) == true then
		local p = sunos.bd.pegar("vila_"..vila, tipo).estrutura.pos
		if p.x ~= pos.x or p.y ~= pos.y or p.z ~= pos.z then
			-- Exclui o arquivo da estrutura do banco de dados
			sunos.bd.remover("vila_"..vila, tipo)
			-- Trocar bloco de fundamento por madeira
			minetest.set_node(pos, {name="default:cobble"})
			-- Atualizar banco de dados da vila
			minetest.after(0.1, sunos.atualizar_bd_vila, vila)
			-- Montar ruinas
			sunos.montar_ruinas(pos, dist)
			return
		end
	end
	
	-- Verifica se a casa está muito destruida
	if sunos.contar_blocos_destruidos(pos) > sunos.var.limite_nodes_destruidos_abandonar then
		-- Exclui o arquivo da estrutura do banco de dados
		sunos.bd.remover("vila_"..vila, tipo.."_"..numero) -- Caso seja repetivel
		sunos.bd.remover("vila_"..vila, tipo) -- Caso seja unico
		
		-- Trocar bloco de fundamento por madeira
		minetest.set_node(pos, {name="default:cobble"})
	
		-- Atualizar banco de dados da vila
		minetest.after(0.1, sunos.atualizar_bd_vila, vila)
		
		-- Montar ruinas
		sunos.montar_ruinas(pos, dist)
		return
	end
	
	-- Chamadas de verificação registradas na estrutura
	if sunos.estruturas[tipo].verificar ~= nil and sunos.estruturas[tipo].verificar(pos) == false then
		-- Trocar bloco de fundamento por madeira
		minetest.set_node(pos, {name="default:cobble"})
		-- Montar ruinas
		sunos.montar_ruinas(pos, dist)
		return
	end
end

-- Atualiza as estruturas verificando se estao obstruidas
minetest.register_abm({
	nodenames = {"sunos:fundamento"},
	interval = sunos.var.tempo_verif_estruturas,
	chance = 2,
	action = function(pos)
		minetest.after(4, sunos.verificar_fundamento, {x=pos.x, y=pos.y, z=pos.z})	
	end,
})

-- Colocar fundamento
sunos.colocar_fundamento = function(pos, def)
	minetest.set_node(pos, {name="sunos:fundamento"})
	local meta = minetest.get_meta(pos)
	meta:set_string("versao", sunos.versao)
	meta:set_string("schem", def.schem) -- Nome do arquivo da esquematico da estrutura
	meta:set_string("rotat", def.rotat) -- Rotação da estrutura
	meta:set_string("vila", def.vila) -- Numero da vila
	meta:set_string("tipo", def.tipo) -- Tipo da estrutura
	meta:set_string("estrutura", def.num) -- Numero da estrutura
	meta:set_string("dist", def.dist) -- Distancia centro a borda da estrutura
	meta:set_string("nodes", sunos.contar_nodes_estruturais(pos, def.dist)) -- Nodes estruturais
end

