--[[

	=======================================================================
	Tubelib Biogas Machines Mod
	by Micu (c) 2018, 2019

	Copyright (C) 2018, 2019 Michal Cieslakiewicz

	Freezer - Biogas-powered machine that converts water to ice
	(technically Biogas is a coolant here, not fuel, however it
	is 'used' in the same way). Device changes water in bucket
	to ice and empty bucket. If pipeworks mod is installed and pipe
	with water is connected to device, in absence of water buckets
	it produces ice from water supplied via pipes at the same rate.
	Device automatically shuts off when there is nothing to freeze,
	so Biogas is not wasted. However when machine is powered off via
	button while item is being frozen, Biogas used to partially cool
	down water is lost.
	Internal water valve works only when device runs, so in off state
	water pipe detector is also off. This is a design feature to save
	CPU resources for inactive machine (timer is stopped).

	Operational info:
	* machine checks for buckets with water first and if there are none
	  tries to take water from pipeline
	* if there is nothing to freeze and Biogas tank is empty, machine
	  switches off automatically
	* when coolant ends, machine enters fault mode and has to be
	  manually powered on again after refilling Biogas
	* if there is nothing to freeze but there is still Biogas in tank,
	  machine enters standby mode; it will automatically pick up work
	  as soon as any water source becomes available again
	* if output tray is full and no new items can be put there, machine
	  changes state to blocked (special standby mode); it will resume
	  work as soon as there is space in output inventory
	* there is 1 tick gap between items to unload ice and load internal
	  water tank or freezing tray; this a design choice to make timer
	  callback run faster
	* Biogas is used only when device actually freezes
	* partially frozen items (due to work being interrupted by on/off
	  switch) have to be frozen again from beginning, Biogas used for
	  such partial freeze is not recoverable
	* bucket freezing tray cannot be emptied manually when machine is
	  running, stop the device to take water bucket; please note that
	  tray cannot be loaded manually, please use input inventory
	* when using pipes, internal water tank is filled completely before
	  process starts; shutting down water source during freezing does
	  not stop it
	* machine cannot be recovered unless input, output and fuel trays
	  are all empty

	Tubelib v2 implementation info:
	* device updates itself every tick, so cycle_time must be set to 1
	  even though production takes longer (start method sets timer to
	  this value)
	* keep_running function is called every time item is produced
	  (not every processing tick - function does not accept neither 0
	  nor fractional values for num_items parameter)
	* desired_state metadata allows to properly change non-running target
	  state during transition; when new state differs from old one, timer
	  is reset so it is guaranteed that each countdown starts from
	  COUNTDOWN_TICKS
	* num_items in keep_running method is set to 1 (default value);
	  machine aging is controlled by aging_factor solely; tubelib item
	  counter is used to count production iterations not actual items

	License: LGPLv2.1+
	=======================================================================
	
]]--

--[[
	---------
	Variables
	---------
]]--

-- timing
local BIOGAS_TICKS = 24			-- Biogas work time
local ICE_TICKS = 4			-- Ice creation time
local TIMER_TICK_SEC = 1		-- Node timer tick
local STANDBY_TICKS = 4			-- Standby mode timer frequency factor
local COUNTDOWN_TICKS = 4		-- Ticks to standby
-- machine inventory
local INV_H = 3				-- Inventory height
local INV_IN_W = 4			-- Input inventory width
local INV_OUT_W = (6 - INV_IN_W)	-- Output inventory width
-- item processed
local SOURCE_EMPTY = 0
local SOURCE_BUCKET = 1
local SOURCE_PIPE = 2
-- water sources
local water_bucket = { ["bucket:bucket_water"] = true,
		       ["bucket:bucket_river_water"] = true }

--[[
	--------
	Formspec
	--------
]]--

-- static data for formspec
local fmxy = {
	inv_h = tostring(INV_H),
        inv_in_w = tostring(INV_IN_W),
        mid_x = tostring(INV_IN_W + 1),
        inv_out_w = tostring(INV_OUT_W),
        inv_out_x = tostring(INV_IN_W + 2),
	biogas_time = tostring(BIOGAS_TICKS * TIMER_TICK_SEC),
	ice_time = tostring(ICE_TICKS * TIMER_TICK_SEC),
	ice_qty = tostring(BIOGAS_TICKS / ICE_TICKS)
}

