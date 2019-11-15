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

-- Fundamento dos sunos
--[[
	Esse é o node de fundamento das estruturas dos sunos
]]
minetest.register_node("sunos:fundamento", {
	description = S("Fundamento dos Sunos"),
	tiles = {"default_tree_top.png^sunos_fundamento.png", "default_tree_top.png", "default_tree.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 1, not_in_creative_inventory=1},
	sounds = default.node_sound_wood_defaults(),
	drop = "default:tree",
	
	-- Nao pode ser escavado/quebrado por jogadores
	on_dig = function() end,
	
	-- Clique direito para restaurar
	on_rightclick = function(pos, node, player, itemstack, pointed_thing)	
	
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
		
		sunos.atualizar_bd_vila(vila)
	end,
	
	-- Chamada de temporizador
	on_timer = function(pos, elapsed)
		local meta = minetest.get_meta(pos)
		local versao = meta:get_string("versao")
		
		-- Verificar versao antes de tudo
		if sunos.verif_comp(versao) == false then return end
		
		local tipo = meta:get_string("tipo")
		if tipo == "" or not sunos.estruturas[tipo] then return end
		
		-- Executa on_timer personalizado
		if sunos.estruturas[tipo].fund_on_timer then
			sunos.estruturas[tipo].fund_on_timer(pos, elapsed)
		end
	end,
	
	-- Impede explosão
	on_blast = function() end,
})
