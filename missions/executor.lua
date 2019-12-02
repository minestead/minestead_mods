


-- start a mission
missions.start = function(pos, player)
	local mission = missions.get_current_mission(player)
	local playername = player:get_player_name()

	if mission then
		minetest.chat_send_player(playername, "A Mission is already running: '" .. mission.name .. "'")
		return
	end

	local steps = missions.get_steps(pos)
	if #steps == 0 then
		minetest.chat_send_player(playername, "Mission has no steps!")
		return
	end

	local meta = minetest.get_meta(pos)
	local pos_str = minetest.pos_to_string(pos)

	mission = {
		version = missions.CURRENT_MISSION_SPEC_VERSION,
		pos = pos_str,
		steps = steps,
		currentstep = 1,
		start = os.time(os.date("!*t")),
		time = meta:get_int("time") or 300,
		name = meta:get_string("name") or "<no name>",
		description = meta:get_string("description") or ""
	}

	missions.set_current_mission(player, mission)
end

local after_mission_hook = function(player)
	-- restore interact, no matter what
	local playername = player:get_player_name()
	local privs = minetest.get_player_privs(playername)
	privs.interact = true
	minetest.set_player_privs(playername, privs)
end

-- update the mission
-- called with below globalstep, usually ever 0.5 seconds
local update_mission = function(mission, player)

	local now = os.time(os.date("!*t"))
	local remainingTime = mission.time - (now - mission.start)
	local playername = player:get_player_name()
	local step = mission.steps[mission.currentstep]
	local abort = missions.has_aborted(playername)
	local block_pos = minetest.string_to_pos(mission.pos)
	local block_meta = minetest.get_meta(block_pos)

	if not step then
		-- no more steps
		minetest.chat_send_player(playername, "Mission completed: '" .. mission.name .. "'")
		missions.set_current_mission(player, nil)
		missions.show_banner(player, "Mission completed", mission.name)

		-- increment counter
		block_meta:set_int("successcount", block_meta:get_int("successcount") + 1)

		after_mission_hook(player)
		return
	end

	local spec = missions.get_step_spec_by_type(step.type)

	missions.hud_update(player, mission)

	local success = false
	local failed = false

	local on_success = function()
		success = true
	end

	local on_failed = function(msg)
		failed = true
		minetest.chat_send_player(playername, "Mission failed: " .. msg)
		missions.set_current_mission(player, nil)
		missions.hud_update_status(player, "")
		if spec.on_step_exit then
			spec.on_step_exit({
				step=step,
				player=player
			})
		end

		-- increment counter
		block_meta:set_int("failcount", block_meta:get_int("failcount") + 1)
		after_mission_hook(player)
	end

	if abort then
		-- invoke failed
		on_failed("aborted")
		return
	end

	if remainingTime <= 0 then
		on_failed("timed out")
		return
	end


	if not step.initialized then
		if spec.on_step_enter then
			spec.on_step_enter({
				player = player,
				step = step,
				on_success = on_success,
				on_failed = on_failed,
				block_meta = block_meta,
				block_pos = block_pos
			})
		end
		step.initialized = true
	end

	if failed then
		return
	end

	if not success then
		if spec.on_step_interval then
			spec.on_step_interval({
				player=player,
				step=step,
				on_success=on_success,
				on_failed=on_failed
			})
		end
	end

	if failed then
		return
	end


	if spec.get_status then
		local status = spec.get_status({
			player=player,
			step=step
		})
		missions.hud_update_status(player, status)
	else
		missions.hud_update_status(player, "")
	end


	if success then
		mission.currentstep = mission.currentstep + 1
		if spec.on_step_exit then
			spec.on_step_exit({
				step=step,
				player=player
			})
		end
		return
	end
end

-- mission persist job
local persistTimer = 0
minetest.register_globalstep(function(dtime)
	persistTimer = persistTimer + dtime;
	if persistTimer >= 5 then
		local players = minetest.get_connected_players()
		for i,player in ipairs(players) do
			local mission = missions.get_current_mission(player)
			missions.persist_mission(player, mission)
		end

		persistTimer = 0
	end
end)

-- mission update step
local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime;
	if timer >= 0.5 then
		local players = minetest.get_connected_players()
		for i,player in ipairs(players) do
			local mission = missions.get_current_mission(player)

			if mission then
				update_mission(mission, player)
			else
				missions.hud_update(player, nil)
			end
		end

		timer = 0
	end
end)
