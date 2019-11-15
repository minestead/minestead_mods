--[[
	Mod Sunos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Nodes para criar fundamentos
  ]]

-- Tradução de strings
local S = sunos.S

-- Verificar terreno antes de construir casa
local verificar_terreno = function(pos, dist)

	-- Encontrar vila ativa
	local vila = sunos.encontrar_vila(pos, 25)
	if not vila then
		return S("Nenhuma vila habitavel encontrada")
	end
	
	-- Verifica se está muito perto de outras estruturas atravez de areas protegidas
	for x=-1, 1 do
		for y=-1, 1 do
			for z=-1, 1 do
				if minetest.is_protected({x=pos.x+((dist+2)*x), y=pos.y+((8*y)+7), z=pos.z+((dist+2)*z)}, "") == true then
					return S("Muito perto de estruturas protegidas")
				end
			end
		end
	end
	
	-- Verifica limite de população
	if tonumber(sunos.bd.pegar("vila_"..vila, "pop_total")) >= sunos.var.max_pop then
		return S("Limite de @1 habitantes da vila ja foi atingido", sunos.var.max_pop)
	end
	
	-- Verificações de area
	do
		local r = sunos.verificar_area_para_fundamento(pos, dist)
		if r ~= true then
			return r
		end
	end
	
	return true, vila
end

-- Fundamento de casa pequena
minetest.register_node("sunos:fundamento_casa_pequena", {
	description = S("Fundamento Suno de Casa Pequena"),
	tiles = {"default_tree_top.png^sunos_fundamento.png", "default_tree_top.png", "default_tree.png"},
	inventory_image = "sunos_fundamento_fundo_inv.png^sunos_fundamento_casa_inv.png^sunos_fundamento_casa_pequena_inv.png",
	wield_image = "sunos_fundamento_estrutura_namao.png^sunos_fundamento_casa_namao.png",
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 1},
	sounds = default.node_sound_wood_defaults(),
	stack_max = 1,
	
	-- Colocar uma casa
	on_place = function(itemstack, placer, pointed_thing)
		
		local pos = pointed_thing.under
		
		local r, vila = verificar_terreno(pos, 2)
		
		if r == true then
		
			-- Coloca rua em torno
			sunos.colocar_rua(pos, 2)
			
			local schem = sunos.pegar_arquivo(((2*2)+1), "casa")
			
			-- Construir estrutura
			-- Colocar fundamento step
			sunos.colocar_fundamento_step(pos, {
				tipo = "casa",
				dist = 2,
				vila = vila,
				dias = sunos.estruturas.casa.var.tb_tempo_construindo_casa[tostring(2*2+1)],
				schem = schem,
				rotat = sunos.pegar_rotat(),
			})
			
			-- Retorna mensagem de montagem concluida
			minetest.chat_send_player(placer:get_player_name(), S("Construindo @1", S("Casa Pequena")))
			itemstack:take_item()
			return itemstack
			
		else
			-- Mostra area a ser usada
			sunos.criar_caixa_de_area(pos, 2+1)
			-- Retorna mensagem de falha
			minetest.chat_send_player(placer:get_player_name(), r)
			return itemstack
		end
	end,
})

-- Fundamento de casa mediana
minetest.register_node("sunos:fundamento_casa_mediana", {
	description = S("Fundamento Suno de Casa Mediana"),
	tiles = {"default_tree_top.png^sunos_fundamento.png", "default_tree_top.png", "default_tree.png"},
	inventory_image = "sunos_fundamento_fundo_inv.png^sunos_fundamento_casa_inv.png^sunos_fundamento_casa_mediana_inv.png",
	wield_image = "sunos_fundamento_estrutura_namao.png^sunos_fundamento_casa_namao.png",
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 1},
	sounds = default.node_sound_wood_defaults(),
	stack_max = 1,
	
	-- Colocar uma casa
	on_place = function(itemstack, placer, pointed_thing)
		
		local pos = pointed_thing.under
		local r, vila = verificar_terreno(pos, 3)
		
		if r == true then
		
			-- Coloca rua em torno
			sunos.colocar_rua(pos, 3)
			
			local schem = sunos.pegar_arquivo(((2*3)+1), "casa")
			
			-- Construir estrutura
			-- Colocar fundamento step
			sunos.colocar_fundamento_step(pos, {
				tipo = "casa",
				dist = 3,
				vila = vila,
				dias = sunos.estruturas.casa.var.tb_tempo_construindo_casa[tostring(3*2+1)],
				schem = schem,
				rotat = sunos.pegar_rotat(),
			})
			
			-- Retorna mensagem de montagem concluida
			minetest.chat_send_player(placer:get_player_name(), S("Construindo @1", S("Casa Mediana")))
			itemstack:take_item()
			return itemstack
			
		else
			-- Mostra area a ser usada
			sunos.criar_caixa_de_area(pos, 3+1)
			-- Retorna mensagem de falha
			minetest.chat_send_player(placer:get_player_name(), r)
			return itemstack
		end
	end,
})



-- Fundamento de casa grande
minetest.register_node("sunos:fundamento_casa_grande", {
	description = S("Fundamento Suno de Casa Grande"),
	tiles = {"default_tree_top.png^sunos_fundamento.png", "default_tree_top.png", "default_tree.png"},
	inventory_image = "sunos_fundamento_fundo_inv.png^sunos_fundamento_casa_inv.png^sunos_fundamento_casa_grande_inv.png",
	wield_image = "sunos_fundamento_estrutura_namao.png^sunos_fundamento_casa_namao.png",
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 1},
	sounds = default.node_sound_wood_defaults(),
	stack_max = 1,
	
	-- Colocar uma casa
	on_place = function(itemstack, placer, pointed_thing)
		
		local pos = pointed_thing.under
		
		local r, vila = verificar_terreno(pos, 4)
		
		if r == true then
			
			-- Coloca rua em torno
			sunos.colocar_rua(pos, 4)
			
			local schem = sunos.pegar_arquivo((2*4)+1, "casa")
			
			-- Construir estrutura
			-- Colocar fundamento step
			sunos.colocar_fundamento_step(pos, {
				tipo = "casa",
				dist = 4,
				vila = vila,
				dias = sunos.estruturas.casa.var.tb_tempo_construindo_casa[tostring(4*2+1)],
				schem = schem,
				rotat = sunos.pegar_rotat(),
			})
			
			-- Retorna mensagem de montagem concluida
			minetest.chat_send_player(placer:get_player_name(), S("Construindo @1", S("Casa Grande")))
			itemstack:take_item()
			return itemstack
			
		else
			-- Mostra area a ser usada
			sunos.criar_caixa_de_area(pos, 4+1)
			-- Retorna mensagem de falha
			minetest.chat_send_player(placer:get_player_name(), r)
			return itemstack
		end
	end,
})


