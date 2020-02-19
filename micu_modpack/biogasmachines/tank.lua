--[[

	========================================================================
	Tubelib Biogas Machines Mod
	by Micu (c) 2018, 2019

	Copyright (C) 2018, 2019 Michal Cieslakiewicz

	This is source file for Biogas Tank - a dedicated storage for Biogas
	units.

	Gas tank comes in 3 sizes:
	- Small - 2 stacks
	- Medium - 32 stacks (standard Chest equivalent)
	- Large - 72 stacks (Tubelib HighPerf Chest equivalent)

	Features:
	* Biogas-only inventory
	* Tubelib I/O compatibility
	* real-time 3-level color visual fill indicator on device box
	* current capacity information in infotext
	* support for Tubelib stack pulling (can be paired with HighPerf Pusher)
	* no defects (not a machine)
	* support for standard SaferLua storage status (empty/loaded/full)
	* no node timer

	License: LGPLv2.1+
	========================================================================
	
]]--

--[[
	---------
	Variables
	---------
]]--

-- tanks definitions
local TANK_SMALL = 1
local TANK_MEDIUM = 2
local TANK_LARGE = 3

local tanks = {
	[TANK_SMALL] = { label = "Small", invsize = 2, invmax = 2 * 99, invform = { x = 2, y = 1} },
	[TANK_MEDIUM] = { label = "Medium", invsize = 32, invmax = 32 * 99, invform = { x = 8, y = 4 } },
	[TANK_LARGE] = { label = "Large", invsize = 72, invmax = 72 * 99, invform = { x = 12, y = 6 } },
}

--[[
        --------
        Formspec
        --------
]]--

-- formspec
-- Parameters: tank_size (number) - size type of tank
local function formspec(tank_size)
	local tank = tanks[tank_size]
	local sizex = math.max(tank.invform.x, 8)
	local invby = math.max(tank.invform.y, 2)
	local plrx = tostring((sizex - 8) / 2)
	return "size[" .. tostring(sizex) .. "," ..
		tostring(invby + 4.75) .. "]" ..
	default.gui_bg ..
	default.gui_bg_img ..
	default.gui_slots ..
	"list[context;main;" .. tostring((sizex - tank.invform.x) / 2).. "," ..
		tostring((invby - tank.invform.y) / 2) .. ";" ..
		tostring(tank.invform.x) .. "," ..
		tostring(tank.invform.y) .. ";]" ..
	"list[current_player;main;" .. plrx .. "," ..
		tostring(invby + 0.5) .. "4;8,1;]" ..
	"list[current_player;main;" .. plrx .. "," ..
		tostring(invby + 1.75) .. ";8,3;8]" ..
	"listring[context;main]" ..
	"listring[current_player;main]" ..
	default.get_hotbar_bg(plrx, invby + 0.5)
end

--[[
	-------
	Helpers
	-------
]]--

-- get total number of Biogas units in inventory
local function get_biogas_count(inv)
	if inv:is_empty("main") then
		return 0
	end
	local c = 0
	for i = 1, inv:get_size("main") do
		local item = inv:get_stack("main", i)
		if item:get_name() == "tubelib_addons1:biogas" then
			c = c + item:get_count()
		end
	end
	return c
end

-- swap tank node at pos to reflect current fill state
local function update_tank_node(pos)
	local node = minetest.get_node(pos)
	local def = minetest.registered_nodes[node.name]
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local number = meta:get_string("number")
	local tank = tanks[def._tank_size]
	local count = get_biogas_count(inv)
	local pct = 100 * count / tank.invmax
	meta:set_string("infotext", tank.label .. " Biogas Tank " .. number ..
		string.format(" (%.2f %% full, %d / %d)", pct, count, tank.invmax))
	local newname = "biogasmachines:tank_" .. string.lower(tank.label)
	if pct > 0 and pct <= 33 then
		newname = newname .. "_1"
	elseif pct > 33 and pct <= 66 then
		newname = newname .. "_2"
	elseif pct > 66 then
		newname = newname .. "_3"
	end
	if newname ~= node.name then
		node.name = newname
		minetest.swap_node(pos, node)
	end
end

--[[
	---------
	Callbacks
	---------
]]--

-- do not allow to dig protected or non-empty tank
local function can_dig(pos, player)
	if minetest.is_protected(pos, player:get_player_name()) then
		return false
	end
	local meta = minetest.get_meta(pos);
	local inv = meta:get_inventory()
	return inv:is_empty("main")
end

-- cleanup after digging
local function after_dig_node(pos, oldnode, oldmetadata, digger)
	tubelib.remove_node(pos)
end

-- init tank after placement
local function after_place_node(pos, placer, itemstack, pointed_thing)
	local node = minetest.get_node(pos)
	local def = minetest.registered_nodes[node.name]
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local tank = tanks[def._tank_size]
	inv:set_size("main", tank.invsize)
	meta:set_string("owner", placer:get_player_name())
	local number = tubelib.add_node(pos, "biogasmachines:tank_" .. string.lower(tank.label))
	meta:set_string("number", number)
	meta:set_string("formspec", formspec(def._tank_size))
	update_tank_node(pos)
