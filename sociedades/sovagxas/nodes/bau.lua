--[[
	Mod Sovagxas para Minetest
	Copyright (C) 2018 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Bau
  ]]

-- Tradução de strings
local S = sovagxas.S

-- sorteia 4 itens em uma tabela ordenada
local amplitude_de_valores = 0
for _, col in ipairs(sovagxas.itens_bau) do
	col[5] = amplitude_de_valores + 1
	amplitude_de_valores = amplitude_de_valores + col[4]
	col[6] = amplitude_de_valores
end
local sortear_bau = function()
	local sorteado = math.random(1, amplitude_de_valores)
	local itens = {}
	for _, col in ipairs(sovagxas.itens_bau) do
		if col[5] <= sorteado and sorteado <= col[6] then 
			itens[1] = {col[1], math.random(col[2], col[3])}
			break
		end
	end
	local sorteado = math.random(1, amplitude_de_valores)
	for _, col in ipairs(sovagxas.itens_bau) do
		if col[5] <= sorteado and sorteado <= col[6] then 
			itens[2] = {col[1], math.random(col[2], col[3])}
			break
		end
	end
	local sorteado = math.random(1, amplitude_de_valores)
	for _, col in ipairs(sovagxas.itens_bau) do
		if col[5] <= sorteado and sorteado <= col[6] then 
			itens[3] = {col[1], math.random(col[2], col[3])}
			break
		end
	end
	local sorteado = math.random(1, amplitude_de_valores)
	for _, col in ipairs(sovagxas.itens_bau) do
		if col[5] <= sorteado and sorteado <= col[6] then 
			itens[4] = {col[1], math.random(col[2], col[3])}
			break
		end
	end
	return itens
end

