--[[
	Lib Tror para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Operações de troca de itens
  ]]

local tror = {}

-- Verificar viabilidade de uma troca
tror.verificar = function(player, item_rem, item_add)

	if not player or not item_add or not item_rem then
		minetest.log("error", "[Tror] Faltou dados em (em tror.verificar)")
		return false
	end
	
	local inv = player:get_inventory()
	
	-- Verificar jogador
	if not inv:contains_item("main", item_rem) then
		return 1 -- Jogador nao pode pagar
	elseif not inv:room_for_item("main", item_add) then
		return 2 -- Jogador com inventario lotado
	end
	
	return true
end

-- Realizar uma troca entre com um jogador
tror.trocar = function(player, item_rem, item_add, msg)
	
	if not player or not item_add or not item_rem then
		minetest.log("error", "[Tror] Faltou dados em (em tror.trocar)")
		return false
	end
	
	
	local v = tror.verificar(player, item_rem, item_add)
	if v ~= true then
		if v == 1 then
			if msg and msg.ins then
				minetest.chat_send_player(player:get_player_name(), msg.ins)
			end
			return 1
		elseif v == 2 then
			if msg and msg.lot then
				minetest.chat_send_player(player:get_player_name(), msg.lot)
			end
			return 2
		else
			minetest.log("error", "[Tror] Resultado inesperado em tror.trocar (v = "..dump(v)..")")
			return false
		end
	end
	
	local inv = player:get_inventory()
	
	-- Retirar itens do inventario
	local i = string.split(item_rem, " ")
	local n = i[2] or 1
	i = i[1]
	for r=1, tonumber(n) do -- 1 eh o tanto que quero tirar
		inv:remove_item("main", i) -- tira 1 por vez
	end
	
	inv:add_item("main", item_add)
	
	
	if msg and msg.ok then
		minetest.chat_send_player(player:get_player_name(), msg.ok)
	end
	return true
	
end

-- Realizar uma troca com um jogador
--[[
	Retorna false caso o jogador nao tenha os itens requisitados
	e dropa no local todos os itens que não couberem no inventario
  ]]
tror.trocar_plus = function(player, item_rem, item_add)
	
	if not player then
		minetest.log("error", "[Tror] Faltou player (em tror.trocar_plus)")
		return false
	end
	
	if item_rem and not item_rem[1] then
		minetest.log("error", "[Tror] argumento item_rem invalido (em tror.trocar_plus)")
		return false
	end
	
	if item_add and not item_add[1] then
		minetest.log("error", "[Tror] argumento item_add invalido (em tror.trocar_plus)")
		return false
	end
	
	local pos = player:getpos()
	
	local inv = player:get_inventory()
	
	-- Verificar se o jogador possui os itens requisitados
	local possui = true
	for _,item in ipairs(item_rem) do
		if not inv:contains_item("main", item) then
			possui = false
			break
		end
	end
	
	-- Retorna false por jogador não ter os itens requisitados
	if possui == false then
		return false
	end
	
	-- Retira itens do jogador
	for _,item in ipairs(item_rem) do
		local i = string.split(item, " ")
		local n = i[2] or 1
		i = i[1]
		for r=1, tonumber(n) do -- 1 eh o tanto que quero tirar
			inv:remove_item("main", i) -- tira 1 por vez
		end
	end
	
	-- Transfere todos os itens ao jogador (e dropa os que nao couberem no inventario)
	local dropou = false
	for _,item in ipairs(item_add) do
		if inv:room_for_item("main", item) then
			inv:add_item("main", item)
		else
			dropou = true
			minetest.env:add_item({x = pos.x + math.random() * 2 - 1, y = pos.y+1, z = pos.z + math.random() * 2 - 1}, item)
		end
	end
	
	return true
	
end

return tror
