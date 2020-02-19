--[[

	=======================================================
	SmartLine Modules
	by Micu (c) 2018, 2019

	Furnace Monitor

	Monitor Minetest Game standard furnace with
	Tubelib/Smartline devices like Controllers.
	It is a one-way (read-only) gateway that converts
	furnace operational status to Tubelib states.

	States are read through standard Tubelib status query
	(for example $get_status(...) function in SaferLua
	Controller).

	Device checks attached node only when status is
	requested so it does not consume CPU resources
	when idle.

	Placement: place on any side of a furnace, make
	sure back plate of device has contact with
	monitored node. In case of wrong orientation use
	screwdriver.

	Status:
	"fault" - monitor is not placed on a furnace
	"stopped" - furnace is not smelting/cooking
	"running" - furnace is smelting/cooking items
	"standby" - furnace is burning fuel but there
		    are no items loaded

	Punch node to see current status.

	License: LGPLv2.1+
	=======================================================

]]--


--[[
	-------
	Helpers
	-------
]]--

-- get furnace status as tubelib text string:
-- not a furnace node = "fault"
-- furnace not burning = "stopped"
-- furnace smelting items = "running"
-- furnace burning without items = "standby"
local function get_tubelib_furnace_state(monitor_pos, monitor_node)
	local monnode = monitor_node or minetest.get_node(monitor_pos)
	local pos = vector.add(monitor_pos,
		minetest.facedir_to_dir(monnode.param2))
	local node = minetest.get_node(pos)
	local meta = minetest.get_meta(pos)
	if node.name == "default:furnace" then
		return tubelib.StateStrings[tubelib.STOPPED]
	elseif node.name == "default:furnace_active" then
		local inv = meta:get_inventory()
		if inv:is_empty("src") then
			return tubelib.StateStrings[tubelib.STANDBY]
		else
			return tubelib.StateStrings[tubelib.RUNNING]
		end
	end
	return tubelib.StateStrings[tubelib.FAULT]
end

--[[
	-----------------
	Node registration
	-----------------
]]--

minetest.register_node("slmodules:furnacemonitor", {
	description = "SmartLine Furnace Monitor",
	inventory_image = "furnacemonitor_inventory.png",
	tiles = {
		-- up, down, right, left, back, front
		"smartline.png",
		"smartline.png",
		"smartline.png",
		"smartline.png",
		"smartline.png",
		"smartline.png^furnacemonitor_flame_black.png",
	},

	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{ -6/32, -6/32, 14/32,  6/32,  6/32, 16/32},
		},
	},

	after_place_node = function(pos, placer, itemstack, pointed_thing)
		local meta = minetest.get_meta(pos)
		local number = tubelib.add_node(pos, "slmodules:furnacemonitor")
		meta:set_string("number", number)
		meta:set_string("infotext", "Furnace Monitor " .. number)
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
		local state = get_tubelib_furnace_state(pos, node)
		local msgclr = { ["fault"] = "#FFBFBF",
				 ["standby"] = "#BFFFFF",
				 ["stopped"] = "#BFBFFF",
				 ["running"] = "#BFFFBF" }
		minetest.chat_send_player(player_name,
			minetest.colorize("#FFFF00", "[FurnaceMonitor:" ..
			meta:get_string("number") .. "]") .. " Status is " ..
			minetest.colorize(msgclr[state],
			"\"" .. state .. "\""))
		return true
	end,

	paramtype = "light",
	sunlight_propagates = true,
	paramtype2 = "facedir",
	groups = { cracky = 2, crumbly = 2 },
	is_ground_content = false,
	sounds = default.node_sound_metal_defaults(),
})

tubelib.register_node("slmodules:furnacemonitor", {}, {
	on_recv_message = function(pos, topic, payload)
		if topic == "state" then
			return get_tubelib_furnace_state(pos)
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
	output = "slmodules:furnacemonitor",
	type = "shaped",
	recipe = {
		{ "", "default:tin_ingot", "" },
		{ "dye:blue", "default:copper_ingot", "tubelib:wlanchip" },
		{ "", "dye:black", "" },
	},
})

--[[
	---------------------
	FurnaceMonitor update
	---------------------
]]--

minetest.register_lbm({
	label = "FurnaceMonitor update",
	name = "slmodules:furnacemonitor_update",
	nodenames = { "furnacemonitor:furnacemonitor", },
	run_at_every_load = true,
	action = function(pos, node)
		node.name = "slmodules:furnacemonitor"
		minetest.swap_node(pos, node)
	end
})
