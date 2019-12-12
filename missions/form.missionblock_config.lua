
local FORMNAME = "mission_block_config"

missions.form.missionblock_config = function(pos, node, player)

	local meta = minetest.get_meta(pos)

	local name = meta:get_string("name")
	local time = meta:get_string("time")
	local description = meta:get_string("description")
	local hidden = meta:get_int("hidden")

	local hidden_str = "Hidden "
	if hidden == 0 then
		hidden_str = hidden_str .. "<False>"
	else
		hidden_str = hidden_str .. "<True>"
	end


	local formspec = "size[8,8;]" ..
		--left
		"label[0,0;Mission editor]" ..

		"field[0,1;8,1;name;Name;" .. name ..  "]" ..
		"field[0,2;8,1;time;Time (seconds);" .. time ..  "]" ..
		"textarea[0,3;8,4;description;Description;" .. description .. "]" ..

		"button_exit[4,7;4,1;save;Save]" ..
		"button[0,7;4,1;togglehidden;" .. hidden_str .. "]" ..
		missions.FORMBG

	minetest.show_formspec(player:get_player_name(),
		FORMNAME .. ";" .. minetest.pos_to_string(pos),
		formspec
	)

end



minetest.register_on_player_receive_fields(function(player, formname, fields)
	local parts = formname:split(";")
	local name = parts[1]
	if name ~= FORMNAME then
		return
	end

	local pos = minetest.string_to_pos(parts[2])
	local meta = minetest.get_meta(pos)
	local node = minetest.get_node(pos)

	if not missions.check_owner(pos, player) then
		return
	end

	if fields.name then
		meta:set_string("name", fields.name)
	end

	if fields.time then
		meta:set_string("time", fields.time)
	end

	if fields.togglehidden then
		local hidden = meta:get_int("hidden")
		if hidden == 0 then
			meta:set_int("hidden", 1)
		else
			meta:set_int("hidden", 0)
		end
		missions.form.missionblock_config(pos, node, player)
	end

	if fields.description then
		meta:set_string("description", fields.description)
	end

	if fields.save then
		local result = missions.validate_mission(pos, player)
		if result.success then
			meta:set_string("infotext", "Mission: " .. meta:get_string("name"))
			minetest.chat_send_player(player:get_player_name(), "Mission valid")
		else
			meta:set_string("infotext", "Mission: (invalid: " .. result.msg .. ")")
			minetest.chat_send_player(player:get_player_name(), "Mission invalid: " .. result.msg)
		end
	end

end)

