dofile(minetest.get_modpath("checkpoints") .. DIR_DELIM .. "checkpoints_common.lua")
dofile(minetest.get_modpath("checkpoints") .. DIR_DELIM .. "start_indicator.lua")

minetest.register_craft({
	output = 'checkpoints' .. ":start",
	recipe = {
		{"", "default:steel_ingot", ""},
		{"", "default:copper_ingot", ""},
		{"", "default:copper_ingot", ""},
	},
})

function checkpoints.set_start_info(pos)
    local meta = minetest.get_meta(pos)
    local racelaps = meta:get_int("race_laps")
    local current_lap = meta:get_int("current_lap")
    local infotext = "Start\nrace laps: " ..
                        tostring(racelaps) .. "\n"

    if current_lap <= racelaps then
        infotext = infotext .. "current lap: " .. tostring(current_lap) .. "\n"
    else
        infotext = infotext .. "Race Finished!!!!!\n"
    end

    local race_positions = meta:get_string("race_positions")
    local race_positions = minetest.deserialize(race_positions)
    for i, position in ipairs(race_positions) do
        if position ~= "" then
            infotext = infotext .. tostring(i) .. " - " .. position .. "\n"
        end
    end

    meta:set_string("infotext", infotext )

    local msg_target = meta:get_string("target")
    if msg_target then
        msg_target = minetest.deserialize(msg_target)
        if msg_target then
            local target = checkpoints.getAbsoluteTargetPos(pos, msg_target)
            local r_meta = minetest.get_meta(target)
            r_meta:set_string("text", infotext )
            r_meta:set_string("infotext", infotext )
        end
    end

end

-- initial data
function checkpoints.start_race(pos, player)
    local meta = minetest.get_meta(pos)
    checkpoints.set_race_id(pos, player)

    --display start counter
    local counter_pos = meta:get_string("counterpos")
    if counter_pos then
        counter_pos = minetest.deserialize(counter_pos)
        if counter_pos then
            local pos_display = checkpoints.getAbsoluteTargetPos(pos, counter_pos)
            checkpoints.call_start_indicator(pos_display)
        end
    end
end

-- race_id
function checkpoints.set_race_id(pos, player)
    local hour = minetest.env:get_timeofday() * 24
    local new_race_id = tostring(hour^5)
    local meta = minetest.get_meta(pos)

    checkpoints.running_race = false

    meta:set_string("race_id", new_race_id)
    if player then
        minetest.chat_send_player(player, 'New race Id: ' .. new_race_id )
    end

    local race_positions = { "", "", "", "", "", "", "", "", "", "" }
    meta:set_string("race_positions", minetest.serialize(race_positions))
    meta:set_int("current_lap", 1)
    checkpoints.set_start_info(pos)

    minetest.sound_play("05_cursor1", {
        to_player = player,
        --pos = pos,
        --max_hear_distance = checkpoints.radius,
        gain = 1.0,
        fade = 0.0,
        pitch = 1.0,
    })
end

function checkpoints.end_race(pos, meta, player, player_grid_pos)
    --the race is over to you
    minetest.chat_send_player(player, 'Race finished!!!!!')
    minetest.chat_send_player(player, 'You finished in position ' .. player_grid_pos .. ".")

    if player_grid_pos == 1 then
        --display the flag!!!!
        local counter_pos = meta:get_string("counterpos")
        if counter_pos then
            counter_pos = minetest.deserialize(counter_pos)
            if counter_pos then
                local pos_display = checkpoints.getAbsoluteTargetPos(pos, counter_pos)
                minetest.add_entity(pos_display, "checkpoints:lap_end_ent")
            end
        end
    end
end