-- formspec
local function formspec(self, pos, meta)
	local state = meta:get_int("tubelib_state")
	local source = meta:get_int("source")
	local fuel_pct = tostring(100 * meta:get_int("fuel_ticks") / BIOGAS_TICKS)
	local item_pct = tostring(100 * (ICE_TICKS - meta:get_int("item_ticks")) / ICE_TICKS)
	return "size[8,8.25]" ..
	default.gui_bg ..
	default.gui_bg_img ..
	default.gui_slots ..
	"list[context;src;0,0;" .. fmxy.inv_in_w .. "," .. fmxy.inv_h .. ";]" ..
	"item_image[0,0;1,1;bucket:bucket_water]" ..
	"list[context;cur;" .. fmxy.inv_in_w .. ",0;1,1;]" ..
	"image[" .. fmxy.mid_x .. ",0;1,1;biogasmachines_freezer_pipe_inv_" ..
		(source == SOURCE_PIPE and "fg" or "bg") .. ".png]" ..
	"image[" .. fmxy.inv_in_w ..
		",1;1,1;biogasmachines_freezer_inv_bg.png^[lowpart:" ..
		fuel_pct .. ":biogasmachines_freezer_inv_fg.png]" ..
	"image[" .. fmxy.mid_x .. ",1;1,1;gui_furnace_arrow_bg.png^[lowpart:" ..
		item_pct .. ":gui_furnace_arrow_fg.png^[transformR270]" ..
	"list[context;fuel;" .. fmxy.inv_in_w .. ",2;1,1;]" ..
	"item_image[" .. fmxy.inv_in_w .. ",2;1,1;tubelib_addons1:biogas]" ..
	"image_button[" .. fmxy.mid_x .. ",2;1,1;" ..
		self:get_state_button_image(meta) .. ";state_button;]" ..
	"item_image[1,3.25;0.5,0.5;tubelib_addons1:biogas]" ..
	"tooltip[1,3.25;0.5,0.5;Biogas]" ..
	"label[1.5,3.25;= " .. fmxy.biogas_time .. " sec]" ..
	"item_image[3,3.25;0.5,0.5;default:ice]" ..
	"tooltip[3,3.25;0.5,0.5;Ice]" ..
	"label[3.5,3.25;= " .. fmxy.ice_time .. " sec]" ..
	"item_image[5.25,3.25;0.5,0.5;tubelib_addons1:biogas]" ..
	"tooltip[5.25,3.25;0.5,0.5;Biogas]" ..
	"image[5.75,3.25;0.5,0.5;tubelib_gui_arrow.png^[resize:16x16]" ..
	"item_image[6.25,3.25;0.5,0.5;default:ice]" ..
	"tooltip[6.25,3.25;0.5,0.5;Ice]" ..
	"label[6.75,3.25;x " .. fmxy.ice_qty .. "]" ..
	"item_image[" .. fmxy.inv_out_x .. ",0;1,1;default:ice]" ..
	"list[context;dst;" .. fmxy.inv_out_x .. ",0;" .. fmxy.inv_out_w ..
		"," .. fmxy.inv_h .. ";]" ..
	"list[current_player;main;0,4;8,1;]" ..
	"list[current_player;main;0,5.25;8,3;8]" ..
	"listring[context;dst]" ..
	"listring[current_player;main]" ..
	"listring[context;src]" ..
	"listring[current_player;main]" ..
	"listring[context;fuel]" ..
	"listring[current_player;main]" ..
	(state == tubelib.RUNNING and source ~= SOURCE_PIPE and
                "box[" .. fmxy.inv_in_w .. ",0;0.82,0.88;#2F4FBF]" or
                "listring[context;cur]listring[current_player;main]") ..
	default.get_hotbar_bg(0, 4)
end

--[[
	-------
	Helpers
	-------
]]--

-- get bucket with water (itemstack)
local function get_water_bucket(inv, listname)
	local stack = ItemStack({})
	for i, _ in pairs(water_bucket) do
		stack = inv:remove_item(listname, ItemStack(i .. " 1"))
		if not stack:is_empty() then break end
	end
	return stack
end

-- reset processing data
local function state_meta_reset(pos, meta)
	meta:set_int("source", SOURCE_EMPTY)
	meta:set_int("item_ticks", ICE_TICKS)
end

--[[
	-------------
	State machine
	-------------
]]--

