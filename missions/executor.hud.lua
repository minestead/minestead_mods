
local HUD_POSITION = {x = missions.hud.posx, y = missions.hud.posy}
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
		offset = {x = 0,   y = 30},
		text = "",
		alignment = HUD_ALIGNMENT,
		scale = {x = 100, y = 100},
		number = 0x00FF00
	})

	data.time = player:hud_add({
		hud_elem_type = "text",
		position = HUD_POSITION,
		offset = {x = 0,   y = 60},
		text = "",
		alignment = HUD_ALIGNMENT,
		scale = {x = 100, y = 100},
		number = 0x00FF00
	})

	data.status = player:hud_add({
		hud_elem_type = "text",
		position = HUD_POSITION,
		offset = {x = 0,   y = 90},
		text = "",
		alignment = HUD_ALIGNMENT,
		scale = {x = 100, y = 100},
		number = 0x00FF00
	})


	hud[playername] = data
end)

missions.hud_update_status = function(player, status)
	local playername = player:get_player_name()
	local data = hud[playername]

	if not data then
		return
	end

	player:hud_change(data.status, "text", status)
end

missions.hud_update = function(player, mission)

	local playername = player:get_player_name()
	local data = hud[playername]

	if not data then
		return
	end

	if mission then
		local now = os.time(os.date("!*t"))
		local remainingTime = mission.time - (now - mission.start)

		local percent = math.floor((mission.currentstep-1) / #mission.steps * 100)

		player:hud_change(data.title, "text", "Mission: " .. mission.name)
		player:hud_change(data.mission, "text", "Completed: " .. percent .. "%")
		player:hud_change(data.time, "text", "Time: " .. missions.format_time(remainingTime))

		if remainingTime > 60 then
			player:hud_change(data.time, "number", 0x00FF00)
			player:hud_change(data.mission, "number", 0x00FF00)
		else
			player:hud_change(data.time, "number", 0xFF0000)
			player:hud_change(data.mission, "number", 0xFF0000)
		end
	else
		player:hud_change(data.title, "text", "")
		player:hud_change(data.mission, "text", "")
		player:hud_change(data.time, "text", "")
		player:hud_change(data.status, "text", "")
	end
end

minetest.register_on_leaveplayer(function(player)
	local playername = player:get_player_name()
	hud[playername] = nil
end)
