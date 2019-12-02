
local HUD_POSITION = {x = 0.5, y = 0.2}
local HUD_ALIGNMENT = {x = 1, y = 0}

local hud = {} -- playerName -> {}


minetest.register_on_joinplayer(function(player)
	local playername = player:get_player_name()

	local data = {}

	data.title = player:hud_add({
		hud_elem_type = "text",
		position = HUD_POSITION,
		offset = {x = 0,   y = 0},
		text = "",
		alignment = HUD_ALIGNMENT,
		scale = {x = 100, y = 100},
		number = 0xFFFFFF
	})

	data.mission = player:hud_add({
		hud_elem_type = "text",
		position = HUD_POSITION,
		offset = {x = 0,   y = 35},
		text = "",
		alignment = HUD_ALIGNMENT,
		scale = {x = 100, y = 100},
		number = 0x00FF00
	})

	data.time = player:hud_add({
		hud_elem_type = "text",
		position = HUD_POSITION,
		offset = {x = 0,   y = 70},
		text = "",
		alignment = HUD_ALIGNMENT,
		scale = {x = 100, y = 100},
		number = 0x00FF00
	})

	hud[playername] = data
end)

minetest.register_on_leaveplayer(function(player)
	local playername = player:get_player_name()
	hud[playername] = nil
end)

local format_time = function(seconds)
	local minutes = math.floor(seconds / 60)
	local secs = seconds - (minutes * 60)
	if secs < 10 then
		return minutes .. ":0" .. secs
	else
		return minutes .. ":" ..secs
	end
end

missions.hud_remove_mission = function(player, mission)
	-- remove waypoints from elapsed mission
	if mission.hud ~= nil and mission.hud.source ~= nil then
		player:hud_remove(mission.hud.source)
	end

	if mission.hud ~= nil and mission.hud.target ~= nil then
		player:hud_remove(mission.hud.target)
	end
end

-- called by executor.lua or by executor.hud.lua
missions.hud_update = function(player, playermissions)
	local playername = player:get_player_name()

	local now = os.time(os.date("!*t"))
	local data = hud[playername]
	local topMission = nil

	if data ~= nil and playermissions ~= nil then
		for i,mission in pairs(playermissions) do

			if mission.hud == nil then


				if mission.type == "transport" then
					-- add waypoint markers if new mission
					mission.hud = {}
					mission.hud.target = player:hud_add({
						hud_elem_type = "waypoint",
						name = mission.target.title .. "(Destination)",
						text = "m",
						number = 0x0000FF,
						world_pos = {x=mission.target.x, y=mission.target.y, z=mission.target.z}
					})

				end
			end


			-- top mission check
			if topMission == nil then
				topMission = mission
			else
				local remainingTime = mission.time - (now - mission.start)
				local topRemainingTime = topMission.time - (now - topMission.start)

				if remainingTime < topRemainingTime then
					topMission = mission
				end
			end

		end
	end

	if topMission ~= nil then
		-- show the first mission to time out
		local remainingTime = topMission.time - (now - topMission.start)
		player:hud_change(data.title, "text", "Missions: (1/" .. table.getn(playermissions) .. ")")
		player:hud_change(data.mission, "text", topMission.name .. " (" .. topMission.type .. ")")
		player:hud_change(data.time, "text", "" .. format_time(remainingTime))

		if remainingTime > 60 then
			player:hud_change(data.time, "number", 0x00FF00)
			player:hud_change(data.mission, "number", 0x00FF00)
		else
			player:hud_change(data.time, "number", 0xFF0000)
			player:hud_change(data.mission, "number", 0xFF0000)
		end
	else
		-- no missions running
		player:hud_change(data.title, "text", "")
		player:hud_change(data.mission, "text", "")
		player:hud_change(data.time, "text", "")
	end
end