local machine = tubelib.NodeStates:new({
	node_name_passive = "biogasmachines:freezer",
	node_name_active = "biogasmachines:freezer_active",
	node_name_defect = "biogasmachines:freezer_defect",
	infotext_name = "Water Freezer",
	cycle_time = TIMER_TICK_SEC,
	standby_ticks = STANDBY_TICKS,
	has_item_meter = true,
	aging_factor = 8,
	on_start = function(pos, meta, oldstate)
		meta:set_int("desired_state", tubelib.RUNNING)
		state_meta_reset(pos, meta)
	end,
	on_stop = function(pos, meta, oldstate)
		meta:set_int("desired_state", tubelib.STOPPED)
		state_meta_reset(pos, meta)
	end,
	formspec_func = formspec,
})

-- fault function for convenience as there is no on_fault method (yet)
local function machine_fault(pos, meta)
	meta:set_int("desired_state", tubelib.FAULT)
	state_meta_reset(pos, meta)
	machine:fault(pos, meta)
end

-- customized version of NodeStates:idle()
local function countdown_to_halt(pos, meta, target_state)
	if target_state ~= tubelib.STANDBY and
	   target_state ~= tubelib.BLOCKED and
	   target_state ~= tubelib.STOPPED and
	   target_state ~= tubelib.FAULT then
		return true
	end
	if machine:get_state(meta) == tubelib.RUNNING and
	   meta:get_int("desired_state") ~= target_state then
		meta:set_int("tubelib_countdown", COUNTDOWN_TICKS)
		meta:set_int("desired_state", target_state)
	end
	local countdown = meta:get_int("tubelib_countdown") - 1
	if countdown >= -1 then
		-- we don't need anything less than -1
		meta:set_int("tubelib_countdown", countdown)
	end
	if countdown < 0 then
		if machine:get_state(meta) == target_state then
			return true
		end
		meta:set_int("desired_state", target_state)
		-- workaround for switching between non-running states
		meta:set_int("tubelib_state", tubelib.RUNNING)
		if target_state == tubelib.FAULT then
			machine_fault(pos, meta)
		elseif target_state == tubelib.STOPPED then
			machine:stop(pos, meta)
		elseif target_state == tubelib.BLOCKED then
			machine:blocked(pos, meta)
		else
			machine:standby(pos, meta)
		end
		return false
	end
	return true
end

-- countdown to one of two states depending on fuel availability
local function fuel_countdown_to_halt(pos, meta, target_state_fuel, target_state_empty)
	local inv = meta:get_inventory()
	if meta:get_int("fuel_ticks") == 0 and inv:is_empty("fuel") then
		return countdown_to_halt(pos, meta, target_state_empty)
	else
		return countdown_to_halt(pos, meta, target_state_fuel)
	end
end

--[[
	---------
	Callbacks
	---------
]]--

-- do not allow to dig protected or non-empty machine
local function can_dig(pos, player)
	if minetest.is_protected(pos, player:get_player_name()) then
		return false
	end
	local meta = minetest.get_meta(pos);
	local inv = meta:get_inventory()
	return inv:is_empty("src") and inv:is_empty("dst")
		and inv:is_empty("fuel")
end

-- cleanup after digging
local function after_dig_node(pos, oldnode, oldmetadata, digger)
	tubelib.remove_node(pos)
	if minetest.global_exists("pipeworks") then
		pipeworks.scan_for_pipe_objects(pos)
	end
end

-- init machine after placement
local function after_place_node(pos, placer, itemstack, pointed_thing)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	inv:set_size('src', INV_H * INV_IN_W)
	inv:set_size('cur', 1)
	inv:set_size('fuel', 1)
	inv:set_size('dst', INV_H * INV_OUT_W)
	meta:set_string("owner", placer:get_player_name())
	meta:set_int("fuel_ticks", 0)
	state_meta_reset(pos, meta)
	local number = tubelib.add_node(pos, "biogasmachines:freezer")
	machine:node_init(pos, number)
	if minetest.global_exists("pipeworks") then
		pipeworks.scan_for_pipe_objects(pos)
	end
end

-- validate incoming items
local function allow_metadata_inventory_put(pos, listname, index, stack, player)
	if minetest.is_protected(pos, player:get_player_name()) then
		return 0
	end
	if listname == "src" then
		if water_bucket[stack:get_name()] then
			return stack:get_count()
		else
			return 0
		end
	elseif listname == "cur" or listname == "dst" then
		return 0
	elseif listname == "fuel" then
		if stack:get_name() == "tubelib_addons1:biogas" then
			return stack:get_count()
		else
			return 0
		end
	end
	return 0
end

