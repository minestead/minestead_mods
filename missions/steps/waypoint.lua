
local hud = {} -- playername -> id

missions.register_step({

	type = "waypoint",
	name = "Waypoint",

	create = function()
		return {pos=nil, name="", radius=3, visible=1, description=""}
	end,

	get_status = function(ctx)
		return ctx.step.data.description
	end,

	validate = function(ctx)
		local stepdata = ctx.step.data

		if stepdata.pos == nil then
			return {
				success=false,
				failed=true,
				msg="No position defined"
			}
		else
			return {success=true}
		end
	end,

	allow_inv_stack_put = function(listname, index, stack)
		-- allow position wand on pos 1 of main inv
		if listname == "main" and index == 1 and stack:get_name() == "missions:wand_position" then
			return true
		end

		return false
	end,

	edit_formspec = function(ctx)
		local stepdata = ctx.step.data
		local pos = ctx.pos

		local name = ""

		if stepdata.pos then
			local distance = vector.distance(pos, stepdata.pos)
			name = name .. "Position(" .. stepdata.pos.x .. "/" ..
				stepdata.pos.y .. "/" .. stepdata.pos.z ..") " ..
				"Distance: " .. math.floor(distance) .. " m"
		end

		if stepdata.name then
			name = name .. " with name '" .. stepdata.name .. "'"
		end

		local visibleText

		if stepdata.visible == 1 then
			visibleText = "Waypoint: Visible"
		else
			visibleText = "Waypoint: Hidden"
		end

		local formspec = "size[8,10;]" ..
			"label[0,0;Walk to (Step #" .. ctx.stepnumber .. ")]" ..

			"list[nodemeta:" .. pos.x .. "," .. pos.y .. "," .. pos.z .. ";main;0,1;1,1;0]" ..

			"label[0,2;" .. name .. "]" ..

			"field[0.2,3;8,1;description;Description;" .. stepdata.description .. "]" ..
			"field[0.2,4;4,1;radius;Radius;" .. stepdata.radius .. "]" ..

			"button[4,5;4,1;togglevisible;" .. visibleText .. "]" ..

			"list[current_player;main;0,6;8,4;]" ..

			"button[0,5;4,1;save;Save]"

		return formspec;
	end,

	update = function(ctx)
		local fields = ctx.fields
		local inv = ctx.inv
		local stepdata = ctx.step.data

		if fields.radius then
			local radius = tonumber(fields.radius)
			if radius and radius > 0 then
				stepdata.radius = radius
			end
		end

		if fields.togglevisible then
			if stepdata.visible == 1 then
				stepdata.visible = 0
			else
				stepdata.visible = 1
			end

			ctx.show_editor()
		end

		if fields.description then
			stepdata.description = fields.description
		end

		if fields.save then
			local stack = inv:get_stack("main", 1)

			if not stack:is_empty() then
				local meta = stack:get_meta()
				local pos = minetest.string_to_pos(meta:get_string("pos"))
				local name = meta:get_string("name")

				stepdata.pos = pos
				stepdata.name = name
			end

			ctx.show_mission()
		end
	end,

	on_step_enter = function(ctx)
		local player = ctx.player
		local stepdata = ctx.step.data

		if stepdata.visible == 1 then
			hud[player:get_player_name()] = player:hud_add({
				hud_elem_type = "waypoint",
				name = "Mission-waypoint: " .. stepdata.name,
				text = "m",
				number = 0xFF0000,
				world_pos = stepdata.pos
			})
		end
	end,

	on_step_interval = function(ctx)
		local player = ctx.player
		local stepdata = ctx.step.data
		local pos = player:get_pos()

		local distance = vector.distance(pos, stepdata.pos)
		if distance < stepdata.radius then
			ctx.on_success()
		end
	end,

	on_step_exit = function(ctx)
		local player = ctx.player

		local idx = hud[player:get_player_name()]
		if idx then
			player:hud_remove(idx)
			hud[player:get_player_name()] = nil
		end
	end


})


