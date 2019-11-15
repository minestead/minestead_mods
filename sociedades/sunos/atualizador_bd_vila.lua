--[[
	Mod Sunos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Gerenciador de Vilas
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

-- Diretorio do mundo
local worldpath = minetest.get_worldpath()

-- Atualizar banco de dados da vila
sunos.atualizar_bd_vila = function(vila)
	sunos.checkvar(vila, "Nenhuma vila fornecida para atualizar o banco de dados")
	
	-- Pegar lista de tabelas da vila
	local list = minetest.get_dir_list(worldpath.."/sunos/vila_"..vila)
	if not list then
		minetest.log("error", "[Sunos] Banco de dados da vila inexistente (em sunos.atualizar_bd_vila)")
		return false
	end
	
	-- Verifica versão do mod sunos para essa vila
	if sunos.bd.verif("vila_"..vila, "versao") ~= true then return false end
	if sunos.verif_comp(sunos.bd.pegar("vila_"..vila, "versao")) == false then return false end
	
	-- População total
	local pop_total = 0
	
	-- Analiza os arquivos do banco de dados
	for _,arq in ipairs(list) do
		
		-- Separa os termos de cada arquivo a ser analizado
		local v = string.split(arq, "_")
		
		-- Verifica se o arquivo é de uma estrutura registrada
		if sunos.estruturas[v[1]] then
			
			-- Status do registro (para caso seja deletado durante a verificação)
			local stdata = true
			
			-- Pegar dados do arquivo
			local reg = sunos.bd.pegar("vila_"..vila, arq)
			
			-- Verifica se o fundamento ainda existe
			do
				-- Pega o node
				local n = pegar_node(reg.estrutura.pos)
				
				-- Verifica se é um fundamento
				if n.name ~= "sunos:fundamento" then
					
					stdata = false
					
					-- Elimina o arquivo
					sunos.bd.remover("vila_"..vila, arq)
				
				end
			end
			
			-- Verificar metadados
			if stdata == true then
			
				-- Pega matadados
				local meta = minetest.get_meta(reg.estrutura.pos)
				
				-- Verificar numero da vila
				if meta:get_string("vila") == "" or tonumber(meta:get_string("vila")) ~= tonumber(vila) then
				
					stdata = false
					
					-- Elimina o arquivo
					sunos.bd.remover("vila_"..vila, arq)
				
				end
			end
			
			-- Caso o arquivo seja de uma estrutura com população
			if stdata == true and sunos.estruturas[v[1]].pop then
				
				-- Verifica se ja atingiu limite populacional
				if pop_total >= sunos.var.max_pop then
					-- Remove registro e manda verificar estrutura para ser destruida
					sunos.bd.remover("vila_"..vila, arq)
					sunos.verificar_fundamento(reg.estrutura.pos)
				else
					-- Contabiliza a população
					pop_total = pop_total + reg.pop	
					-- Corrije limite para evitar que o total oficial ultrapasse o limite maximo permitido
					if pop_total > sunos.var.max_pop then
						pop_total = sunos.var.max_pop
					end
				end
			end
			
		end
	end
	
	-- Salva a população atual
	sunos.bd.salvar("vila_"..vila, "pop_total", pop_total)
	
	-- Verificar se a vila deve ser apagado do banco de dados
	if pop_total == 0 -- Sem população
		and sunos.bd.verif("vila_"..vila, "comunal") ~= true -- Sem casa comunal
	then
		
		sunos.bd.drop_tb("vila_"..vila)
	end
	
	return true
end



