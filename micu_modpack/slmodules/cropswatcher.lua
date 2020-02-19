--[[

	=======================================================================
	SmartLine Modules Mod
	by Micu (c) 2018, 2019

	Crops Watcher

	Advanced optical device to assist in crop farming automation.
	It scans rectangular area of selected radius for crops (wheat, tomatoes
	etc) and signals if field is ready for harvest. Device recognizes all
	registered farming nodes. Crop Watcher sees plants at its level and
	down to 2 levels below node (0, -1, -2), with exception of nodes
	directly under its box.
	Configuration options are accessible via panel: ID numbers to send
	messages to, scan radius (1-16) and minimum number of crops for area
	to be considered a valid crop field (0 to maximum field area).
	When Tubelib ID numbers are entered, scan can be initiated by sending
	"on" message to Watcher (by Timer, Button etc) - if field is ready to
	harvest, device immediately responses with "on" command sent to
	specified IDs (for example Tubelib Harvester). No messages are sent for
	other states - Crops Watcher never sends "off" commands to not interfere
	with machinery automation.
	Event-based node - it does not use node timer.
	
	Placement: place in the center of the field, up to 2 nodes above ground
	level.

	Status:
	- "error" - there are no crops in the area or they fall below defined
	   minimum
	- "growing" - there are enough crops in the area, some of them are still
	   growing
	- "ready" - there are enough crops in the area and all are ready for
	   harvest

	Events (optional):
	- "on" - sent when device received "on" message, scanned area and
	   result is "ready"

	Supported SaferLua functions:
	- $get_status(...)
	- $get_crops_status(...)

	Punch node to see current status and crop numbers.

	License: LGPLv2.1+
	=======================================================================

]]--


--[[
	---------------
	Local variables
	---------------
]]--

-- range constants
local RADIUS_MIN = 1
local RADIUS_MAX = 16
local LEVEL_TOP = 0
local LEVEL_BOTTOM = -2

-- states
local CW_ERROR = 1
local CW_GROWING = 2
local CW_READY = 3
local cwstate = {
	[CW_ERROR] = "error",
	[CW_GROWING] = "growing",
	[CW_READY] = "ready"
}

