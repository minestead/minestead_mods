

local cooldown_timers = {} -- playername -> mission-name -> number(finish time)

-- resets the cooldown timer
missions.cooldown_reset = function(mission_name, playername)
	local now = os.time(os.date("!*t"))
	local mission_data = cooldown_timers[playername]
	if not mission_data then
		mission_data = {}
		cooldown_timers[playername] = mission_data
	end

	mission_data[mission_name] = now
end

-- returns the seconds since the mission was finished or zero if never finished
missions.cooldown_get = function(mission_name, playername)
	local now = os.time(os.date("!*t"))

	local mission_data = cooldown_timers[playername]
	if not mission_data then
		return 0
	end

	local last_time = mission_data[mission_name]

	if not last_time then
		return 0
	end

	local diff = now - last_time

	return diff
end
