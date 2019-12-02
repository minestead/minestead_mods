

missions.register_step({

	type = "givereward",
	name = "Reward (give)",

	privs = { give=true },

	create = function()
		return {stack=""}
	end,

	edit_formspec = function(ctx)
		local inv = ctx.inv
		local pos = ctx.pos
		local stepdata = ctx.step.data

		inv:set_stack("main", 1, ItemStack(stepdata.stack))

		local formspec = "size[8,8;]" ..
			"label[0,0;Reward items (give)]" ..

			"label[0,1;Items]" ..
			"list[nodemeta:" .. pos.x .. "," .. pos.y .. "," .. pos.z .. ";main;2,1;1,1;0]" ..

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

			ctx.show_mission()
		end
	end,

	on_step_enter = function(ctx)
		local player = ctx.player
		local stepdata = ctx.step.data

		local player_inv = player:get_inventory()
		player_inv:add_item("main", ItemStack(stepdata.stack))
		ctx.on_success()
	end

})