-- start logo
minetest.register_node("checkpoints:start", {
	description = "Start Logo" .. " (" .. "USE for player check" .. ")",
	tiles = {"start_logo.png"},
	wield_image = "start_logo.png",
	inventory_image = "start_logo.png",
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
        checkpoints.updateStartFormSpecDefaults (pos, "", 10, 0, 1, 0, 0, 1, 0)

		local meta = minetest.get_meta(pos)

        local point_name = "start"
        meta:set_string("curr_checkpoint_name", point_name)
        meta:set_int("race_laps", 10)
        meta:set_string("infotext", point_name .. " - race laps: 10")

        local target = vector.new()
        target.y = 1
        meta:set_string("target", minetest.serialize(target))
        meta:set_string("counterpos", minetest.serialize(target))

        checkpoints.set_race_id(pos, nil)
	end,

	on_receive_fields = function(pos, formname, fields, sender)
		--print("Checkpoint at "..minetest.pos_to_string(pos).." got "..dump(fields))
        local meta = minetest.get_meta(pos)
	    local player_name = sender:get_player_name()
	    if minetest.is_protected(pos, player_name) then
		    minetest.record_protection_violation(pos, player_name)
		    return
	    end

        if fields.update then
            local last_checkpoint_name = fields.last_checkpoint_name
            local race_laps = fields.race_laps

            if last_checkpoint_name then
		        if string.len(last_checkpoint_name) > 512 then
			        minetest.chat_send_player(player_name, S("Text too long for current checkpoint identification"))
			        return
		        end

		        minetest.log("action", (player_name or "") .. " wrote \"" ..
			        last_checkpoint_name .. "\" as checkpoint before to start position at " .. minetest.pos_to_string(pos))
                if last_checkpoint_name ~= '' then
		            meta:set_string("last_checkpoint_name", last_checkpoint_name)
                end
            end

            if race_laps then
                race_laps = tonumber(race_laps)
                if race_laps then --if not nil
                    race_laps = math.floor(race_laps)
                    meta:set_int("race_laps", race_laps)
                end
            end

            minetest.chat_send_player(player_name, 'previous check: ' .. meta:get_string("last_checkpoint_name") .. ' - race laps: ' .. meta:get_int("race_laps") )

            checkpoints.set_race_id(pos, player_name)
        end

        if fields.settarget then
            local target = vector.new()
            target.x = tonumber(fields.targetx)
            target.y = tonumber(fields.targety)
            target.z = tonumber(fields.targetz)

            if target.x ~= nil and target.y ~= nil and target.z ~= nil then
                target.x = math.floor(target.x)
                target.y = math.floor(target.y)
                target.z = math.floor(target.z)
                meta:set_string("target", minetest.serialize(target))

                local msg_target = meta:get_string("target")
                if msg_target then
                    msg_target = minetest.deserialize(msg_target)
                    if msg_target then
                        local target = checkpoints.getAbsoluteTargetPos(pos, msg_target)
                        minetest.add_entity(target, "checkpoints:target")
                    end
                end

                minetest.chat_send_player(player_name, 'Message target was set to: ' .. tostring(target.x) .. ", " .. tostring(target.y) .. ", " .. tostring(target.z))
            end
        end

        if fields.setcounter then
            local counterpos = vector.new()
            counterpos.x = tonumber(fields.counttargetx)
            counterpos.y = tonumber(fields.counttargety)
            counterpos.z = tonumber(fields.counttargetz)

            if counterpos.x ~= nil and counterpos.y ~= nil and counterpos.z ~= nil then
                counterpos.x = math.floor(counterpos.x)
                counterpos.y = math.floor(counterpos.y)
                counterpos.z = math.floor(counterpos.z)
                meta:set_string("counterpos", minetest.serialize(counterpos))

                local counter_pos = meta:get_string("counterpos")
                if counter_pos then
                    counter_pos = minetest.deserialize(counter_pos)
                    if counter_pos then
                        local pos_display = checkpoints.getAbsoluteTargetPos(pos, counter_pos)
                        minetest.add_entity(pos_display, "checkpoints:target")
                    end
                end

                minetest.chat_send_player(player_name, 'Display position was set to: ' .. tostring(counterpos.x) .. ", " .. tostring(counterpos.y) .. ", " .. tostring(counterpos.z))
            end
        end

        --saves formspec defaults
        local msgTarget = minetest.deserialize(meta:get_string("target"))
        local counterTarget = minetest.deserialize(meta:get_string("counterpos"))
        checkpoints.updateStartFormSpecDefaults (pos, meta:get_string("last_checkpoint_name"), meta:get_int("race_laps"), msgTarget.x, msgTarget.y, msgTarget.z, counterTarget.x, counterTarget.y, counterTarget.z)

	end,

	after_place_node = function(pos, placer)

        local meta = minetest.get_meta(pos)
		--meta:set_string("owner", placer:get_player_name() or "")
        checkpoints.set_start_info(pos)

		local timer = minetest.get_node_timer(pos)
		timer:start(0.2)
	end,

    on_timer = function(pos)
		--minetest.chat_send_all('timer ok')
        local meta = minetest.get_meta(pos)
        if meta:get_string("infotext") == 'start' then
            -- this routine restart the race using basicmachines keypad when available.
            -- to work you need put the word "start" at fiel "text" of the keypad, and point it to the start marker
            checkpoints.start_race(pos, nil)
            local race_laps = meta:get_int("race_laps")
            checkpoints.set_start_info(pos)
        else
            --[[this variable resolves 2 problems
            first prevent running before the start
            second, prevent the race continue after a server reset or shutdown
            ]]--
            if checkpoints.running_race == true then
		        local radius_objects = minetest.get_objects_inside_radius({x = pos.x, y = pos.y, z = pos.z}, checkpoints.radius)
                
                for _, object in ipairs(radius_objects) do
                    if object then
                        local entity = object:get_luaentity()
                        if entity then
                            --local player = minetest.get_player_by_name(entity.driver_name)
                            local player = entity.driver_name
                            if player then
                                --[[reset car race data
                                when a car with another race_id pass, it's data is reset and now the car is in another race
                                ]]--
                                if entity._race_id ~= meta:get_string("race_id") then
                                    minetest.chat_send_player(player, 'Go go go!!!!')
                                    entity._last_checkpoint = meta:get_string("curr_checkpoint_name")
                                    entity._total_laps = 0
                                    entity._race_id = meta:get_string("race_id")
                                else
                                    --[[ 
                                    see the commentary of checkpoint, its the same principle
                                    ]]--
                                    if entity._last_checkpoint == meta:get_string("last_checkpoint_name") or entity._last_checkpoint == "" then
                                        entity._last_checkpoint = meta:get_string("curr_checkpoint_name")
                                        entity._total_laps = entity._total_laps + 1 --total laps increements 1 when last_checkpoint is updated

                                        if player then
                                            minetest.chat_send_player(player, 'Total laps: ' .. entity._total_laps)
                                            local race_laps = meta:get_int("race_laps")
                                            local current_lap = meta:get_int("current_lap")
                                            local player_grid_pos = 100
                                            
                                            -- for each lap, the first player update lap counter and reset race positions
                                            if entity._total_laps > current_lap - 1 and entity._total_laps <= race_laps then
                                                current_lap = entity._total_laps + 1
                                                meta:set_int("current_lap", current_lap)
                                                
                                                --[[first on new lap reset the race podium
                                                we can watch the race position by each lap reseting it when the first change the curent lap
                                                ]]--
                                                local race_positions = { player, "", "", "", "", "", "", "", "", "" }
                                                meta:set_string("race_positions", minetest.serialize(race_positions))
                                                player_grid_pos = 1
                                            end

                                            --save podium position on first empty
                                            local race_positions = meta:get_string("race_positions")
                                            if race_positions and entity._total_laps == current_lap - 1 then
                                                local race_positions = minetest.deserialize(race_positions)
                                                for i, position in ipairs(race_positions) do
                                                    if position == player then
                                                        break
                                                    end
                                                    if position == "" then
                                                        race_positions[i] = player
                                                        player_grid_pos = i
                                                        meta:set_string("race_positions", minetest.serialize(race_positions))
                                                        break
                                                    end
                                                end
                                                --minetest.chat_send_player(player, meta:get_string("race_positions"))
                                            end

                                            -- finish race
                                            if entity._total_laps >= race_laps and entity._total_laps < race_laps + 1 then
                                                --the race is over to you
                                                checkpoints.end_race(pos, meta, player, player_grid_pos)
                                            end
                                            -- end finish

                                            checkpoints.set_start_info(pos)

                                        end
                                        minetest.sound_play("04_start5", {
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
                end
            end

        end

        local timer = minetest.get_node_timer(pos)
        timer:start(0.2)

	end,

	on_punch = function(pos, node, puncher)
        --[[
            here a way to create an event. Someone must punch the start checkpoint with the status_restarter. So it will update the race_id.
            When a car pass this checkpoint it's race_id will be reset to current race
        ]]--
        local itmstck=puncher:get_wielded_item()
        local item_name = ""
        if itmstck then item_name = itmstck:get_name() end
        if item_name == "checkpoints:status_restarter" then
            checkpoints.start_race(pos, puncher:get_player_name())
        else
            minetest.add_entity(pos, "checkpoints:display")

            --to prevent checkpoint lost by an error on server, restart it
            local timer = minetest.get_node_timer(pos)
            timer:start(0.2)
        end
	end,
})