-- Bau dos Sovagxas
minetest.register_node("sovagxas:bau", {
	description = S("Bau Sovagxa"),
	tiles = {
		"default_chest_top.png^sovagxas_bau_cima.png", 
		"default_chest_top.png^sovagxas_bau_cima.png", 
		"default_chest_side.png^sovagxas_bau_lado.png",
		"default_chest_side.png^sovagxas_bau_lado.png", 
		"default_chest_side.png^sovagxas_bau_lado.png", 
		"default_chest_front.png^sovagxas_bau_lado.png"},
	paramtype2 = "facedir",
	groups = {choppy=2,oddly_breakable_by_hand=2,not_in_creative_inventory=1},
	legacy_facedir_simple = true,
	is_ground_content = false,
	drop = "default:chest",
	sounds = default.node_sound_wood_defaults(),
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("versao", sovagxas.versao)
		meta:set_string("itens", minetest.serialize(sortear_bau()))
		meta:set_string("data", os.date("%Y %m %d %H"))
		meta:set_string("arvore", minetest.serialize(pos))
		meta:set_string("infotext", S("Bau Sovagxa"))
		local formspec = "size[8,8.5]".. 
				default.gui_bg..
				default.gui_bg_img..
				default.gui_slots..
				"label[0,0;"..S("Bau Sovagxa").."]"..
				"list[current_player;main;0,4.25;8,1;]"..
				"list[current_player;main;0,5.5;8,3;8]"..
				default.get_hotbar_bg(0,4.25)
		local itens = minetest.deserialize(meta:get_string("itens"))
		if itens[1] then
			formspec = formspec.."item_image_button[0,1;2,2;"..itens[1][1]..";item1;"..itens[1][2].."]"
		end
		if itens[2] then
			formspec = formspec.."item_image_button[2,1;2,2;"..itens[2][1]..";item2;"..itens[2][2].."]"
		end
		if itens[3] then
			formspec = formspec.."item_image_button[4,1;2,2;"..itens[3][1]..";item3;"..itens[3][2].."]"
		end
		if itens[4] then
			formspec = formspec.."item_image_button[6,1;2,2;"..itens[4][1]..";item4;"..itens[4][2].."]"
		end
		meta:set_string("formspec", formspec)
	end,
	on_receive_fields = function(pos, formname, fields, sender)
		local meta = minetest.get_meta(pos)
		local player_inv = sender:get_inventory()
		local itens = minetest.deserialize(meta:get_string("itens"))
		
		if fields.item1 and itens[1] ~= false then
			if player_inv:room_for_item("main", itens[1][1].." "..itens[1][2]) then
				player_inv:add_item("main", itens[1][1].." "..itens[1][2])
				itens[1] = false
			else
				minetest.chat_send_player(sender:get_player_name(), S("Inventario lotado. Esvazie um pouco"))
			end
		elseif fields.item2 and itens[2] ~= false then
			if player_inv:room_for_item("main", itens[2][1].." "..itens[2][2]) then
				player_inv:add_item("main", itens[2][1].." "..itens[2][2])
				itens[2] = false
			else
				minetest.chat_send_player(sender:get_player_name(), S("Inventario lotado. Esvazie um pouco"))
			end
		elseif fields.item3 and itens[3] ~= false  then
			if player_inv:room_for_item("main", itens[3][1].." "..itens[3][2]) then
				player_inv:add_item("main", itens[3][1].." "..itens[3][2])
				itens[3] = false
			else
				minetest.chat_send_player(sender:get_player_name(), S("Inventario lotado. Esvazie um pouco"))
			end
		elseif fields.item4 and itens[4] ~= false then
			if player_inv:room_for_item("main", itens[4][1].." "..itens[4][2]) then
				player_inv:add_item("main", itens[4][1].." "..itens[4][2])
				itens[4] = false
			else
				minetest.chat_send_player(sender:get_player_name(), S("Inventario lotado. Esvazie um pouco"))
			end
		end
		meta:set_string("itens", minetest.serialize(itens))
		
		local formspec = "size[8,8.5]".. 
				default.gui_bg..
				default.gui_bg_img..
				default.gui_slots..
				"label[0,0;"..S("Bau Sovagxa").."]"..
				"list[current_player;main;0,4.25;8,1;]"..
				"list[current_player;main;0,5.5;8,3;8]"..
				default.get_hotbar_bg(0,4.25)
		local itens = minetest.deserialize(meta:get_string("itens"))
		if itens[1] then
			formspec = formspec.."item_image_button[0,1;2,2;"..itens[1][1]..";item1;"..itens[1][2].."]"
		end
		if itens[2] then
			formspec = formspec.."item_image_button[2,1;2,2;"..itens[2][1]..";item2;"..itens[2][2].."]"
		end
		if itens[3] then
			formspec = formspec.."item_image_button[4,1;2,2;"..itens[3][1]..";item3;"..itens[3][2].."]"
		end
		if itens[4] then
			formspec = formspec.."item_image_button[6,1;2,2;"..itens[4][1]..";item4;"..itens[4][2].."]"
		end
		if itens[1] == false and itens[2] == false and itens[3] == false and itens[4] == false then 
			--formspec = formspec.."label[1.5,1.5;]"
			formspec = formspec.."textarea[1.2,1.5;6.1,2;;"..S("Bau vazio no momento").."\n"..S("Aguarde ate que um sovagxa coloque algo dentro")..";]"
		end
		meta:set_string("formspec", formspec)
	end,
})

-- atualizar baus periodicamente
minetest.register_abm({
	label = "Atualizar itens",
	nodenames = {"sovagxas:bau"},
	interval = 600,
	chance = 1,
	action = function(pos)
		local meta = minetest.get_meta(pos)
		
		-- Verificar se arvore ainda existe
		local p_arv = minetest.deserialize(meta:get_string("arvore"))
		local folhas = minetest.find_nodes_in_area(
			{x=p_arv.x-8, y=p_arv.y-3, z=p_arv.z-8}, 
			{x=p_arv.x+8, y=p_arv.y+3, z=p_arv.z+8}, {"sovagxas:jungleleaves"})
			
		if table.maxn(folhas) < 800 then
			local node = minetest.get_node(pos)
			minetest.set_node(pos, {name="default:chest", param2 = node.param2})
			return
		end
		
		-- Renovar itens
		if meta:get_string("data") ~= os.date("%Y %m %d %H") then
			meta:set_string("itens", minetest.serialize(sortear_bau()))
			meta:set_string("data", os.date("%Y %m %d %H"))
		end
		
	end,
})