end

-- validate incoming items
local function allow_metadata_inventory_put(pos, listname, index, stack, player)
	if not minetest.is_protected(pos, player:get_player_name()) and
	   stack:get_name() == "tubelib_addons1:biogas" then
		return stack:get_count()
	end
	return 0
end

--[[
	-----------------
	Registration loop
	-----------------
]]--

for s, tank in ipairs(tanks) do
	local sz = string.lower(tank.label)
	local basename = "biogasmachines:tank_" .. sz
	local topimg = "biogasmachines_tank_" .. sz .. "_top.png"
	local bottomimg = "biogasmachines_tank_" .. sz .. "_bottom.png"
	local sideimg = "biogasmachines_tank_" .. sz .. "_side.png"
	local desc = "Tubelib " .. tank.label .. " Biogas Tank"
	local biogastanknodes = { basename }

	--[[
		-----------------
		Node registration
		-----------------
	]]--

	minetest.register_node(basename, {
		description = desc,
		tiles = {
			-- up, down, right, left, back, front
			topimg, bottomimg,
			sideimg, sideimg, sideimg, sideimg,
		},
		drawtype = "nodebox",

		paramtype = "light",
		sunlight_propagates = true,
		paramtype2 = "facedir",
		groups = { choppy = 2, cracky = 2, crumbly = 2 },
		is_ground_content = false,
		sounds = default.node_sound_metal_defaults(),

		after_place_node = after_place_node,
		can_dig = can_dig,
		after_dig_node = after_dig_node,
		on_rotate = screwdriver.disallow,
		allow_metadata_inventory_put = allow_metadata_inventory_put,
		on_metadata_inventory_move = update_tank_node,
		on_metadata_inventory_put = update_tank_node,
		on_metadata_inventory_take = update_tank_node,
		_tank_size = s,
	})

	for i = 1, 3 do
		local n = tostring(i)
		local fillname = basename .. "_" .. n
		local fillimg = sideimg .. "^biogasmachines_tank_fill_" .. n .. ".png"
		biogastanknodes[i + 1] = fillname
		minetest.register_node(fillname, {
			description = desc,
			tiles = {
				-- up, down, right, left, back, front
				topimg, bottomimg,
				fillimg, fillimg, fillimg, fillimg,
			},
			drawtype = "nodebox",

			drop = basename,
			paramtype = "light",
			sunlight_propagates = true,
			paramtype2 = "facedir",
			groups = { choppy = 2, cracky = 2, crumbly = 2, not_in_creative_inventory = 1 },
			is_ground_content = false,
			sounds = default.node_sound_metal_defaults(),

			can_dig = can_dig,
			after_dig_node = after_dig_node,
			on_rotate = screwdriver.disallow,
			allow_metadata_inventory_put = allow_metadata_inventory_put,
			on_metadata_inventory_move = update_tank_node,
			on_metadata_inventory_put = update_tank_node,
			on_metadata_inventory_take = update_tank_node,
			_tank_size = s,
		})
	end

	tubelib.register_node(basename, biogastanknodes, {

		on_push_item = function(pos, side, item)
			if item:get_name() == "tubelib_addons1:biogas" then
				local meta = minetest.get_meta(pos)
				local ret = tubelib.put_item(meta, "main", item)
				update_tank_node(pos)
				return ret
			end
			return false
		end,

		on_pull_item = function(pos, side)
			local meta = minetest.get_meta(pos)
			local ret = tubelib.get_item(meta, "main")
			update_tank_node(pos)
			return ret
		end,

		on_pull_stack = function(pos, side)
			local meta = minetest.get_meta(pos)
			local ret = tubelib.get_stack(meta, "main")
			update_tank_node(pos)
			return ret
		end,

		on_unpull_item = function(pos, side, item)
			local meta = minetest.get_meta(pos)
			local ret = tubelib.put_item(meta, "main", item)
			update_tank_node(pos)
			return ret
		end,

		on_recv_message = function(pos, topic, payload)
	                if topic == "state" then
				local meta = minetest.get_meta(pos)
				return tubelib.get_inv_state(meta, "main")
			else
				return "unsupported"
			end
		end,

	})
end

--[[
	--------
	Crafting
	--------
]]--

minetest.register_craft({
	output = "biogasmachines:tank_small",
	recipe = {
		{ "dye:green", "default:bronze_ingot", "default:steel_ingot" },
		{ "dye:yellow", "default:steelblock", "tubelib:tubeS" },
		{ "dye:red", "group:wood", "default:steel_ingot" },
	},
})

minetest.register_craft({
	output = "biogasmachines:tank_medium",
	recipe = {
		{ "default:bronze_ingot", "default:steelblock" },
		{ "default:steelblock", "biogasmachines:tank_small" },
	},
})

minetest.register_craft({
	output = "biogasmachines:tank_large",
	recipe = {
		{ "default:bronze_ingot", "default:steelblock" },
		{ "default:steelblock", "biogasmachines:tank_medium" },
	},
})