-- tables with farming crop nodes
local cropnames = {}
local isgrowncrop = {}
for j, c in pairs(farming.registered_plants) do
	local lcn = c.crop or "farming:" .. j
	for i = 1, c.steps do
		cropnames[#cropnames + 1] = lcn .. "_" .. i
	end
	isgrowncrop[lcn .. "_" .. c.steps] = true
end

--[[
	-------
	Helpers
	-------
]]--

-- get status for crops area for watcher at pos
-- return 1: CW_ERROR for not enough growable crops,
-- 	CW_GROWING for crops in growing state,
-- 	CW_READY if all crops are ready for harvest
-- return 2: total number of crops in area
-- return 3: grown crops in area
local function get_cropswatcher_area_state(pos)
	local meta = minetest.get_meta(pos)
	local radius = meta:get_int("radius") or 8
	local cropsmin = meta:get_int("crops_min") or 0
	local minpos = vector.add(pos, { x = -radius, y = LEVEL_BOTTOM, z = -radius })
	local maxpos = vector.add(pos, { x = radius, y = LEVEL_TOP, z = radius })
	minetest.load_area(minpos, maxpos)
	local _, crops = minetest.find_nodes_in_area(minpos, maxpos, cropnames)
	local _, subcrops = minetest.find_nodes_in_area(
		vector.add(pos, { x = 0, y = LEVEL_BOTTOM, z = 0 }),
		vector.add(pos, { x = 0, y = LEVEL_TOP, z = 0 }),
		cropnames)
	local crnum = 0
	local grown = 0
	for c, n in pairs(crops) do
		crnum = crnum + n
		if isgrowncrop[c] then
			grown = grown + n
		end
	end
	-- do not count nodes at the same (x, z) coordinates
	for c, n in pairs(subcrops) do
		crnum = crnum - n
		if isgrowncrop[c] then
			grown = grown - n
		end
	end
	if (cropsmin == 0 and crnum == 0) or
	   (cropsmin > 0 and crnum < cropsmin) then
		return CW_ERROR, crnum, grown
	elseif grown == crnum then
		return CW_READY, crnum, grown
	end
	return CW_GROWING, crnum, grown
end

-- calculate max number of crops in area:
-- note: (2*r+1)^2-1 = 4*r*(r+1)
local function get_max_crops(radius)
	return 4 * radius * (radius + 1)
end

--[[
	--------
	Formspec
	--------
]]--

-- configuration formspec
local function formspec(meta, opt_radius, opt_cropsmin)
	local number = meta:get_string("own_num")
	local radius = opt_radius or meta:get_int("radius") or 8
	local cropsmin = opt_cropsmin or meta:get_int("crops_min") or 0
	local cropsmax = get_max_crops(radius)
	cropsmin = math.min(cropsmin, cropsmax)
	local radiuslist = ""
	for i = RADIUS_MIN, RADIUS_MAX do
		radiuslist = radiuslist .. i
		if i < RADIUS_MAX then
			radiuslist = radiuslist .. ","
		end
	end
	return "size[8.4,3.6]" ..
	"label[3,0;" .. minetest.colorize("#FFFF00", "Crops Watcher ") ..
		minetest.colorize("#00FFFF", number) .. "]" ..
	"label[0,1;Enter destination number(s) (optional)]" ..
	"field[4,1.1;4.5,1;numbers;;${numbers}]" ..
	"field_close_on_enter[numbers;true]" ..
	"label[0,2;Select radius]" ..
	"dropdown[1.5,1.85;0.75;radius;" .. radiuslist .. ";" .. radius .. "]" ..
	"label[2.8,2;Minimal number of crops in area (0 - " .. cropsmax .. ")]" ..
	"field[7.2,2.1;1.3,1;cropsmin;;" .. cropsmin .. "]" ..
	"field_close_on_enter[cropsmin;true]" ..
	"button_exit[5.2,2.8;1.5,1;ok;OK]" ..
	"button_exit[6.8,2.8;1.5,1;cancel;Cancel]"
end

--[[
	-----------------
	Node registration
	-----------------
]]--

minetest.register_node("slmodules:cropswatcher", {
	description = "SmartLine Crops Watcher",
	tiles = {
		-- up, down, right, left, back, front
		"slmodules_default_plate.png",
		"slmodules_default_plate.png",
		"slmodules_cropswatcher_side.png",
		"slmodules_cropswatcher_side.png",
		"slmodules_cropswatcher_side.png",
		"slmodules_cropswatcher_side.png",
	},

	after_place_node = function(pos, placer, itemstack, pointed_thing)
		local meta = minetest.get_meta(pos)
		local number = tubelib.add_node(pos, "slmodules:cropswatcher")
		meta:set_string("own_num", number)
		meta:set_string("infotext", "Crops Watcher " .. number)
		meta:set_string("owner", placer:get_player_name())
		meta:set_string("numbers", "")
		meta:set_int("radius", 8)
		meta:set_int("crops_min", 0)
		meta:set_string("formspec", formspec(meta))
	end,

	can_dig = function(pos, player)
		if minetest.is_protected(pos, player:get_player_name()) then
			return false
		end
		return true
	end,

	after_dig_node = function(pos, oldnode, oldmetadata, digger)
		tubelib.remove_node(pos)
	end,

	on_punch = function(pos, node, puncher, pointed_thing)
		local meta = minetest.get_meta(pos)
		local player_name = puncher:get_player_name()
		if meta:get_string("owner") ~= player_name then
			return false
		end
		local sn, cn, gn = get_cropswatcher_area_state(pos)
		local msgclr = { ["error"] = "#FFBFBF",
				 ["growing"] = "#FFFFBF",
				 ["ready"] = "#BFFFBF" }
		minetest.chat_send_player(player_name,
			minetest.colorize("#FFFF00", "[CropsWatcher:" ..
			meta:get_string("own_num") .. "]") .. " Status is " ..
			minetest.colorize(msgclr[cwstate[sn]], "\"" ..
				cwstate[sn] .. "\"") ..
			", total crops: " .. cn .. ", fully grown: " .. gn)
		return true
	end,

	on_receive_fields = function(pos, formname, fields, sender)
		if minetest.is_protected(pos, sender:get_player_name()) then
			return
		end
		local meta = minetest.get_meta(pos)
		if fields.ok or fields.key_enter_field == "numbers" or
		   fields.key_enter_field == "cropsmin" then
			local number = meta:get_string("own_num")
			local numbers = fields.numbers and fields.numbers:trim() or ""
			local cropsmin = tonumber(fields.cropsmin and fields.cropsmin:trim() or "0") or 0
			local radius = tonumber(fields.radius)
			cropsmin = math.max(math.min(cropsmin, get_max_crops(radius)), 0)
			meta:set_string("numbers", numbers)
			meta:set_int("radius", radius)
			meta:set_int("crops_min", cropsmin)
			meta:set_string("infotext", "Crops Watcher " ..
				number .. (numbers ~= "" and
				" (connected with: " .. numbers .. ")" or ""))
			meta:set_string("formspec", formspec(meta))
		elseif fields.radius and not fields.quit then
			local radius = tonumber(fields.radius)
			meta:set_string("formspec", formspec(meta, radius,
				math.max(math.min(fields.cropsmin, get_max_crops(radius)), 0)))
		elseif fields.cancel or fields.quit then
			meta:set_string("formspec", formspec(meta))
		end
	end,

	on_rotate = screwdriver.disallow,
	paramtype = "light",
	sunlight_propagates = true,
	paramtype2 = "facedir",
	groups = { choppy = 2, cracky = 2, crumbly = 2 },
	is_ground_content = false,
	sounds = default.node_sound_metal_defaults(),
})

tubelib.register_node("slmodules:cropswatcher", {}, {
	on_recv_message = function(pos, topic, payload)
		if topic == "on" then
			local meta = minetest.get_meta(pos)
			local owner = meta:get_string("owner")
			local number = meta:get_string("own_num")
			local numbers = meta:get_string("numbers") or ""
			if numbers ~= "" and get_cropswatcher_area_state(pos) == CW_READY then
				-- send message: topic = "on", payload = "NUMBER"
				tubelib.send_message(numbers, owner, owner, "on", number)
			end
			return true
		elseif topic == "state" then
			return cwstate[get_cropswatcher_area_state(pos)]
		elseif topic == "crops" then
			local sn, cn, gn = get_cropswatcher_area_state(pos)
			return { cwstate[sn], cn, gn }
		else
			return "unsupported"
		end
	end,
})

--[[
	--------
	Crafting
	--------
]]--

minetest.register_craft({
	output = "slmodules:cropswatcher",
	type = "shaped",
	recipe = {
		{ "default:steelblock", "default:copper_ingot", "default:steelblock" },
		{ "default:glass", "default:diamond", "default:mese_crystal" },
		{ "group:wood", "tubelib:wlanchip", "group:wood" },
	},
})

--[[
	--------
	SaferLua
	--------
]]--

sl_controller.register_action("get_crops_status", {
	cmnd = function(self, num)
		num = tostring(num or "")
		return unpack(tubelib.send_request(num, "crops", nil) or { "", "", "" })
	end,
	help = " $get_crops_status(num)\n" ..
		" Read Crops Watcher device state.\n" ..
		" Function returns 3 values:\n" ..
		' 1: "error", "growing" or "ready"\n' ..
		" 2: total number of crops\n" ..
		" 3: number of fully grown crops\n" ..
		' example: state, total, grown = $get_crops_status("1234")\n'
})
