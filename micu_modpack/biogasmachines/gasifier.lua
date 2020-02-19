--[[

	=======================================================================
	Tubelib Biogas Machines Mod
	by Micu (c) 2018, 2019

	Copyright (C) 2018, 2019 Michal Cieslakiewicz

	Gasifier is a machine designed to slowly extract Biogas from fossil
	fuels and other compressed dry organic materials.
	Basic recipe is conversion of Coal Block into Biogas (heavier leftover
	fractions form Biofuel).  Another default recipe is clean and complete
	transformation of Straw Block into some Biogas units.
	Custom recipes can be added via simple API function.

	Operational info:
	* machine requires no extra fuel
	* if there is nothing to process, machine enters standby mode; it
	  will automatically pick up work as soon as any valid item is loaded
	  into input (source) tray
	* if output tray is full and no new items can be put there, machine
	  changes state to blocked (special standby mode); it will resume
	  work as soon as there is space in output inventory
	* there is 1 tick gap between processing items to perform machinery
	  cleaning and reload working tray; this is a design choice
	* working tray can only be emptied when machine is stopped; this tray
	  is auto-loaded, source material should always go into input container
	* machine cannot be recovered unless input and output trays are all
	  empty
	* when active, due to high temperature inside, machine becomes a light
	  source of level 5

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

-- Biogas recipe table (key - source item name)
local biogas_recipes = {}
-- Biogas source table (indexed by numbers, used by formspec recipe hint bar)
local biogas_sources = {}
-- timing
local TIMER_TICK_SEC = 1		-- Node timer tick
local STANDBY_TICKS = 4			-- Standby mode timer frequency factor
local COUNTDOWN_TICKS = 4		-- Ticks to standby

-- machine inventory
local INV_H = 3				-- Inventory height (do not change)
local INV_IN_W = 2			-- Input inventory width
local INV_OUT_W = (6 - INV_IN_W)	-- Output inventory width

--[[
	----------------
	Public functions
	----------------
]]--

-- Add Biogas recipe
-- Returns true if recipe added successfully, false if error or already present
-- biogas_recipe = {
-- 	input = "itemstring",		-- source item, always 1 (req)
--	count = number,			-- biogas units produced (opt, def: 1)
--	time = number,			-- production time in ticks (req, max: 99)
--	extra = "itemstring" }		-- additional product (opt, def: nil)
function biogasmachines.add_gasifier_recipe(biogas_recipe)
	if not biogas_recipe then return false end
	if not biogas_recipe.input or not biogas_recipe.time or
	   biogas_recipe.time < 1 or biogas_recipe.time > 99 then
		return false
	end
	local input_item = ItemStack(biogas_recipe.input)
	if not input_item or input_item:get_count() > 1 then
		return false
	end
	local input_name = input_item:get_name()
	if not minetest.registered_items[input_name] then
		return false
	end
	if biogas_recipes[input_name] then return false end
	local extra_item = nil
	if biogas_recipe.extra then
		extra_item = ItemStack(biogas_recipe.extra)
		if not minetest.registered_items[extra_item:get_name()] then
			extra_item = nil
		end
	end
	local count = 1
	if biogas_recipe.count and biogas_recipe.count > 1 and
	   biogas_recipe.count < 100 then
		count = biogas_recipe.count
	end
	biogas_recipes[input_name] = {
		count = count,
		time = biogas_recipe.time,
		extra = extra_item,
	}
	biogas_sources[#biogas_sources + 1] = input_name
	if minetest.global_exists("unified_inventory") then
		unified_inventory.register_craft({
			type = "gasifier",
			items = { input_name .. " 1" },
			output = "tubelib_addons1:biogas " .. tostring(count),
		})
	end
	return true
end

--[[
	--------
	Formspec
	--------
]]--

-- static data for formspec
local fmxy = { inv_h = tostring(INV_H),
	inv_in_w = tostring(INV_IN_W),
	mid_x = tostring(INV_IN_W + 0.5),
	inv_out_w = tostring(INV_OUT_W),
	inv_out_x = tostring(INV_IN_W + 2),
}

-- get node/item/tool description for tooltip
local function formspec_tooltip(name)
	local def = minetest.registered_nodes[name] or
		minetest.registered_craftitems[name] or
		minetest.registered_items[name] or
		minetest.registered_tools[name] or nil
	return def and def.description or ""
end

-- recipe hint bar
local function formspec_recipe_hint_bar(recipe_idx)
	if #biogas_sources == 0 or recipe_idx > #biogas_sources then
		return ""
	end
	local input_item = biogas_sources[recipe_idx]
	local recipe = biogas_recipes[input_item]
	local extra_item = recipe.extra and recipe.extra:get_name() or ""
	return "item_image[0,0;1,1;" .. input_item .. "]" ..
	"label[0.5,3.25;Recipe]" ..
	"image_button[1.5,3.3;0.5,0.5;;left;<]" ..
	"label[2,3.25;" ..
		string.format("%2d / %2d", recipe_idx, #biogas_sources) .. "]" ..
	"image_button[2.8,3.3;0.5,0.5;;right;>]" ..
	"item_image[3.6,3.25;0.5,0.5;" .. input_item .. "]" ..
	"tooltip[3.6,3.25;0.5,0.5;" .. formspec_tooltip(input_item) .. "]" ..
	"image[4,3.25;0.5,0.5;tubelib_gui_arrow.png^[resize:16x16]" ..
	"label[4.4,3.25;" ..
		string.format("%2d sec", recipe.time * TIMER_TICK_SEC) .. "]" ..
	"image[5,3.25;0.5,0.5;tubelib_gui_arrow.png^[resize:16x16]" ..
	"item_image[5.5,3.25;0.5,0.5;tubelib_addons1:biogas]" ..
	"tooltip[5.5,3.25;0.5,0.5;Biogas]" ..
	"label[6,3.25;x " .. tostring(recipe.count) .. "]" ..
	(recipe.extra and "item_image[6.5,3.25;0.5,0.5;" .. extra_item .. "]" ..
		"tooltip[6.5,3.25;0.5,0.5;" .. formspec_tooltip(extra_item) .. "]" ..
		"label[7,3.25;x " ..  tostring(recipe.extra:get_count()) .. "]" or "")
end

-- formspec
local function formspec(self, pos, meta)
	local state = meta:get_int("tubelib_state")
	local recipe_idx = meta:get_int("recipe_idx")
	local item_name = meta:get_string("item_name")
	local item_ticks = meta:get_int("item_ticks")
        local item_pct = 0
        if item_name ~= "" and item_ticks >= 0 then
                local tot_ticks = biogas_recipes[item_name].time
                item_pct = 100 * (tot_ticks - item_ticks) / tot_ticks
	end
	return "size[8,8.25]" ..
	default.gui_bg ..
	default.gui_bg_img ..
	default.gui_slots ..
	"list[context;src;0,0;" .. fmxy.inv_in_w .. "," .. fmxy.inv_h .. ";]" ..
	"list[context;cur;" .. fmxy.mid_x .. ",0;1,1;]" ..
	"image[" .. fmxy.mid_x .. ",1;1,1;gui_furnace_arrow_bg.png^[lowpart:" ..
		tostring(item_pct) .. ":gui_furnace_arrow_fg.png^[transformR270]" ..
	"image_button[" .. fmxy.mid_x .. ",2;1,1;" ..
		self:get_state_button_image(meta) .. ";state_button;]" ..
	formspec_recipe_hint_bar(recipe_idx) ..
	"item_image[" .. fmxy.inv_out_x .. ",0;1,1;tubelib_addons1:biogas]" ..
	"list[context;dst;" .. fmxy.inv_out_x .. ",0;" .. fmxy.inv_out_w ..
		"," .. fmxy.inv_h .. ";]" ..
	"list[current_player;main;0,4;8,1;]" ..
	"list[current_player;main;0,5.25;8,3;8]" ..
	"listring[context;dst]" ..
	"listring[current_player;main]" ..
	"listring[context;src]" ..
	"listring[current_player;main]" ..
	(state == tubelib.RUNNING and
		"box[" .. fmxy.mid_x .. ",0;0.82,0.88;#9F3F1F]" or
		"listring[context;cur]listring[current_player;main]") ..
	default.get_hotbar_bg(0, 4)
end

--[[
	-------
	Helpers
	-------
]]--

-- check if item is valid biogas source (bool)
local function is_input_item(stack)
	local stackname = stack:get_name()
	return biogas_recipes[stackname] and true or false
end

-- get one source item (itemstack)
local function get_input_item(inv, listname)
	local stack = ItemStack({})
	for i, _ in pairs(biogas_recipes) do
		stack = inv:remove_item(listname, ItemStack(i .. " 1"))
		if not stack:is_empty() then break end
	end
	return stack
end

-- reset processing data
local function state_meta_reset(pos, meta)
	meta:set_int("item_ticks", -1)
	meta:set_string("item_name", "")
end

--[[
	-------------
	State machine
	-------------
]]--

local machine = tubelib.NodeStates:new({
	node_name_passive = "biogasmachines:gasifier",
	node_name_active = "biogasmachines:gasifier_active",
	node_name_defect = "biogasmachines:gasifier_defect",
	infotext_name = "Gasifier",
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
end

-- cleanup after digging
local function after_dig_node(pos, oldnode, oldmetadata, digger)
	tubelib.remove_node(pos)
end

-- init machine after placement
local function after_place_node(pos, placer, itemstack, pointed_thing)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	inv:set_size('src', INV_H * INV_IN_W)
	inv:set_size('cur', 1)
	inv:set_size('dst', INV_H * INV_OUT_W)
	meta:set_string("owner", placer:get_player_name())
	state_meta_reset(pos, meta)
	meta:set_int("recipe_idx", 1)
	local number = tubelib.add_node(pos, "biogasmachines:gasifier")
	machine:node_init(pos, number)
end

-- validate incoming items
local function allow_metadata_inventory_put(pos, listname, index, stack, player)
	if minetest.is_protected(pos, player:get_player_name()) then
		return 0
	end
	if listname == "src" then
		if is_input_item(stack) then
			return stack:get_count()
		else
			return 0
		end
	elseif listname == "cur" or listname == "dst" then
		return 0
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
	if machine:state_button_event(pos, fields) then
		return
	end
	if fields and (fields.left or fields.right) then
		local meta = minetest.get_meta(pos)
		local recipe_idx = meta:get_int("recipe_idx")
		if fields.left then
			recipe_idx = math.max(recipe_idx - 1, 1)
		end
		if fields.right then
			recipe_idx = math.min(recipe_idx + 1, #biogas_sources)
		end
		meta:set_int("recipe_idx", recipe_idx)
		meta:set_string("formspec", formspec(machine, pos, meta))
	end
end

-- tick-based item production
local function on_timer(pos, elapsed)
	local node = minetest.get_node(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local itemcnt = meta:get_int("item_ticks")
	local itemname = meta:get_string("item_name")
	if itemcnt < 0 or itemname == "" then
		-- idle and ready, check for something to work with
		if inv:is_empty("src") then
			-- no source item, count towards standby
			return countdown_to_halt(pos, meta, tubelib.STANDBY)
		end
		if machine:get_state(meta) == tubelib.STANDBY then
			-- something to do, wake up and re-entry
			machine:start(pos, meta, true)
			return false
		end
		-- choose item
		local prodtime = -1
		local inputname = nil
		if not inv:is_empty("cur") then
			-- leftover item, start from beginning
			local inp = inv:get_stack("cur", 1)
			inputname = inp:get_name()
			if not biogas_recipes[inputname] then
				machine_fault(pos, meta)	-- oops
				return false
			end
			prodtime = biogas_recipes[inputname].time
		else
			-- prepare item, next tick will start processing
			inv:set_list("dst_copy", inv:get_list("dst"))
			for i, r in pairs(biogas_recipes) do
				if inv:contains_item("src", ItemStack(i .. " 1")) then
					local outp0 = inv:add_item("dst_copy",
						ItemStack("tubelib_addons1:biogas " .. tostring(r.count)))
					local outp1 = r.extra and inv:add_item("dst_copy", r.extra) or
						ItemStack({})
					if outp0:is_empty() and outp1:is_empty() then
						inputname = i
						prodtime = r.time
						break
					end
				end
			end
			inv:set_size("dst_copy", 0)
			if not inputname then
				-- no space in output
				return countdown_to_halt(pos, meta, tubelib.BLOCKED)
			elseif machine:get_state(meta) == tubelib.BLOCKED then
				-- new free output slots, wake up and re-entry
				machine:start(pos, meta, true)
				return false
			end
			local inp = inv:remove_item("src", ItemStack(inputname .. " 1"))
			if inp:is_empty() then
				machine_fault(pos, meta)	-- oops
				return false
			end
			inv:add_item("cur", inp)
		end
		meta:set_string("item_name", inputname)
		meta:set_int("item_ticks", prodtime)
	else
		-- production
		if machine:get_state(meta) ~= tubelib.RUNNING then
			-- exception, should not happen - oops
			machine_fault(pos, meta)
			return false
		end
		-- add item tick
		itemcnt = itemcnt - 1
		local recipe = biogas_recipes[itemname]
		if itemcnt == 0 then
			inv:add_item("dst",
				ItemStack("tubelib_addons1:biogas " ..
				tostring(recipe.count)))
			if recipe.extra then
				inv:add_item("dst", recipe.extra)
			end
			inv:set_stack("cur", 1, ItemStack({}))
			state_meta_reset(pos, meta)
			-- item produced, increase aging
			machine:keep_running(pos, meta, COUNTDOWN_TICKS)
		else
			meta:set_int("item_ticks", itemcnt)
		end
	end
	meta:set_int("tubelib_countdown", COUNTDOWN_TICKS)
	meta:set_int("desired_state", tubelib.RUNNING)
	meta:set_string("formspec", formspec(machine, pos, meta))
	return true
end

--[[
	-----------------
	Node registration
	-----------------
]]--

minetest.register_node("biogasmachines:gasifier", {
	description = "Tubelib Gasifier",
	tiles = {
		-- up, down, right, left, back, front
		"biogasmachines_gasifier_top.png",
		"biogasmachines_bottom.png",
		"biogasmachines_gasifier_side.png",
		"biogasmachines_gasifier_side.png",
		"biogasmachines_gasifier_side.png",
		"biogasmachines_gasifier_side.png"
	},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{ -0.5, -0.5, -0.5, 0.5, 0.375, 0.5 },
			{ -0.375, 0.375, -0.375, 0.375, 0.5, 0.375 },
		},
        },
	selection_box = {
		type = "fixed",
		fixed = { -0.5, -0.5, -0.5, 0.5, 0.375, 0.5 },
	},

	paramtype = "light",
	sunlight_propagates = true,
	paramtype2 = "facedir",
	groups = { choppy = 2, cracky = 2, crumbly = 2 },
	is_ground_content = false,
	sounds = default.node_sound_metal_defaults(),

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

minetest.register_node("biogasmachines:gasifier_active", {
	description = "Tubelib Gasifier",
	tiles = {
		-- up, down, right, left, back, front
		{
			image = "biogasmachines_gasifier_active_top.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 32,
				aspect_h = 32,
				length = 4.0,
			},
		},
		"biogasmachines_bottom.png",
		"biogasmachines_gasifier_side.png",
		"biogasmachines_gasifier_side.png",
		"biogasmachines_gasifier_side.png",
		"biogasmachines_gasifier_side.png"
	},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{ -0.5, -0.5, -0.5, 0.5, 0.375, 0.5 },
			{ -0.375, 0.375, -0.375, 0.375, 0.5, 0.375 },
		},
        },
	selection_box = {
		type = "fixed",
		fixed = { -0.5, -0.5, -0.5, 0.5, 0.375, 0.5 },
	},

	paramtype = "light",
	sunlight_propagates = true,
	paramtype2 = "facedir",
	groups = { crumbly = 0, not_in_creative_inventory = 1 },
	is_ground_content = false,
	light_source = 5,
	sounds = default.node_sound_metal_defaults(),

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

minetest.register_node("biogasmachines:gasifier_defect", {
	description = "Tubelib Gasifier",
	tiles = {
		-- up, down, right, left, back, front
		"biogasmachines_gasifier_top.png",
		"biogasmachines_bottom.png",
		"biogasmachines_gasifier_side.png^tubelib_defect.png",
		"biogasmachines_gasifier_side.png^tubelib_defect.png",
		"biogasmachines_gasifier_side.png^tubelib_defect.png",
		"biogasmachines_gasifier_side.png^tubelib_defect.png"
	},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{ -0.5, -0.5, -0.5, 0.5, 0.375, 0.5 },
			{ -0.375, 0.375, -0.375, 0.375, 0.5, 0.375 },
		},
        },
	selection_box = {
		type = "fixed",
		fixed = { -0.5, -0.5, -0.5, 0.5, 0.375, 0.5 },
	},

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
	allow_metadata_inventory_move = allow_metadata_inventory_move,
	allow_metadata_inventory_take = allow_metadata_inventory_take,

	after_place_node = function(pos, placer, itemstack, pointed_thing)
		after_place_node(pos, placer, itemstack, pointed_thing)
		machine:defect(pos, minetest.get_meta(pos))
	end,
})

tubelib.register_node("biogasmachines:gasifier",
	{ "biogasmachines:gasifier_active", "biogasmachines:gasifier_defect" }, {

	on_push_item = function(pos, side, item)
		local meta = minetest.get_meta(pos)
		if is_input_item(item) then
			return tubelib.put_item(meta, "src", item)
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
	output = "biogasmachines:gasifier",
	recipe = {
		{ "default:steelblock", "default:glass", "default:steelblock" },
		{ "default:mese_crystal", "default:gold_ingot", "tubelib:tubeS" },
		{ "group:wood", "default:gold_ingot", "group:wood" },
	},
})

--[[
	-------
	Recipes
	-------
]]--

-- Unified Inventory hints
if minetest.global_exists("unified_inventory") then
	unified_inventory.register_craft_type("gasifier", {
		description = "Gasifier",
		icon = 'biogasmachines_gasifier_top.png',
		width = 1,
		height = 1,
	})
end

-- default recipes
biogasmachines.add_gasifier_recipe({
	input = "default:coalblock",
	count = 9,
	time = 12,
	extra = "default:gravel 1",
})

biogasmachines.add_gasifier_recipe({
	input = "farming:straw",
	count = 2,
	time = 8,
})
