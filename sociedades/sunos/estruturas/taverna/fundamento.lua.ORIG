--[[
	Mod Sunos para Minetest
	Copyright (C) 2018 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Fundamento de taverna
  ]]

-- Tradução de strings
local S = sunos.S

-- Verificar se pode construir e envontra vila 
local verificar_terreno = function(pos, dist)
	
	-- Encontrar vila ativa
	local vila = sunos.encontrar_vila(pos, 25)
	if not vila then
		return S("Nenhuma vila habitavel encontrada")
	end
	
	-- Verificar taverna ja existente
	if sunos.bd.verif("vila_"..vila, "taverna") == true then
		return S("Ja existe @1 nessa vila", S("Taverna"))
	end
	
	-- Verificar população minima
	if sunos.verif_nivel(sunos.bd.pegar("vila_"..vila, "pop_total"), sunos.estruturas.taverna.var.niveis) == 0 then
		return S("A vila precisa ter ao menos @1 habitantes", sunos.estruturas.taverna.var.niveis[1])
	end
	
	-- Variaveis auxiliares
	local largura = (dist*2)+1
	
	-- Verifica se está muito perto de outras estruturas atravez de areas protegidas
	for x=-1, 1 do
		for y=-1, 1 do
			for z=-1, 1 do
				if minetest.is_protected({x=pos.x+((dist+2)*x), y=pos.y+((8*y)+7), z=pos.z+((dist+2)*z)}, name) == true then
					return S("Muito perto de estruturas protegidas")
				end
			end
		end
	end
	
	local r = sunos.verificar_area_para_fundamento(pos, dist)
	if r ~= true then
		return r
	end
	
	return true, vila
end

-- Fundamento de taverna
minetest.register_node("sunos:fundamento_taverna", {
	description = S("Fundamento de taverna dos Sunos"),
	tiles = {"default_tree_top.png^sunos_fundamento.png", "default_tree_top.png", "default_tree.png"},
	inventory_image = "sunos_fundamento_fundo_inv.png^sunos_fundamento_taverna_inv.png",
	wield_image = "sunos_fundamento_estrutura_namao.png^sunos_fundamento_taverna_namao.png",
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 1},
	sounds = default.node_sound_wood_defaults(),
	stack_max = 1,
	
	-- Colocar uma taverna
	on_place = function(itemstack, placer, pointed_thing)
		
		local pos = pointed_thing.under
		
		local r, vila = verificar_terreno(pos, 5)
		
		if r == true then
			
			-- Coloca rua em torno
			sunos.colocar_rua(pos, 5)
			
			-- Colocar fundamento step
			sunos.colocar_fundamento_step(pos, {
				tipo = "taverna",
				dist = 5,
				vila = vila,
				dias = 2,
				schem = "nivel_1",
				rotat = sunos.pegar_rotat(),
			})
			
			-- Retorna mensagem de montagem concluida
			minetest.chat_send_player(placer:get_player_name(), S("Construindo @1", S("Taverna")))
			itemstack:take_item()
			return itemstack
			
		else
			-- Mostra area necessaria
			sunos.criar_caixa_de_area(pos, 5+1)
			-- Retorna mensagem de falha
			minetest.chat_send_player(placer:get_player_name(), r)
			return itemstack
		end
	end,
})