-- validate items move
local function allow_metadata_inventory_move(pos, from_list, from_index, to_list, to_index, count, player)
	local meta = minetest.get_meta(pos)
	if to_list == "cur" or
	   (from_list == "cur" and machine:get_state(meta) == tubelib.RUNNING) then
                return 0
        end
	local inv = meta:get_inventory()
	local stack = inv:get_stack(from_list, from_index)
	return allow_metadata_inventory_put(pos, to_list, to_index, stack, player)
end

-- validate items retrieval
local function allow_metadata_inventory_take(pos, listname, index, stack, player)
	if minetest.is_protected(pos, player:get_player_name()) then
		return 0
	end
	if listname == "cur" then
		local meta = minetest.get_meta(pos)
		if machine:get_state(meta) == tubelib.RUNNING then
			return 0
		end
	end
	return stack:get_count()
end

-- formspec callback
local function on_receive_fields(pos, formname, fields, player)
	if minetest.is_protected(pos, player:get_player_name()) then
		return
	end
	machine:state_button_event(pos, fields)
end

-- tick-based item production
local function on_timer(pos, elapsed)
	local node = minetest.get_node(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local number = meta:get_string("tubelib_number")
	local source = meta:get_int("source")
	local fuel = meta:get_int("fuel_ticks")
	local pipe = source == SOURCE_PIPE
	if source == SOURCE_EMPTY then
		-- try to start freezing bucket or water from pipe
		pipe = biogasmachines.is_pipe_with_water(pos, node)
		local output = { ItemStack("default:ice 1") }
		if not inv:is_empty("cur") or not inv:is_empty("src") then
			-- source: water bucket
			source = SOURCE_BUCKET
			pipe = false
			output[#output + 1] = ItemStack("bucket:bucket_empty 1")
		elseif pipe then
			-- source: water pipe
			source = SOURCE_PIPE
		else
			-- no source, count towards standby/stop
			return fuel_countdown_to_halt(pos, meta,
				tubelib.STANDBY, tubelib.STOPPED)
		end
		if machine:get_state(meta) == tubelib.STANDBY then
			-- something to do, wake up and re-entry
			machine:start(pos, meta, true)
			return false
		end
		if inv:is_empty("cur") then
			-- check if there is space in output
			inv:set_list("dst_copy", inv:get_list("dst"))
			local is_dst_ok = true
			for _, stack in ipairs(output) do
				local outp = inv:add_item("dst_copy", stack)
				if not outp:is_empty() then
					is_dst_ok = false
					break
				end
			end
			inv:set_size("dst_copy", 0)
			if not is_dst_ok then
				return fuel_countdown_to_halt(pos, meta,
					tubelib.BLOCKED, tubelib.FAULT)
			end
			if machine:get_state(meta) == tubelib.BLOCKED then
				-- new free output slots, wake up and re-entry
				machine:start(pos, meta, true)
				return false
			end
			-- process another water unit
			if fuel == 0 and inv:is_empty("fuel") then
				return countdown_to_halt(pos, meta, tubelib.FAULT)
			end
			if source == SOURCE_BUCKET then
				local inp = get_water_bucket(inv, "src")
				if inp:is_empty() then
					machine_fault(pos, meta)	-- oops
					return false
				end
				inv:add_item("cur", inp)
			end
		elseif fuel == 0 and inv:is_empty("fuel") then
			return countdown_to_halt(pos, meta, tubelib.FAULT)
		end
		meta:set_int("source", source)
		meta:set_int("item_ticks", ICE_TICKS)
	else
		-- continue freezing process
		if machine:get_state(meta) ~= tubelib.RUNNING then
			-- exception, should not happen - oops
			machine_fault(pos, meta)
			return false
		end
		-- add item tick
		if fuel == 0 and inv:is_empty("fuel") then
			return countdown_to_halt(pos, meta, tubelib.FAULT)
		end
		local itemcnt = meta:get_int("item_ticks") - 1
		if itemcnt == 0 then
			inv:add_item("dst", ItemStack("default:ice 1"))
			if source == SOURCE_BUCKET then
				inv:set_stack("cur", 1, ItemStack({}))
				inv:add_item("dst", ItemStack("bucket:bucket_empty 1"))
			end
			state_meta_reset(pos, meta)
			-- item produced, increase aging
			machine:keep_running(pos, meta, COUNTDOWN_TICKS)
		else
			meta:set_int("item_ticks", itemcnt)
		end
		-- consume fuel tick
		if fuel == 0 then
			if not inv:is_empty("fuel") then
					inv:remove_item("fuel",
					ItemStack("tubelib_addons1:biogas 1"))
				fuel = BIOGAS_TICKS
			else
				machine_fault(pos, meta)	-- oops
				return false
			end
		end
		meta:set_int("fuel_ticks", fuel - 1)
	end
	meta:set_int("tubelib_countdown", COUNTDOWN_TICKS)
	meta:set_int("desired_state", tubelib.RUNNING)
	meta:set_string("infotext", "Water Freezer " .. number .. ": running (water " ..
		(pipe and "from pipe" or "in buckets") .. ")")
	meta:set_string("formspec", formspec(machine, pos, meta))
	return true
end

--[[
	-----------------
	Node registration
	-----------------
]]--

minetest.register_node("biogasmachines:freezer", {
	description = "Tubelib Water Freezer",
	tiles = {
		-- up, down, right, left, back, front
		"biogasmachines_freezer_top.png",
		"biogasmachines_freezer_bottom.png",
		"biogasmachines_freezer_side.png",
		"biogasmachines_freezer_side.png",
		"biogasmachines_freezer_side.png",
		"biogasmachines_freezer_side.png"
	},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{ -0.5, -0.375, -0.5, 0.5, 0.5, 0.5 },
			{ -0.5, -0.5, -0.5, -0.375, -0.375, -0.375 },
			{ 0.375, -0.5, -0.5, 0.5, -0.375, -0.375 },
			{ 0.375, -0.5, 0.375, 0.5, -0.375, 0.5 },
			{ -0.5, -0.5, 0.375, -0.375, -0.375, 0.5 },
		}
	},
	selection_box = {
		type = "fixed",
		fixed = { -0.5, -0.5, -0.5, 0.5, 0.5, 0.5 },
	},

	paramtype = "light",
	sunlight_propagates = true,
	paramtype2 = "facedir",
	groups = { choppy = 2, cracky = 2, crumbly = 2 },
	is_ground_content = false,
	sounds = default.node_sound_metal_defaults(),

	pipe_connections = { top = 1,
			     bottom = 1,
			     front = 1,
			     back = 1,
			     left = 1,
			     right = 1 },
	
	drop = "",
	can_dig = can_dig,

	after_dig_node = function(pos, oldnode, oldmetadata, digger)
		machine:after_dig_node(pos, oldnode, oldmetadata, digger)
		after_dig_node(pos, oldnode, oldmetadata, digger)
	end,

	on_rotate = screwdriver.disallow,
	on_timer = on_timer,
	on_receive_fields = on_receive_fields,
	allow_metadata_inventory_put = allow_metadata_inventory_put,
	allow_metadata_inventory_move = allow_metadata_inventory_move,
	allow_metadata_inventory_take = allow_metadata_inventory_take,
	after_place_node = after_place_node,
})

