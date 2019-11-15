--[[
	Mod Sunos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Estrutura decorativa dos sunos
  ]]

-- Tradução de strings
local S = sunos.S

-- Caminho do diretório do mod
local modpath = minetest.get_modpath("sunos")

-- Tabela global de Decorativos (estruturas)
sunos.estruturas.decor = {}

-- Construir estrutura decorativa
--[[
	Essa função construi uma estrutura decorativa de sunos e configura o fundamento
	Retorno:
		^ true caso ocorra tudo bem
		^ string de erro caso algo de errado
	Argumentos:
		<pos> é a coordenada do fundamento da estrutura
		<dist> distancia centro a borda da nova estrutura
		<vila> OPCIONAL | é o numero da vila a qual a estrutura decorativa pertence
		<verif_area> OPCIONAL | true verificar a area antes de montar a estrutura (retorna strings dos erros)
  ]]
sunos.estruturas.decor.construir = function(pos, dist, vila, verif_area)
	-- Validar argumentos de entrada
	if pos == nil then
		minetest.log("error", "[Sunos] Tabela pos nula (sunos.estruturas.decor.construir)")
		return "Erro interno (pos nula)"
	end
	if dist == nil then
		minetest.log("error", "[Sunos] variavel dist nula (em sunos.estruturas.decor.construir)")
		return "Erro interno (tamanho de estrutura decorativa inexistente)"
	end
	
	-- Variaveis auxiliares
	local largura = (dist*2)+1
	
	-- Buscar uma vila por perto
	if not vila then
		local pos_fund_prox = minetest.find_node_near(pos, 25, {"sunos:fundamento"})
		if pos_fund_prox == nil then 
			return S("Nenhuma vila por perto")
		end
	
		-- Pegar dados da vila encontrada
		local meta_fund_prox = minetest.get_meta(pos_fund_prox)
		vila = meta_fund_prox:get_string("vila")
	
		-- Verificar se ainda existe um banco de dados da vila
		if sunos.bd.verif("vila_"..vila, "numero") == false then
			return S("Vila abandonada")
		end
	end
	
	-- Verificações de area
	if verif_area == true then
	
		-- Verifica status do terreno
		local st = sunos.verif_terreno(pos, dist)
		
		-- Problema: em cima da faixa de solo existem obstrucoes (nao esta limpo e plano)
		if st == 1 then
			return S("O local precisa estar limpo e plano em uma area de @1x@1 blocos da largura", (largura+2))
		
		-- Problema: faixa de solo (superficial) falta blocos de terra
		elseif st == 2 then
			return S("O solo precisa estar plano e gramado em uma area de @1x@1 blocos da largura", (largura+2))
		
		-- Problema: faixa de subsolo (considerando 2 faixas) falta blocos de terra
		elseif st == 3 then
			return S("O subsolo precisa estar preenchido (ao menos 2 blocos de profundidade) em uma area de @1x@1 blocos da largura", (largura+2))
		end
	end
	
	-- Criar estrutura decorativa
	sunos.montar_estrutura(pos, dist, "decor")
	
	-- Remover jogadores da area construida (evitar travar em paredes)
	sunos.ajustar_jogadores(pos)
	
	return true
end


