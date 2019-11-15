--[[
	Mod Sunos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Métodos para RollBack de nodes
	
	Esse método apenas retorna as coordenadas dos ultimos nodes colocados/tirados 
	pelo jogador de forma a danificar a estrutura.
	
	Retorna uma tabela ordenada com coordenadas
  ]]

-- Caso o sistema de rollback padrão esteja ativo, utiliza ele
if minetest.setting_getbool("enable_rollback_recording") == true then
 	
 	-- Método para retornar tabela com coordenadas
	sunos.rollback = function(name, pos) 
		
		-- Pega os dados de RollBack de nodes proximos ao jogador
		local rb = minetest.rollback_get_node_actions(
			pos, -- pos
			20+sunos.var.tempo_atualizar_jogadores_perto, -- range
			sunos.var.tempo_atualizar_jogadores_perto, -- seconds
			30 -- limit (de nodes?)
		)
		
		local p = {}
		for _,d in ipairs(rb) do
			-- Verifica se foi considerado um dano ou modificação danosa
			-- Portas
			if d.newnode 
				and d.oldnode 
				and (d.newnode.name == "doors:door_wood_a" or d.newnode.name == "doors:door_wood_b") 
			then
				-- Não adiciona
			else
				table.insert(p, d.pos)
			end
		end
		
		return p
		
	end 

-- Caso o sistema de rollback padrão esteja inativo, cria-se um alternativo
else

	-- Cria a lista de rollbacks global
	sunos.rollback_list = {}
	
	-- Função para remover jogador da lista de rollback
	sunos.rollback_remove = function(name)
		sunos.rollback_list[name] = nil
	end
	
	-- Insere os jogadores na lista ao entrarem no servidor
	minetest.register_on_joinplayer(function(player)
		if not player then return end
		sunos.rollback_list[player:get_player_name()] = {}
	end)
	
	-- Remove jogadores da lista após um tempo sem retornarem
	minetest.register_on_leaveplayer(function(player)
		if not player then return end
		minetest.after(sunos.var.tempo_atualizar_jogadores_perto, sunos.rollback_remove, player:get_player_name())
	end)
	
	-- Contabiliza coordenada de blocos tirados
	minetest.register_on_dignode(function(pos, oldnode, digger)
		if not digger then return end
		local name = digger:get_player_name()
		if not sunos.rollback_list[name] then return end
		-- Insere a nova coordenada
		table.insert(sunos.rollback_list[name], pos)
		-- Remove o excesso
		if table.maxn(sunos.rollback_list[name]) > 5 then
			table.remove(sunos.rollback_list[name], 1)
		end
	end)
	
	-- Contabiliza coordenada de blocos colocados
	minetest.register_on_placenode(function(pos, newnode, placer)
		if not placer then return end
		local name = placer:get_player_name()
		if not sunos.rollback_list[name] then return end
		-- Insere a nova coordenada
		table.insert(sunos.rollback_list[name], pos)
		-- Remove o excesso
		if table.maxn(sunos.rollback_list[name]) > 5 then
			table.remove(sunos.rollback_list[name], 1)
		end
	end)
	
	-- Método para retornar tabela com coordenadas
	sunos.rollback = function(name)
		return sunos.rollback_list[name]
	end
	
end