minetest.register_node("biogasmachines:freezer_active", {
	description = "Tubelib Water Freezer",
	tiles = {
		-- up, down, right, left, back, front
		{
			image = "biogasmachines_freezer_active_top.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 32,
				aspect_h = 32,
				length = 4.0,
			},
		},
		"biogasmachines_freezer_bottom.png",
		"biogasmachines_freezer_side.png",
		"biogasmachines_freezer_side.png",
		"biogasmachines_freezer_side.png",
		"biogasmachines_freezer_side.png"
	},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{ -0.5, -0.375, -0.5, 0.5, 0.5, 0.5 },
			{ -0.5, -0.5, -0.5, -0.375, -0.375, -0.375 },
			{ 0.375, -0.5, -0.5, 0.5, -0.375, -0.375 },
			{ 0.375, -0.5, 0.375, 0.5, -0.375, 0.5 },
			{ -0.5, -0.5, 0.375, -0.375, -0.375, 0.5 },
		}
	},
	selection_box = {
		type = "fixed",
		fixed = { -0.5, -0.5, -0.5, 0.5, 0.5, 0.5 },
	},

	paramtype = "light",
	sunlight_propagates = true,
	paramtype2 = "facedir",
	groups = { crumbly = 0, not_in_creative_inventory = 1 },
	is_ground_content = false,
	sounds = default.node_sound_metal_defaults(),

	pipe_connections = { top = 1,
			     bottom = 1,
			     front = 1,
			     back = 1,
			     left = 1,
			     right = 1 },

	drop = "",
	can_dig = can_dig,

	after_dig_node = function(pos, oldnode, oldmetadata, digger)
		machine:after_dig_node(pos, oldnode, oldmetadata, digger)
		after_dig_node(pos, oldnode, oldmetadata, digger)
	end,

	on_rotate = screwdriver.disallow,
	on_timer = on_timer,
	on_receive_fields = on_receive_fields,
	allow_metadata_inventory_put = allow_metadata_inventory_put,
	allow_metadata_inventory_move = allow_metadata_inventory_move,
	allow_metadata_inventory_take = allow_metadata_inventory_take,
})

