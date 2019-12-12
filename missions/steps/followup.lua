
missions.register_step({

	type = "followup",
	name = "Next mission",

	create = function()
		return {pos=nil}
	end,

	validate = function(ctx)
		local pos = ctx.pos
		local stepdata = ctx.step.data

		if stepdata.pos == nil then
			return {
				success=false,
				failed=true,
				msg="No position defined"
			}
		end

		local node = minetest.get_node(pos)
		if node and node.name == "missions:mission" then
			--TODO: recursive validation
			--TODO: prevent inifinite loop
			return {success=true}
		end

		return {
			success=false,
			failed=true,
			msg="No follow-up mission found on " ..
				" location: " .. stepdata.pos.x .. "/" .. stepdata.pos.y .. "/" .. stepdata.pos.z
		}
	end,

	allow_inv_stack_put = function(listname, index, stack)
		-- allow position wand on pos 1 of main inv
		if listname == "main" then
			if index == 1 and stack:get_name() == "missions:wand_mission" then
				return true
			end
		end

		return false
	end,

	edit_formspec = function(ctx)
		local pos = ctx.pos
		local stepdata = ctx.step.data

		local name = ""

		if stepdata.pos then
			local distance = vector.distance(pos, stepdata.pos)
			name = name .. "Position(" .. stepdata.pos.x .. "/" ..
				stepdata.pos.y .. "/" .. stepdata.pos.z ..") " ..
				"Distance: " .. math.floor(distance) .. " m"
		end

		local formspec = "size[8,8;]" ..
			"label[0,0;Follow-up mission]" ..
			"label[3,1;Target]" ..
			"list[nodemeta:" .. pos.x .. "," .. pos.y .. "," .. pos.z .. ";main;4,1;1,1;0]" ..
			"label[0,2;" .. name .. "]" ..
			"list[current_player;main;0,6;8,1;]" ..
			"button[0,7;8,1;save;Save]"

		return formspec;
	end,

	update = function(ctx)
		local fields = ctx.fields
		local inv = ctx.inv
		local stepdata = ctx.step.data

		if fields.save then
			local stack = inv:get_stack("main", 1)

			if not stack:is_empty() then
				local meta = stack:get_meta()
				local pos = minetest.string_to_pos(meta:get_string("pos"))

				stepdata.pos = pos
			end

			ctx.show_mission()
		end
	end,

	on_step_enter = function(ctx)
		--local stepdata = ctx.step.data
		--local player = ctx.player

		--TODO
		ctx.on_success()
	end

})


