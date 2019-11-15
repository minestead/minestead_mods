--[[
	Mod Sunos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Métodos para verificação de defesa de uma estrutura
	
  ]]

-- Função para redirecionamento
sunos.verificar_defesa = function(pos)
	if not pos then return end
	
	-- Verificar tipo de estrutura
	local tipo = minetest.get_meta(pos):get_string("tipo")
	if tipo == "" then 
		return false 
	end
	
	-- Retorna sempre defendido
	return true
	
	--[[
		Método em desuso
		Ainda não foi pensado a maneira correta de verificar defesas das estruturas
		
		
	-- Verifica se existe um método se o fundamento se mostra defendido
	if sunos.estruturas[tipo] and sunos.estruturas[tipo].defendido -- Não tem metodo para verificar se esta defendido?
		and sunos.estruturas[tipo].defendido(pos) == true -- Não está defendido?
	then 
		-- Protegido
		return true
	else
		-- Desprotegido
		return false 
		
	end
	]]
	
end
