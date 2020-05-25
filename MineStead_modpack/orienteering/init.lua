local orienteering = {}
orienteering.playerhuds = {}
orienteering.settings = {}
orienteering.settings.speed_unit = "m/s"
orienteering.settings.length_unit = "m"
orienteering.settings.hud_pos = { x = 0, y = 0.75 }
orienteering.settings.hud_offset = { x = 15, y = 15 }
orienteering.settings.hud_alignment = { x = 1, y = 0 }

local set = tonumber(minetest.settings:get("orienteering_hud_pos_x"))
if set then orienteering.settings.hud_pos.x = set end
set = tonumber(minetest.settings:get("orienteering_hud_pos_y"))
if set then orienteering.settings.hud_pos.y = set end
set = tonumber(minetest.settings:get("orienteering_hud_offset_x"))
if set then orienteering.settings.hud_offset.x = set end
set = tonumber(minetest.settings:get("orienteering_hud_offset_y"))
if set then orienteering.settings.hud_offset.y = set end
set = minetest.settings:get("orienteering_hud_alignment")
if set == "left" then
	orienteering.settings.hud_alignment.x = 1
elseif set == "center" then
	orienteering.settings.hud_alignment.x = 0
elseif set == "right" then
	orienteering.settings.hud_alignment.x = -1
end

local o_lines = 3 -- Number of lines in HUD

-- Helper function to switch between 12h and 24 mode for the time
function orienteering.toggle_time_mode(itemstack, user, pointed_thing)
	--[[ Player attribute “orienteering:twelve”:
	* "true": Use 12h mode for time
	* "false" or unset: Use 24h mode for time ]]
	if user:get_attribute("orienteering:twelve") == "true" then
		user:set_attribute("orienteering:twelve", "false")
	else
		user:set_attribute("orienteering:twelve", "true")
	end
	orienteering.update_hud_displays(user)
end

local use = "Put this tool in your hotbar to see the data it provides."
local use_time = "Put this tool in your hotbar to make use of its functionality. Punch to toggle between 24-hour and 12-hour display for the time feature."

minetest.register_tool("orienteering:compass", {
	description = "Compass",
	_doc_items_longdesc = "It shows you your coordinates.",
	wield_image = "orienteering_compass_wield.png",
	inventory_image = "orienteering_compass_inv.png",
	groups = { disable_repair = 1 },
})

minetest.register_tool("orienteering:watch", {
	description = "Watch",
	_doc_items_longdesc = "It shows you the current time.",
	_doc_items_usagehelp = "Put the watch in your hotbar to see the time. Punch to toggle between the 24-hour and 12-hour display.",
	wield_image = "orienteering_watch.png",
	inventory_image = "orienteering_watch.png",
	groups = { disable_repair = 1 },
	on_use = orienteering.toggle_time_mode,
})


if minetest.get_modpath("default") ~= nil then
	-- Register crafts

	minetest.register_craft({
		output = "orienteering:compass",
		recipe = {
			{"", "default:glass", ""},
			{"default:tin_ingot", "default:iron_lump", "default:tin_ingot"},
			{"", "default:tin_ingot", ""},
		}
	})

	minetest.register_craft({
		output = "orienteering:watch",
		recipe = {
			{ "default:copper_ingot" },
			{ "default:glass" },
			{ "default:copper_ingot" }
		}
	})
end

-- Checks whether a certain orienteering tool is “active” and ready for use
function orienteering.tool_active(player, item)
	-- Requirement: player carries the tool in the hotbar
	local inv = player:get_inventory()
	local hotbar = player:hud_get_hotbar_itemcount()
	for i=1, hotbar do
		if inv:get_stack("main", i):get_name() == item then
			return true
		end
	end
	return false
end

function orienteering.init_hud(player)
	local name = player:get_player_name()
	orienteering.playerhuds[name] = {}
	for i=1, o_lines do
		orienteering.playerhuds[name]["o_line"..i] = player:hud_add({
			hud_elem_type = "text",
			text = "",
			position = orienteering.settings.hud_pos,
			offset = { x = orienteering.settings.hud_offset.x, y = orienteering.settings.hud_offset.y + 20*(i-1) },
			alignment = orienteering.settings.hud_alignment,
			number = 0xFFFFFF,
			scale= { x = 100, y = 20 },
		})
	end
end

function orienteering.update_hud_displays(player)
	local toDegrees=180/math.pi
	local name = player:get_player_name()
	local compass, watch

	if orienteering.tool_active(player, "orienteering:compass") then
		compass = true
	end
	if orienteering.tool_active(player, "orienteering:watch") then
		watch = true
	end

	local str_pos = ""
	local str_angles = ""
	local str_time = ""
	local pos = vector.round(player:get_pos())
	if compass then
		str_pos = "Coordinates: X="..pos.x..", Z="..pos.z
		str_angles = "Height: Y="..pos.y
	end

	if watch then
		local time = minetest.get_timeofday()
		local totalminutes = time * 1440
		local minutes = totalminutes % 60
		local hours = math.floor((totalminutes - minutes) / 60)
		minutes = math.floor(minutes/10)*10
		local twelve = player:get_attribute("orienteering:twelve") == "true"
		if twelve then
			if hours == 12 and minutes == 0 then
				str_time = "Time: noon"
			elseif hours == 0 and minutes == 0 then
				str_time = "Time: midnight"
			else
				local hours12 = math.fmod(hours, 12)
				if hours12 == 0 then hours12 = 12 end
				if hours >= 12 then
					str_time = "Time: "..string.format("%i", hours12)..":"..string.format("%02i", minutes).." p.m."
				else
					str_time = "Time: "..string.format("%i", hours12)..":"..string.format("%02i", minutes).." a.m."
				end
			end
		else
			str_time = "Time: "..string.format("%02i", hours)..":"..string.format("%02i", minutes)
		end
	end

	local strs = { str_pos, str_angles, str_time }
	local line = 1
	for i=1, o_lines do
		if strs[i] ~= "" then
			player:hud_change(orienteering.playerhuds[name]["o_line"..line], "text", strs[i])
			line = line + 1
		end
	end
	for l=line, o_lines do
		player:hud_change(orienteering.playerhuds[name]["o_line"..l], "text", "")
	end
end

minetest.register_on_newplayer(orienteering.init_hud)
minetest.register_on_joinplayer(orienteering.init_hud)

minetest.register_on_leaveplayer(function(player)
	orienteering.playerhuds[player:get_player_name()] = nil
end)

local updatetimer = 0
minetest.register_globalstep(function(dtime)
	updatetimer = updatetimer + dtime
	if updatetimer > 0.1 then
		local players = minetest.get_connected_players()
		for i=1, #players do
			orienteering.update_hud_displays(players[i])
		end
		updatetimer = updatetimer - dtime
	end
end)
