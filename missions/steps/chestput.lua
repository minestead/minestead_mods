
local HUD_POSITION = {x = missions.hud.posx, y = missions.hud.posy }
local HUD_ALIGNMENT = {x = 1, y = 0}


local hud = {} -- playerName -> {}
local remainingItems = {} -- playerName -> ItemStack


missions.register_step({

	type = "chestput",
	name = "Put in chest",

	create = function()
		return {stack="", pos=nil, name="", visible=1}
	end,

	get_status = function(ctx)
		local player = ctx.player

		local str = remainingItems[player:get_player_name()]
		if str then
			local stack = ItemStack(str)
			return "Put " .. stack:get_count() .. " x " .. stack:get_name() .. " into the chest"
		else
			return ""
		end
	end,

	validate = function(ctx)
		local meta = minetest.get_meta(ctx.pos)
		local stepdata = ctx.step.data

		local inv = meta:get_inventory()

		local removeStack = ItemStack(stepdata.stack)

		if stepdata.pos == nil then
			return {
				success=false,
				failed=true,
				msg="No position defined"
			}
		end

		if inv:room_for_item("main", removeStack) then
			return {success=true}
		else
			return {
				success=false,
				failed=true,
				msg="Chest has no space for items: " .. stepdata.stack ..
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
		local stepdata = ctx.step.data
		local pos = ctx.pos

		ctx.inv:set_stack("main", 1, ItemStack(stepdata.stack))

		local name = ""

		if stepdata.pos then
			local distance = vector.distance(ctx.pos, stepdata.pos)
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

		local formspec = "size[8,8;]" ..
			"label[0,0;Put items in chest]" ..

			"label[0,1;Items]" ..
			"list[nodemeta:" .. pos.x .. "," .. pos.y .. "," .. pos.z .. ";main;2,1;1,1;0]" ..

			"label[3,1;Target]" ..
			"list[nodemeta:" .. pos.x .. "," .. pos.y .. "," .. pos.z .. ";main;4,1;1,1;1]" ..

			"label[0,2;" .. name .. "]" ..

			"button_exit[0,5;8,1;togglevisible;" .. visibleText .. "]" ..

			"list[current_player;main;0,6;8,1;]" ..
			"button[0,7;8,1;save;Save]"

		return formspec;
	end,

	update = function(ctx)

		local fields = ctx.fields
		local inv = ctx.inv
		local stepdata = ctx.step.data

		if fields.togglevisible then
			if stepdata.visible == 1 then
				stepdata.visible = 0
			else
				stepdata.visible = 1
			end

			ctx.show_editor()
		end

		if fields.save then
			local stack = inv:get_stack("main", 1)

			if not stack:is_empty() then
				stepdata.stack = stack:to_string()
			end

			stack = inv:get_stack("main", 2)

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

		local stepdata = ctx.step.data
		local player = ctx.player

		-- set stack
		remainingItems[player:get_player_name()] = stepdata.stack
		local stack =ItemStack(stepdata.stack)

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

		-- set waypoint, if enabled
		if stepdata.visible == 1 then
			hud_data.target = player:hud_add({
				hud_elem_type = "waypoint",
				name = "Chest: " .. stepdata.name,
				text = "m",
				number = 0xFF0000,
				world_pos = stepdata.pos
			})
		end
	end,

	on_step_interval = function(ctx)
		local player = ctx.player

		local str = remainingItems[player:get_player_name()]
		if str then
			local stack = ItemStack(str)

			if stack:get_count() == 0 then
				ctx.on_success()
			end

			local hud_data = hud[player:get_player_name()]
			player:hud_change(hud_data.counter, "text", stack:get_count() .. "x")
		else
			ctx.on_success()
		end
	end,

	on_step_exit = function(ctx)
		local player = ctx.player

		remainingItems[player:get_player_name()] = ""
		local hud_data = hud[player:get_player_name()]

		if hud_data and hud_data.image then
			player:hud_remove(hud_data.image)
		end

		if hud_data and hud_data.counter then
			player:hud_remove(hud_data.counter)
		end

		if hud_data and hud_data.target then
			player:hud_remove(hud_data.target)
		end

		hud[player:get_player_name()] = nil
	end


})

local intercept_chest = function(name)
	local def = minetest.registered_nodes[name]

	if def ~= nil then
		local delegate_put = def.on_metadata_inventory_put
		local delegate_take = def.on_metadata_inventory_take

		def.on_metadata_inventory_put = function(pos, listname, index, stack, player)
			if player and player:is_player() then
				local remStack = ItemStack(remainingItems[player:get_player_name()])

				if remStack:get_name() == stack:get_name() then
					local count = remStack:get_count() - stack:get_count()
					if count < 0 then count = 0 end

					remStack:set_count(count)
					remainingItems[player:get_player_name()] = remStack:to_string()
				end

				--print("Put Stack: " .. stack:get_name())
			end

			--delegate
			delegate_put(pos, listname, index, stack, player)
		end

		def.on_metadata_inventory_take = function(pos, listname, index, stack, player)
			if player and player:is_player() then
				local remStack = ItemStack(remainingItems[player:get_player_name()])

				if remStack:get_name() == stack:get_name() then
					local count = remStack:get_count() + stack:get_count()
					if count > remStack: get_stack_max() then count = remStack:get_stack_max() end

					remStack:set_count(count)
					remainingItems[player:get_player_name()] = remStack:to_string()
				end
				--print("Take Stack: " .. stack:get_name())
			end

			--delegate
			delegate_take(pos, listname, index, stack, player)
		end
	else
		print("Definition not found: " .. name)
	end
end

local has_more_chests_mod = minetest.get_modpath("more_chests")

intercept_chest("default:chest")
intercept_chest("default:chest_open")

if has_more_chests_mod then
	intercept_chest("more_chests:dropbox")
end
-- TODO: technic-chests


