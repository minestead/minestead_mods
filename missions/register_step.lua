
missions.steps = {}

missions.register_step = function(spec)
	table.insert(missions.steps, spec)
end

missions.get_step_spec_by_type = function(type)
	for i,spec in ipairs(missions.steps) do
		if type == spec.type then
			-- step spec found
			return spec
		end
	end
end

local FORMNAME = "mission_block_editstep"

missions.show_step_editor = function(pos, node, player, stepnumber, step, stepdata)

	-- clear inv before showing step editor
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	for i=1,inv:get_size("main") do
		inv:set_stack("main", i, ItemStack(""))
	end

	for i,spec in ipairs(missions.steps) do
		if spec.type == step.type then
			if not spec.edit_formspec then
				missions.form.missionblock_stepeditor(pos, node, player)
				return
			end

			local formspec = spec.edit_formspec({
				pos=pos,
				node=node,
				player=player,
				stepnumber=stepnumber,
				step=step,
				stepdata=stepdata,
				inv=inv
			})

			minetest.show_formspec(player:get_player_name(),
				FORMNAME .. ";" .. minetest.pos_to_string(pos) .. ";" .. stepnumber .. ";" .. spec.type,
				formspec .. missions.FORMBG
			)
		end
	end
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	local parts = formname:split(";")
	local name = parts[1]
	if name ~= FORMNAME then
		return
	end

	local pos = minetest.string_to_pos(parts[2])
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local node = minetest.get_node(pos)
	local stepnumber = tonumber(parts[3])
	local spectype = parts[4]

	if not missions.check_owner(pos, player) then
		return
	end

	local steps = missions.get_steps(pos)

	local step = steps[stepnumber]
	local stepdata = step.data

	for i,spec in ipairs(missions.steps) do
		if spec.type == spectype then
			local show_editor = function()
				missions.show_step_editor(pos, node, player, stepnumber, step, stepdata)
			end

			local show_mission = function()
				missions.form.missionblock_stepeditor(pos, node, player)
			end

			spec.update({
				fields=fields,
				player=player,
				step=step,
				show_editor=show_editor,
				show_mission=show_mission,
				inv=inv
			})

			-- write back data
			missions.set_steps(pos, steps)
		end
	end

end)



