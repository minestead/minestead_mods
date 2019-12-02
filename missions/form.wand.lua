
local FORMNAME = "mission_wand_name"

missions.can_create_wand = function(player, pos)
	return true
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	local parts = formname:split(";")
	local name = parts[1]
	if name ~= FORMNAME then
		return
	end

	local pos = minetest.string_to_pos(parts[2])
	local posStr = minetest.pos_to_string(pos)
	local node = minetest.get_node(pos)

	if not fields.name then
		return
	end

	if not missions.can_create_wand(player, pos) then
		return
	end

	local inv = player:get_inventory()
	local type = "Position"
	local stack = ItemStack("missions:wand_position")

	if node.name == "default:chest" or node.name == "default:chest_locked" or node.name == "more_chests:dropbox" then
		stack = ItemStack("missions:wand_chest")
		type = "Chest"
	end

	if node.name == "missions:mission" then
		stack = ItemStack("missions:wand_mission")
		type = "Mission"
	end

	local meta = stack:get_meta()
	meta:set_string("pos", posStr)
	meta:set_string("name", fields.name)
	meta:set_string("description", "Mission wand (" .. type .. "): " .. posStr ..
		" with name: '" .. fields.name ..
		"' and node '" .. node.name .. "'")

	if inv:contains_item("main", "missions:wand") and inv:room_for_item("main", stack) then
		inv:remove_item("main", "missions:wand")
		inv:add_item("main", stack)
	end

end)


missions.form.wand = function(pos, player)
	local formspec = "size[8,1;]" ..
		"field[0,0.5;6,1;name;Name;]" ..
		"button_exit[6,0.1;2,1;save;Save]" ..
		missions.SMALLFORMBG

	minetest.show_formspec(player:get_player_name(),
		FORMNAME .. ";" .. minetest.pos_to_string(pos),
		formspec
	)
end

