dofile(minetest.get_modpath("checkpoints") .. DIR_DELIM .. "checkpoints_common.lua")

minetest.register_craft({
	output = 'checkpoints' .. ":checkpoint",
	recipe = {
		{"", "default:steel_ingot", ""},
		{"", "default:copper_ingot", ""},
		{"", "default:steel_ingot", ""},
	},
})

-- checkpoint logo
minetest.register_node("checkpoints:checkpoint", {
	description = "Checkpoint Logo" .. " (" .. "USE for player check" .. ")",
	tiles = {"checkpoint_logo.png"},
	wield_image = "checkpoint_logo.png",
	inventory_image = "checkpoint_logo.png",
	sounds = default.node_sound_stone_defaults(),
	groups = {dig_immediate = 2, unbreakable = 1},
	paramtype = "light",
	paramtype2 = "wallmounted",
	legacy_wallmounted = true,
	light_source = 4,
	drawtype = "nodebox",
	sunlight_propagates = true,
	walkable = true,
	node_box = {
		type = "wallmounted",
		wall_top    = {-0.5, 0.4375, -0.5, 0.5, 0.5, 0.5},
		wall_bottom = {-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5},
		wall_side   = {-0.5, -0.5, -0.5, -0.4375, 0.5, 0.5},
	},
	selection_box = {type = "wallmounted"},

	on_construct = function(pos)
        -- first saves formspec defaults
        checkpoints.updateCheckpointFormSpec(pos, "", "")
	end,

	on_receive_fields = function(pos, formname, fields, sender)
		--print("Checkpoint at "..minetest.pos_to_string(pos).." got "..dump(fields))
		local player_name = sender:get_player_name()
		if minetest.is_protected(pos, player_name) then
			minetest.record_protection_violation(pos, player_name)
			return
		end
		local curr_checkpoint_name = fields.curr_checkpoint_name
        local last_checkpoint_name = fields.last_checkpoint_name
        local meta = minetest.get_meta(pos)
        
        if fields.update then
            if curr_checkpoint_name then
		        if string.len(curr_checkpoint_name) > 512 then
			        minetest.chat_send_player(player_name, S("Text too long for current checkpoint identification"))
			        return
		        end

                if curr_checkpoint_name ~= '' then
		            minetest.log("action", (player_name or "") .. " wrote \"" ..
			            curr_checkpoint_name .. "\" to checkpoint at " .. minetest.pos_to_string(pos))
		            
		            meta:set_string("curr_checkpoint_name", curr_checkpoint_name)

		            if #curr_checkpoint_name > 0 then
			            meta:set_string("infotext", curr_checkpoint_name)
		            else
			            meta:set_string("infotext", '')
		            end
                end
            end

            if last_checkpoint_name then
		        if string.len(last_checkpoint_name) > 512 then
			        minetest.chat_send_player(player_name, ("Text too long for current checkpoint identification"))
			        return
		        end

                if last_checkpoint_name ~= '' then
		            minetest.log("action", (player_name or "") .. " wrote \"" ..
			            last_checkpoint_name .. "\" as checkpoint before to current checkpoint at " .. minetest.pos_to_string(pos))
		            
		            meta:set_string("last_checkpoint_name", last_checkpoint_name)
                end
            end

            local prev_check = meta:get_string("last_checkpoint_name")
            local curr_name = meta:get_string("curr_checkpoint_name")

            checkpoints.updateCheckpointFormSpec(pos, curr_name, prev_check)

            minetest.chat_send_player(player_name, 'name: ' .. curr_name .. ' - previous check: ' .. prev_check )
        end

	end,

	after_place_node = function(pos, placer)

        local meta = minetest.get_meta(pos)
		--meta:set_string("owner", placer:get_player_name() or "")
		meta:set_string("infotext", "Checkpoint")

		local timer = minetest.get_node_timer(pos)
		timer:start(0.2)
	end,

    on_timer = function(pos)
		--minetest.chat_send_all('timer ok')
		local radius_objects = minetest.get_objects_inside_radius({x = pos.x, y = pos.y, z = pos.z}, checkpoints.radius)
        local meta = minetest.get_meta(pos)
        
        for _, object in ipairs(radius_objects) do
            if object then
                local pos = object:get_pos()
                local entity = object:get_luaentity()
                if entity then
                    --local player = minetest.get_player_by_name(entity.driver_name)
                    local player = entity.driver_name
                    if player then
                        --[[ 
                        here is the core of the checkpoints! Each one have a last and current pos references
                        the current pos is it's own name. The last pos is the name of the checkpoint that the car is comming from
                        of. For example, here is the "check_03", the car would be came from "check_02". So if the player try to
                        cheat using a shorcut from "check_01" directly to "check_03", it will do not update the car reference and
                        then it will have to go back to the "check_02" then go to "check_03".
                        ]]--
                        if entity._last_checkpoint == meta:get_string("last_checkpoint_name") then
                            entity._last_checkpoint = meta:get_string("curr_checkpoint_name")

                            --minetest.chat_send_player(player, 'CHECKPOINT!')
                            minetest.sound_play("05_cursor1", {
                                to_player = player,
                                --pos = pos,
                                --max_hear_distance = checkpoints.radius,
                                gain = 1.0,
                                fade = 0.0,
                                pitch = 1.0,
                            })
                        end
                    end
                end
            end
        end
        local timer = minetest.get_node_timer(pos)
        timer:start(0.2)

	end,

	on_punch = function(pos, node, puncher)
		minetest.add_entity(pos, "checkpoints:display")

        --to prevent checkpoint lost by an error on server, restart it
	    local timer = minetest.get_node_timer(pos)
	    timer:start(0.2)
	end,
})


