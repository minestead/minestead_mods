--[[

	=======================================================
	SmartLine Modules
	by Micu (c) 2018, 2019

	AutoSieve Sensor

	This node is a sensor pad for Techpack Automated Gravel
	Sieve. Although AutoSieve can interact with Tubelib
	machinery like any other Techpack machine, it does
	not have Tubelib ID, so it cannot be controlled or
	monitored. Sensor pad node should be placed UNDER
	AutoSieve. It gets standard ID and its working
	principle is identical to Furnace Monitor.

	Sensor states are read through standard Tubelib status
	query (for example $get_status(...) function in
	SaferLua Controller). Item count is also supported
	($get_counter(...) command returns number of sieve
	items processed).

	Device checks attached node only when status is
	requested so it does not consume CPU resources when
	idle.

	Placement: place directly under Automated Gravel Sieve.

	Status:
	"fault" - there is no AutoSieve above sensor node
	"stopped" - AutoSieve is not working
	"running" - AutoSieve is running
	"defect" - AutoSieve is broken and needs to be
		   repaired

	Note: there is no "standby" state.

	Punch node to see current status.

	License: LGPLv2.1+
	=======================================================

]]--


--[[
	-------
	Helpers
	-------
]]--

-- get AutoSieve status as tubelib text string:
-- not an AutoSieve node = "fault"
-- AutoSieve not working = "stopped"
-- AutoSieve processing gravel = "running"
-- AutoSieve broken due to aging = "defect"
-- (pos is sensor node position)
local function get_tubelib_autosieve_state(pos)
	local sievepos = vector.add(pos, { x = 0, y = 1, z = 0 })
	local node = minetest.get_node(sievepos)
	-- (we won't fire regexp cannon on mere 4 strings...)
	if node.name == "gravelsieve:auto_sieve0" or
	   node.name == "gravelsieve:auto_sieve1" or
	   node.name == "gravelsieve:auto_sieve2" or
	   node.name == "gravelsieve:auto_sieve3" then
		if minetest.get_node_timer(sievepos):is_started() then
			return tubelib.StateStrings[tubelib.RUNNING]
		else
			return tubelib.StateStrings[tubelib.STOPPED]
		end
	elseif node.name == "gravelsieve:sieve_defect" then
		return tubelib.StateStrings[tubelib.DEFECT]
	end
	return tubelib.StateStrings[tubelib.FAULT]
end

-- get AutoSieve item counter
-- (pos is sensor node position)
local function get_tubelib_autosieve_counter(pos)
	local sievepos = vector.add(pos, { x = 0, y = 1, z = 0 })
	local node = minetest.get_node(sievepos)
	if node.name == "gravelsieve:auto_sieve0" or
	   node.name == "gravelsieve:auto_sieve1" or
	   node.name == "gravelsieve:auto_sieve2" or
	   node.name == "gravelsieve:auto_sieve3" or
	   node.name == "gravelsieve:sieve_defect" then
		local meta = minetest.get_meta(sievepos)
		return meta:get_int("gravel_cnt") or 0
	end
	return -1
end

--[[
	-----------------
	Node registration
	-----------------
]]--

minetest.register_node("slmodules:autosievesensor", {
	description = "SmartLine AutoSieve Sensor",
	tiles = {
		-- up, down, right, left, back, front
		"slmodules_autosievesensor_top.png",
		"slmodules_default_plate.png",
		"slmodules_autosievesensor_side.png",
		"slmodules_autosievesensor_side.png",
		"slmodules_autosievesensor_side.png",
		"slmodules_autosievesensor_side.png",
	},

	after_place_node = function(pos, placer, itemstack, pointed_thing)
		local meta = minetest.get_meta(pos)
		local number = tubelib.add_node(pos, "slmodules:autosievesensor")
		meta:set_string("number", number)
		meta:set_string("infotext", "AutoSieve Sensor " .. number)
		meta:set_string("owner", placer:get_player_name())
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
		local state = get_tubelib_autosieve_state(pos)
		local msgclr = { ["fault"] = "#FFBFBF",
				 ["defect"] = "#FFBFBF",
				 ["stopped"] = "#BFBFFF",
				 ["running"] = "#BFFFBF" }
		minetest.chat_send_player(player_name,
			minetest.colorize("#FFFF00", "[AutoSieveSensor:" ..
			meta:get_string("number") .. "]") .. " Status is " ..
			minetest.colorize(msgclr[state],
			"\"" .. state .. "\""))
		return true
	end,

	on_rotate = screwdriver.disallow,
	paramtype = "light",
	sunlight_propagates = true,
	paramtype2 = "facedir",
	groups = { choppy = 2, cracky = 2, crumbly = 2 },
	is_ground_content = false,
	sounds = default.node_sound_metal_defaults(),
})

tubelib.register_node("slmodules:autosievesensor", {}, {
	on_recv_message = function(pos, topic, payload)
		if topic == "state" then
			return get_tubelib_autosieve_state(pos)
		elseif topic == "counter" then
			return get_tubelib_autosieve_counter(pos)
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
	output = "slmodules:autosievesensor",
	type = "shaped",
	recipe = {
		{ "default:copperblock", "default:steel_ingot", "default:copperblock" },
		{ "dye:blue", "default:mese_crystal", "tubelib:wlanchip" },
		{ "group:wood", "default:steel_ingot", "group:wood" },
	},
})
