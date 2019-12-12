

missions.register_step({

	type = "chestreward",
	name = "Reward from chest",

	create = function()
		return {stack="", pos=nil}
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


		local meta = minetest.get_meta(stepdata.pos)
		local inv = meta:get_inventory()

		local removeStack = ItemStack(stepdata.stack)

		local chest_owner = missions.get_owner_from_pos(stepdata.pos)

		if chest_owner and chest_owner ~= "" then
			-- check if the chest is owned by the same player as the mission
			local mission_owner = missions.get_owner_from_pos(pos)

			if mission_owner ~= chest_owner then
				return {
					success=false,
					failed=true,
					msg="Chest does not belong to the owner of the mission: " .. chest_owner ..
						" chest-location: " .. stepdata.pos.x .. "/" .. stepdata.pos.y .. "/" .. stepdata.pos.z
				}
			end
		end

		if inv:contains_item("main", removeStack) then
			return {success=true}
		else
			return {
				success=false,
				failed=true,
				msg="Chest does not contain the items: " .. stepdata.stack ..
					" chest-location: " .. stepdata.pos.x .. "/" .. stepdata.pos.y .. "/" .. stepdata.pos.z
			}
		end
	end,

	allow_inv_stack_put = function(listname, index, stack)
		-- allow position wand on pos 1 of main inv
		if listname == "main" then
			if index == 2 and stack:get_name() == "missions:wand_chest" then
				return true
			end

			if index == 1 then
				return true
			end
		end

		return false
	end,

	edit_formspec = function(ctx)
		local pos = ctx.pos
		local inv = ctx.inv
		local stepdata = ctx.step.data

		inv:set_stack("main", 1, ItemStack(stepdata.stack))

		local name = ""

		if stepdata.pos then
			local distance = vector.distance(pos, stepdata.pos)
			name = name .. "Position(" .. stepdata.pos.x .. "/" ..
				stepdata.pos.y .. "/" .. stepdata.pos.z ..") " ..
				"Distance: " .. math.floor(distance) .. " m"
		end

		local formspec = "size[8,8;]" ..
			"label[0,0;Give items from chest]" ..

			"label[0,1;Items]" ..
			"list[nodemeta:" .. pos.x .. "," .. pos.y .. "," .. pos.z .. ";main;2,1;1,1;0]" ..

			"label[3,1;Target]" ..
			"list[nodemeta:" .. pos.x .. "," .. pos.y .. "," .. pos.z .. ";main;4,1;1,1;1]" ..

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
				stepdata.stack = stack:to_string()
			end

			stack = inv:get_stack("main", 2)

			if not stack:is_empty() then
				local meta = stack:get_meta()
				local pos = minetest.string_to_pos(meta:get_string("pos"))

				stepdata.pos = pos
			end

			ctx.show_mission()
		end
	end,

	on_step_enter = function(ctx)
		local stepdata = ctx.step.data
		local player = ctx.player

		local meta = minetest.get_meta(stepdata.pos)
		local inv = meta:get_inventory()

		local removeStack = ItemStack(stepdata.stack)

		if inv:contains_item("main", removeStack) then
			removeStack = inv:remove_item("main", removeStack)
			local player_inv = player:get_inventory()
			player_inv:add_item("main", removeStack)
			ctx.on_success()
		else
			ctx.on_failed("Items not available in chest: " .. stepdata.stack)
		end

	end

})


