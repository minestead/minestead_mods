--[[
	Mod Sunos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Verificar população de uma vila
  ]]

-- Verificar se uma vila japassou do limite de população
--[[
	Retorna nulo caso ocorra um erro durante a verificação
	Retorna 'true' caso ainda nao tenha atingido o limite 
  ]]
sunos.verif_pop_vila = function(vila)
	if not vila or not tonumber(vila) then return end
	vila = tonumber(vila)
	
	-- Verificar se ainda existe um banco de dados da vila
	if sunos.bd.verif("vila_"..vila, "pop_total") == false then
		return
	end
	
	-- Verifica se ja passou do limite
	if tonumber(sunos.bd.pegar("vila_"..vila, "pop_total")) > sunos.var.max_pop then
		return false
	else
		return true
	end
end
