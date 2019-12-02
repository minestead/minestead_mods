
local FORMNAME = "mission_block_stepeditor"

missions.form.missionblock_stepeditor = function(pos, node, player)

	local selected_step = missions.get_selected_list_item(player)
	local steps = missions.get_steps(pos)

	-- steps list
	local steps_list = "textlist[0,1;5,6;steps;"
	for i,step in ipairs(steps) do
		steps_list = steps_list .. i .. ": " .. minetest.formspec_escape(step.name)
		if i < #steps then
			steps_list = steps_list .. ","
		end
	end
	steps_list = steps_list .. ";" .. selected_step .. "]";


	local formspec = "size[8,8;]" ..
		--left
		"label[0,0;Mission editor]" ..
		"button[5.5,1;2,1;add;Add]" ..
		"button[5.5,2;2,1;edit;Edit]" ..
		"button[5.5,3;2,1;up;Up]" ..
		"button[5.5,4;2,1;down;Down]" ..
		"button[5.5,5;2,1;remove;Remove]" ..
		steps_list ..
		"button_exit[0,7;8,1;save;Save and validate]" ..
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

	if fields.add then
		missions.form.newstep(pos, node, player)
		return true
	end

	if fields.remove then
		local steps = missions.get_steps(pos)
		local selected_step = missions.get_selected_list_item(player)
		local last_step = selected_step == #steps
		table.remove(steps, selected_step)
		missions.set_steps(pos, steps)

		missions.form.missionblock_stepeditor(pos, node, player)
		if last_step then
			missions.set_selected_list_item(player, math.max(selected_step - 1, 1))
		end
		return true
	end

	if fields.edit then
		local stepnumber = missions.get_selected_list_item(player)
		local steps = missions.get_steps(pos)

		local step = steps[stepnumber]

		if step then
			local stepdata = step.data
			missions.show_step_editor(pos, node, player, stepnumber, step, stepdata)
		end
	end

	if fields.up then
		local steps = missions.get_steps(pos)
		local selected_step = missions.get_selected_list_item(player)
		if selected_step > 1 then
			local tmp = steps[selected_step-1]
			steps[selected_step-1] = steps[selected_step]
			steps[selected_step] = tmp
			missions.set_steps(pos, steps)
			missions.set_selected_list_item(player, selected_step - 1)
		end

		missions.form.missionblock_stepeditor(pos, node, player)
	end

	if fields.down then
		local steps = missions.get_steps(pos)
		local selected_step = missions.get_selected_list_item(player)
		if selected_step < #steps then
			local tmp = steps[selected_step+1]
			steps[selected_step+1] = steps[selected_step]
			steps[selected_step] = tmp
			missions.set_steps(pos, steps)
			missions.set_selected_list_item(player, selected_step + 1)
		end

		missions.form.missionblock_stepeditor(pos, node, player)
	end

	if fields.steps then
		parts = fields.steps:split(":")
		if parts[1] == "CHG" then
			local selected_step = tonumber(parts[2])
			missions.set_selected_list_item(player, selected_step)
		end
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

