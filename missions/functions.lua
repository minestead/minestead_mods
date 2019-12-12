
missions.check_owner = function(pos, player)
	-- check override priv
	local has_override = minetest.check_player_privs(player, "protection_bypass")
	if has_override then
		return true
	end

	-- check owner
	local meta = minetest.get_meta(pos)
	return player and player:is_player() and player:get_player_name() == meta:get_string("owner")
end

local SECONDS_IN_DAY = 3600*24
local SECONDS_IN_HOUR = 3600
local SECONDS_IN_MINUTE = 60



missions.get_owner_from_pos = function(pos)
	local meta = minetest.get_meta(pos)
	return meta:get_string("owner")
end


local playermissions = {}
local playerabort = {}

--persistence stuff

minetest.register_on_joinplayer(function(player)
	local missionStr = player:get_attribute(missions.MISSION_ATTRIBUTE_NAME)

	local mission = nil
	if missionStr then
		mission = minetest.deserialize(missionStr)
	end

	if mission and mission.version == missions.CURRENT_MISSION_SPEC_VERSION then
		-- only load if compatible with current spec
		local step = mission.steps[mission.currentstep]
		if step == nil then
			return
		end

		-- reset init flag
		step.initialized = false

		-- store in variable
		playermissions[player:get_player_name()] = mission
	end
end)

minetest.register_on_leaveplayer(function(player)
	playermissions[player:get_player_name()] = nil
end)

missions.persist_mission = function(player, mission)
	player:set_attribute(missions.MISSION_ATTRIBUTE_NAME, minetest.serialize(mission))
end

minetest.register_on_respawnplayer(function(player)
	missions.abort(player:get_player_name())
end)


missions.set_current_mission = function(player, mission)
	playerabort[player:get_player_name()] = false
	playermissions[player:get_player_name()] = mission
end



missions.get_current_mission = function(player)
	return playermissions[player:get_player_name()]
end

missions.abort = function(playername)
	playerabort[playername] = true
end

missions.has_aborted = function(playername)
	return playerabort[playername]
end


missions.format_time = function(seconds)
	local str = ""


	if seconds >= SECONDS_IN_DAY then
		local days = math.floor(seconds / SECONDS_IN_DAY)
		str = str .. days .. " d "
		seconds = seconds - (days * SECONDS_IN_DAY)
	end

	if seconds >= SECONDS_IN_HOUR then
		local hours = math.floor(seconds / SECONDS_IN_HOUR)
		str = str .. hours .. " h "
		seconds = seconds - (hours * SECONDS_IN_HOUR)
	end

	if seconds >= SECONDS_IN_MINUTE then
		local minutes = math.floor(seconds / SECONDS_IN_MINUTE)
		str = str .. minutes .. " min "
		seconds = seconds - (minutes * SECONDS_IN_MINUTE)
	end

	str = str .. seconds .. " s"

	return str
end

-- mission steps setter/getter
missions.get_steps = function(pos)
	local meta = minetest.get_meta(pos)
	local steps = minetest.deserialize(meta:get_string("steps"))

	return steps
end

missions.set_steps = function(pos, steps)
	local meta = minetest.get_meta(pos)
	meta:set_string("steps", minetest.serialize(steps))
end

-- user selected step

local SELECTED_LIST_ITEM_ATTR_NAME = "missions_selected_list_item"

missions.get_selected_list_item = function(player)
	return tonumber( player:get_attribute(SELECTED_LIST_ITEM_ATTR_NAME) or "1" )
end

missions.set_selected_list_item = function(player, num)
	player:set_attribute(SELECTED_LIST_ITEM_ATTR_NAME, num)
end



-- node register helper
missions.only_owner_can_dig = function(pos, player)
	if not player then
		return false
	end

	local has_override = minetest.check_player_privs(player, "protection_bypass")

	local meta = minetest.get_meta(pos)
	local playername = player:get_player_name() or ""
	return meta:get_string("owner") == playername or has_override
end


-- returns the image (item, node, tool) or ""
missions.get_image = function(name)
	-- stolen from drawers code
	local texture = "blank.png"
	local def = minetest.registered_items[name]
	if not def then
		return texture
	end

	if def.inventory_image and #def.inventory_image > 0 then
		texture = def.inventory_image
	else
		if not def.tiles then return texture end
		local tiles = table.copy(def.tiles)

		for k,v in pairs(tiles) do
		        if type(v) == "table" then
		                tiles[k] = v.name
		        end
		end

		-- tiles: up, down, right, left, back, front
		-- inventorycube: up, front, right
		if #tiles <= 2 then
		        texture = minetest.inventorycube(tiles[1], tiles[1], tiles[1])
		elseif #tiles <= 5 then
		        texture = minetest.inventorycube(tiles[1], tiles[3], tiles[3])
		else -- full tileset
		        texture = minetest.inventorycube(tiles[1], tiles[6], tiles[3])
		end
	end

	return texture

end



missions.show_banner = function(player, title, msg)
	minetest.sound_play({name="missions_generic", gain=0.25}, {to_player=player:get_player_name()})


	local one = player:hud_add({
		hud_elem_type = "image",
		name = "award_bg",
		scale = {x = 2, y = 1},
		text = "missions_bg_default.png",
		position = {x = 0.5, y = 0},
		offset = {x = 0, y = 138},
		alignment = {x = 0, y = -1}
	})

	local two = player:hud_add({
		hud_elem_type = "text",
		name = "award_au",
		number = 0xFFFFFF,
		scale = {x = 100, y = 20},
		text = title,
		position = {x = 0.5, y = 0},
		offset = {x = 0, y = 40},
		alignment = {x = 0, y = -1}
	})

	local three = player:hud_add({
		hud_elem_type = "text",
		name = "rank_title",
		number = 0xFFFFFF,
		scale = {x = 100, y = 20},
		text = msg,
		position = {x = 0.5, y = 0},
		offset = {x = 30, y = 100},
		alignment = {x = 0, y = -1}
	})

	local rank_offset = {x = -1.5, y = 126}

	local four = player:hud_add({
		hud_elem_type = "image",
		name = "award_icon",
		scale = {x = 2, y = 2},
		text = "missions_block_preview.png",
		position = {x = 0.4, y = 0},
		offset = rank_offset,
		alignment = {x = 0, y = -1}
	})

	minetest.after(4, function()
		player:hud_remove(one)
		player:hud_remove(two)
		player:hud_remove(three)
		player:hud_remove(four)
	end)
end