minetest.register_node("biogasmachines:freezer_defect", {
	description = "Tubelib Water Freezer",
	tiles = {
		-- up, down, right, left, back, front
		"biogasmachines_freezer_top.png",
		"biogasmachines_freezer_bottom.png",
		"biogasmachines_freezer_side.png^tubelib_defect.png",
		"biogasmachines_freezer_side.png^tubelib_defect.png",
		"biogasmachines_freezer_side.png^tubelib_defect.png",
		"biogasmachines_freezer_side.png^tubelib_defect.png"
	},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{ -0.5, -0.375, -0.5, 0.5, 0.5, 0.5 },
			{ -0.5, -0.5, -0.5, -0.375, -0.375, -0.375 },
			{ 0.375, -0.5, -0.5, 0.5, -0.375, -0.375 },
			{ 0.375, -0.5, 0.375, 0.5, -0.375, 0.5 },
			{ -0.5, -0.5, 0.375, -0.375, -0.375, 0.5 },
		}
	},
	selection_box = {
		type = "fixed",
		fixed = { -0.5, -0.5, -0.5, 0.5, 0.5, 0.5 },
	},

	paramtype = "light",
	sunlight_propagates = true,
	paramtype2 = "facedir",
	groups = { choppy = 2, cracky = 2, crumbly = 2, not_in_creative_inventory = 1 },
	is_ground_content = false,
	sounds = default.node_sound_metal_defaults(),

	pipe_connections = { top = 1,
			     bottom = 1,
			     front = 1,
			     back = 1,
			     left = 1,
			     right = 1 },
	
	can_dig = can_dig,
	after_dig_node = after_dig_node,
	on_rotate = screwdriver.disallow,
	allow_metadata_inventory_put = allow_metadata_inventory_put,
	allow_metadata_inventory_move = allow_metadata_inventory_move,
	allow_metadata_inventory_take = allow_metadata_inventory_take,

	after_place_node = function(pos, placer, itemstack, pointed_thing)
		after_place_node(pos, placer, itemstack, pointed_thing)
		machine:defect(pos, minetest.get_meta(pos))
	end,
})

tubelib.register_node("biogasmachines:freezer",
	{ "biogasmachines:freezer_active", "biogasmachines:freezer_defect" }, {

	on_push_item = function(pos, side, item)
		local meta = minetest.get_meta(pos)
		if water_bucket[item:get_name()] then
			return tubelib.put_item(meta, "src", item)
		elseif item:get_name() == "tubelib_addons1:biogas" then
			return tubelib.put_item(meta, "fuel", item)
		end
		return false
	end,

	on_pull_item = function(pos, side)
		local meta = minetest.get_meta(pos)
		return tubelib.get_item(meta, "dst")
	end,

	on_unpull_item = function(pos, side, item)
		local meta = minetest.get_meta(pos)
		return tubelib.put_item(meta, "dst", item)
	end,

	on_recv_message = function(pos, topic, payload)
		local meta = minetest.get_meta(pos)
		if topic == "fuel" then
			return tubelib.fuelstate(meta, "fuel")
		end
		local resp = machine:on_receive_message(pos, topic, payload)
		if resp then
			return resp
		else
			return "unsupported"
		end
	end,

	on_node_load = function(pos)
		machine:on_node_load(pos)
	end,

	on_node_repair = function(pos)
		return machine:on_node_repair(pos)
	end,
})

--[[
	--------
	Crafting
	--------
]]--

minetest.register_craft({
	output = "biogasmachines:freezer",
	recipe = {
		{ "default:steelblock", "default:glass", "default:steelblock" },
		{ "default:mese_crystal", "bucket:bucket_empty", "tubelib:tubeS" },
		{ "group:wood", "default:copper_ingot", "group:wood" },
	},
})

if minetest.global_exists("unified_inventory") then
	unified_inventory.register_craft_type("freezing", {
		description = "Freezing",
		icon = 'biogasmachines_freezer_inv_fg.png',
		width = 1,
		height = 1,
	})
	for i, _ in pairs(water_bucket) do
		unified_inventory.register_craft({
			type = "freezing",
			items = { i },
			output = "default:ice",
		})
	end
end
