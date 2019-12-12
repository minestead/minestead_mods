
local counter = {} -- playername -> count

missions.register_step({

	type = "simplebuild",
	name = "Place nodes",

	create = function()
		return {count=99}
	end,


	get_status = function(ctx)
		local player = ctx.player
		local stepdata = ctx.step.data

		local name = player:get_player_name()
		local current_count = counter[name] or 0
		local rest = stepdata.count - (current_count - stepdata.start)
		return "Place " .. rest .. " nodes"
	end,

	edit_formspec = function(ctx)
		local stepdata = ctx.step.data

		local formspec = "size[8,8;]" ..
			"label[0,0;Place any nodes]" ..
			"field[0,2;8,1;count;Count;" .. stepdata.count ..  "]" ..
			"button[0,7;8,1;save;Save]"

		return formspec;
	end,

	update = function(ctx)
		local fields = ctx.fields
		local stepdata = ctx.step.data

		if fields.count then
			local count = tonumber(fields.count)
			if count and count > 0 then
				stepdata.count = count
			end
		end

		if fields.save then
			ctx.show_mission()
		end
	end,

	on_step_enter = function(ctx)
		local player = ctx.player
		local stepdata = ctx.step.data

		local name = player:get_player_name()
		stepdata.start = counter[name] or 0
	end,

	on_step_interval = function(ctx)
		local player = ctx.player
		local stepdata = ctx.step.data

		local name = player:get_player_name()
		local current_count = counter[name] or 0
		if current_count - stepdata.start >= stepdata.count then
			ctx.on_success()
		end
	end,

	on_step_exit = function(ctx)
	end


})

minetest.register_on_placenode(function(pos, newnode, player, oldnode, itemstack)
	if player ~= nil and player:is_player() then
		local name = player:get_player_name()
		local count = counter[name] or 0

		count = count + 1
		counter[name] = count
	end
end)

minetest.register_on_dignode(function(pos, oldnode, digger)
	if digger ~= nil and digger:is_player() then
		local name = digger:get_player_name()
		local count = counter[name] or 0

		count = count - 1
		counter[name] = math.max(count, 0)
	end
end)


