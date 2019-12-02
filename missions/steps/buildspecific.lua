
local HUD_POSITION = {x = missions.hud.posx, y = missions.hud.posy }
local HUD_ALIGNMENT = {x = 1, y = 0}

local stacks = {} -- playername -> stack_str
local hud = {} -- playername -> {}

missions.register_step({

	type = "buildspecific",
	name = "Place specific nodes",

	create = function()
		return {stack="default:stone 99"}
	end,

	allow_inv_stack_put = function(listname, index, stack)
		-- allow position wand on pos 1 of main inv
		if listname == "main" and index == 1 and minetest.registered_nodes[stack:get_name()] then
			-- stack is a node
			return true
		end

		return false
	end,

	get_status = function(ctx)
		local player = ctx.player
		local name = player:get_player_name()

		local stack = ItemStack(stacks[name] or "")

		local hud_data = hud[name];
		player:hud_change(hud_data.counter, "text", stack:get_count() .. "x")

		return "Place " .. stack:get_count() .. " " .. stack:get_name()
	end,

	edit_formspec = function(ctx)
		local stepdata = ctx.step.data
		local pos = ctx.pos
		local stack = ItemStack(stepdata.stack)

		ctx.inv:set_stack("main", 1, stack)

		local formspec = "size[8,8;]" ..
			"label[0,0;Place specific nodes]" ..

			"label[0,1;Node:]" ..
			"list[nodemeta:" .. pos.x .. "," .. pos.y .. "," .. pos.z .. ";main;3,1;1,1;0]" ..

			"list[current_player;main;0,2;8,4;]" ..

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
		local stack = ItemStack(stepdata.stack)
		local name = player:get_player_name()

		stacks[name] = stack:to_string()

		local hud_data = {}
		hud[player:get_player_name()] = hud_data;

		hud_data.counter = player:hud_add({
			hud_elem_type = "text",
			position = HUD_POSITION,
			offset = {x = 0,   y = 140},
			text = "",
			alignment = HUD_ALIGNMENT,
			scale = {x = 100, y = 100},
			number = 0x00FF00
		})

		hud_data.image = player:hud_add({
			hud_elem_type = "image",
			position = HUD_POSITION,
			offset = {x = 32,   y = 140},
			text = missions.get_image(stack:get_name()),
			alignment = HUD_ALIGNMENT,
			scale = {x = 1, y = 1},
		})
	end,

	on_step_interval = function(ctx)
		local player = ctx.player
		local name = player:get_player_name()

		local stack = ItemStack(stacks[name] or "")

		if stack:get_count() == 0 then
			ctx.on_success()
		end
	end,

	on_step_exit = function(ctx)
		local player = ctx.player
		local name = player:get_player_name()
		local hud_data = hud[name]

		if hud_data and hud_data.image then
			player:hud_remove(hud_data.image)
		end

		if hud_data and hud_data.counter then
			player:hud_remove(hud_data.counter)
		end

		hud[name] = nil
		stacks[name] = nil
	end


})

minetest.register_on_placenode(function(pos, newnode, player, oldnode, itemstack)
	if player ~= nil and player:is_player() then
		local name = player:get_player_name()
		local stack = ItemStack(stacks[name] or "")

		if newnode.name == stack:get_name() then
			-- node name matches
			stack:take_item(1)
		end

		stacks[name] = stack:to_string()
	end
end)

minetest.register_on_dignode(function(pos, oldnode, digger)
	if digger ~= nil and digger:is_player() then
		local name = digger:get_player_name()
		if not stacks[name] then return end

		local stack = ItemStack(stacks[name])

		if oldnode.name == stack:get_name() then
			-- node name matches
			stack:set_count(stack:get_count() + 1)
		end

		stacks[name] = stack:to_string()
	end
end)


