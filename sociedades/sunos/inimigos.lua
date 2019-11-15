--[[
	Mod Sunos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Métodos para controle de inimigos
  ]]

-- Tradução de strings
local S = sunos.S

-- Tabela de inimigos de vilas
local inimigos = {}

-- Remover um inimigo da lista de inimigos de uma vila
sunos.atualizar_inimigo = function(vila, name, tempo)
	
	-- Verifica se ainda existe a tabela
	if not inimigos[vila] then return end 
	
	-- Atualiza o tempo que ja passou e reinicia o loop para passar mais tempo
	if inimigos[vila][name] > tempo then 
		inimigos[vila][name] = inimigos[vila][name] - 60
		-- reinicia o loop
		minetest.after(60, sunos.atualizar_inimigo, vila, name, 60)
		return
	end
	
	-- Encerra o processo pois ja passou o tempo
	inimigos[vila][name] = nil
	
	-- verifica se tem algum outro nome na lista para destrui-la
	for i,v in pairs(inimigos[vila]) do
		-- Achou então encerra por aqui		
		return
	end
	
	-- Se chegar até aqui, elimina a tabela
	inimigos[vila] = nil
	
end

-- Armazenar novo inimigo de uma vila (retorna false caso ja esteja como inimigo, o tempo é reajustado nesse caso)
sunos.novo_inimigo = function(vila, name)
	if not vila or not name then return end
	
	-- Serializa index de tabelas pois não sao ordenadas
	vila = tostring(vila)
	name = tostring(name) -- um jogador pode ter nome baseado em numeros
	
	-- Verifica se a vila está na tabela
	if not inimigos[vila] then inimigos[vila] = {} end
	
	-- Apenas restaura o tempo que resta caso ja esteja em loop
	if inimigos[vila][name] then
		-- repor tempo
		inimigos[vila][name] = sunos.var.tempo_inimigo
		return false
	end 
	
	-- Armazena nome do inimigo e o tempo que deve ser mantido como inimigo
	inimigos[vila][name] = sunos.var.tempo_inimigo
	
	-- Envia mensagem de aviso
	minetest.chat_send_player(name, S("Acabaste de se tornar inimigo de uma vila dos Sunos"))
	
	-- Conta um tempo para tentar remover o inimigo
	minetest.after(60, sunos.atualizar_inimigo, vila, name, 60)
	return true
	
end

-- Verificar se um jogador é um inimigo de uma vila
sunos.verif_inimigo = function(vila, name)
	if not vila or not name then return end
	
	if inimigos[tostring(vila)] and inimigos[tostring(vila)][tostring(name)] then return true end
	
	return false
end

