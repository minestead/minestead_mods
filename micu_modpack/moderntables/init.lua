--[[

	=======================================================================
	Modern Tables Mod
	by Micu (c) 2018

	Copyright (C) 2018 Michal Cieslakiewicz

	This mod contains full height tables:
	* simple wooden
	* simple metal
	* wooden with drawer
	* metal with drawer
	* (optional) Tubelib-style tables and machinery legs

	Drawer is a simple inventory 8x2.
	Table drawer is accessible to all players. Storage table cannot be
	destroyed until it is empty.

	License: LGPLv2.1+
	Media: CC BY-SA
	=======================================================================

]]--

--[[
        ---------
        Variables
        ---------
]]--

moderntables = {}

local table_nodebox = {
	{ -0.5, 0.375, -0.5, 0.5, 0.5, 0.5 },
	{ -0.5, -0.5, -0.5, -0.375, 0.375, -0.375 },
	{ 0.375, -0.5, -0.5, 0.5, 0.375, -0.375 },
	{ 0.375, -0.5, 0.375, 0.5, 0.375, 0.5 },
	{ -0.5, -0.5, 0.375, -0.375, 0.375, 0.5 },
}

local table_drawer_nodebox = {
	{ -0.5, 0.375, -0.5, 0.5, 0.5, 0.5 },
	{ -0.5, -0.5, -0.5, -0.375, 0.375, -0.375 },
	{ 0.375, -0.5, -0.5, 0.5, 0.375, -0.375 },
	{ 0.375, -0.5, 0.375, 0.5, 0.375, 0.5 },
	{ -0.5, -0.5, 0.375, -0.375, 0.375, 0.5 },
	{ -0.5, 0.125, -0.4375, 0.5, 0.375, 0.5 },
	{ -0.5, 0, -0.5, 0.5, 0.125, 0.5 },
}

local inv_formspec = "size[8,8]" ..
	default.gui_bg ..
	default.gui_bg_img ..
	default.gui_slots ..
	"list[context;inv;0,0.5;8,2;]" ..
	"list[current_player;main;0,3.5;8,1;]" ..
	"list[current_player;main;0,4.75;8,3;8]" ..
	"listring[context;inv]" ..
	"listring[current_player;main]" ..
	default.get_hotbar_bg(0, 3.5)

--[[
        ---------
        Callbacks
        ---------
]]--

-- do not allow to dig table with non-empty drawer
local function can_dig(pos, player)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	return inv:is_empty("inv")
end

-- init storage metadata
local function after_place_node(pos, placer, itemstack, pointed_thing)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	inv:set_size('inv', 8 * 2)
	meta:set_string("formspec", inv_formspec)
end

--[[
        -------
        Helpers
        -------
]]--

-- Simple wooden tables:
-- subname (string) is one of: acacia_wood, aspen_wood,
-- junglewood, pine_wood, wood
local function register_simple_wood_table(subname, description)
	local fullname = "moderntables:simple_table_" .. subname
	minetest.register_node(fullname, {
		description = description,
		tiles = { "default_" .. subname .. ".png", },
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = table_nodebox,
		},
		selection_box = {
			type = "fixed",
			fixed = { -0.5, -0.5, -0.5,   0.5, 0.5, 0.5 },
		},
		paramtype = "light",
        	paramtype2 = "facedir",
        	place_param2 = 0,
        	is_ground_content = false,
        	groups = { choppy = 2, oddly_breakable_by_hand = 2,
			flammable = 2, },
        	sounds = default.node_sound_wood_defaults(),
		on_rotate = screwdriver.disallow,
	})
	local slabitem = "stairs:slab_" .. subname
	local wooditem = "default:" .. subname
	minetest.register_craft({
		output = fullname,
		recipe = {
			{ slabitem, slabitem, slabitem },
			{ wooditem, "", wooditem },
			{ wooditem, "", wooditem },
		},
	})
end

-- Storage wooden tables:
-- subname (string) is one of: acacia_wood, aspen_wood,
-- junglewood, pine_wood, wood
local function register_storage_wood_table(subname, description)
	local fullname = "moderntables:storage_table_" .. subname
	minetest.register_node(fullname, {
		description = description,
		tiles = {
			-- up, down, right, left, back, front
			"default_" .. subname .. ".png",
			"default_" .. subname .. ".png",
			"default_" .. subname .. ".png",
			"default_" .. subname .. ".png",
			"default_" .. subname .. ".png",
			"default_" .. subname .. ".png^moderntables_drawer_handle.png",
		},
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = table_drawer_nodebox,
		},
		selection_box = {
			type = "fixed",
			fixed = { -0.5, -0.5, -0.5,   0.5, 0.5, 0.5 },
		},
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		groups = { choppy = 2, oddly_breakable_by_hand = 2,
			flammable = 2, },
		sounds = default.node_sound_wood_defaults(),
		formspec = inv_formspec,
		on_rotate = screwdriver.rotate_simple,
		can_dig = can_dig,
		after_place_node = after_place_node,
	})
	local slabitem = "stairs:slab_" .. subname
	local wooditem = "default:" .. subname
	minetest.register_craft({
		output = fullname,
		recipe = {
			{ slabitem, slabitem, slabitem },
			{ wooditem, "default:chest", wooditem },
			{ wooditem, "", wooditem },
		},
	})
	minetest.register_craft({
		output = fullname,
		type = "shapeless",
		recipe = { "moderntables:simple_table_" .. subname,
			"default:chest" },
	})
end

-- Simple metal tables:
-- subname (string) is one of: bronze, tin, copper, steel, gold
local function register_simple_metal_table(subname, description)
	local fullname = "moderntables:simple_table_" .. subname
	minetest.register_node(fullname, {
		description = description,
		tiles = {
			-- up, down, right, left, back, front
			"moderntables_" .. subname .. "_top.png",
			"moderntables_" .. subname .. "_top.png",
			"moderntables_" .. subname .. "_side.png",
			"moderntables_" .. subname .. "_side.png",
			"moderntables_" .. subname .. "_side.png",
			"moderntables_" .. subname .. "_side.png",
		},
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = table_nodebox,
		},
		selection_box = {
			type = "fixed",
			fixed = { -0.5, -0.5, -0.5,   0.5, 0.5, 0.5 },
		},
		paramtype = "light",
		paramtype2 = "facedir",
		place_param2 = 0,
		is_ground_content = false,
		groups = { choppy = 2, cracky = 2, crumbly = 2,
			oddly_breakable_by_hand = 2, },
		sounds = default.node_sound_metal_defaults(),
		on_rotate = screwdriver.disallow,
	})
	local ingotitem = "default:" .. subname .. "_ingot"
	minetest.register_craft({
		output = fullname,
		recipe = {
			{ ingotitem, "group:wood", ingotitem },
			{ ingotitem, "", ingotitem },
			{ ingotitem, "", ingotitem },
		},
	})
end

-- Storage metal tables:
-- subname (string) is one of: bronze, tin, copper, steel, gold
local function register_storage_metal_table(subname, description)
	local fullname = "moderntables:storage_table_" .. subname
	minetest.register_node(fullname, {
		description = description,
		tiles = {
			-- up, down, right, left, back, front
			"moderntables_" .. subname .. "_top.png",
			"moderntables_" .. subname .. "_top.png",
			"moderntables_" .. subname .. "_side.png^moderntables_" .. subname .. "_drawer_side.png",
			"moderntables_" .. subname .. "_side.png^moderntables_" .. subname .. "_drawer_side.png",
			"moderntables_" .. subname .. "_side.png^moderntables_" .. subname .. "_drawer_side.png",
			"moderntables_" .. subname .. "_side.png^moderntables_" .. subname .. "_drawer_front.png^moderntables_drawer_handle.png",
		},
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = table_drawer_nodebox,
		},
		selection_box = {
			type = "fixed",
			fixed = { -0.5, -0.5, -0.5,   0.5, 0.5, 0.5 },
		},
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		groups = { choppy = 2, cracky = 2, crumbly = 2,
			oddly_breakable_by_hand = 2, },
		sounds = default.node_sound_metal_defaults(),
		on_rotate = screwdriver.rotate_simple,
		can_dig = can_dig,
		after_place_node = after_place_node,
	})
	local ingotitem = "default:" .. subname .. "_ingot"
	minetest.register_craft({
		output = fullname,
		recipe = {
			{ ingotitem, "group:wood", ingotitem },
			{ ingotitem, "default:chest", ingotitem },
			{ ingotitem, "", ingotitem },
		},
	})
	minetest.register_craft({
		output = fullname,
		type = "shapeless",
		recipe = { "moderntables:simple_table_" .. subname,
			"default:chest" },
	})
end

--[[
        ------------------------------
        Node and crafting registration
        ------------------------------
]]--

register_simple_wood_table("acacia_wood", "Simple Acacia Wood Table")
register_simple_wood_table("aspen_wood", "Simple Aspen Wood Table")
register_simple_wood_table("junglewood", "Simple Junglewood Table")
register_simple_wood_table("pine_wood", "Simple Pine Wood Table")
register_simple_wood_table("wood", "Simple Wooden Table")
register_storage_wood_table("acacia_wood", "Acacia Wood Table with Drawer")
register_storage_wood_table("aspen_wood", "Aspen Wood Table with Drawer")
register_storage_wood_table("junglewood", "Junglewood Table with Drawer")
register_storage_wood_table("pine_wood", "Pine Wood Table with Drawer")
register_storage_wood_table("wood", "Wooden Table with Drawer")

register_simple_metal_table("bronze", "Simple Bronze Metal Table")
register_simple_metal_table("tin", "Simple Tin Metal Table")
register_simple_metal_table("copper", "Simple Copper Metal Table")
register_simple_metal_table("steel", "Simple Steel Metal Table")
register_simple_metal_table("gold", "Simple Gold Metal Table")
register_storage_metal_table("bronze", "Bronze Metal Table with Drawer")
register_storage_metal_table("tin", "Tin Metal Table with Drawer")
register_storage_metal_table("copper", "Copper Metal Table with Drawer")
register_storage_metal_table("steel", "Steel Metal Table with Drawer")
register_storage_metal_table("gold", "Gold Metal Table with Drawer")

if minetest.global_exists("tubelib") then
	-- Simple Tubelib-style wooden table
	minetest.register_node("moderntables:tubelib_table", {
		description = "Simple Tubelib Table",
		tiles = {
			-- up, down, right, left, back, front
			"tubelib_front.png",
			"tubelib_front.png^moderntables_tubelib_legs_top.png",
			"tubelib_front.png",
			"tubelib_front.png",
			"tubelib_front.png",
			"tubelib_front.png",
		},
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = table_nodebox,
		},
		selection_box = {
			type = "fixed",
			fixed = { -0.5, -0.5, -0.5,   0.5, 0.5, 0.5 },
		},
		paramtype = "light",
		paramtype2 = "facedir",
		place_param2 = 0,
		is_ground_content = false,
		groups = { choppy = 2, cracky = 2, crumbly = 2 },
		sounds = default.node_sound_wood_defaults(),
		on_rotate = screwdriver.disallow,
	})
	-- Tubelib-style wooden table with drawer inventory
	minetest.register_node("moderntables:tubelib_storage_table", {
		description = "Tubelib Table with Drawer",
		tiles = {
			-- up, down, right, left, back, front
			"tubelib_front.png",
			"tubelib_front.png^moderntables_tubelib_legs_top.png",
			"tubelib_front.png^moderntables_tubelib_drawer_side.png",
			"tubelib_front.png^moderntables_tubelib_drawer_side.png",
			"tubelib_front.png^moderntables_tubelib_drawer_side.png",
			"tubelib_front.png^moderntables_tubelib_drawer_side.png^moderntables_drawer_handle.png",
		},
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = table_drawer_nodebox,
		},
		selection_box = {
			type = "fixed",
			fixed = { -0.5, -0.5, -0.5,   0.5, 0.5, 0.5 },
		},
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		groups = { choppy = 2, cracky = 2, crumbly = 2 },
		sounds = default.node_sound_wood_defaults(),
		formspec = inv_formspec,
		on_rotate = screwdriver.rotate_simple,
		can_dig = can_dig,
		after_place_node = after_place_node,
	})
	-- Simple Tubelib-inspired metal table
	minetest.register_node("moderntables:tubelib_metal_table", {
		description = "Simple Tubelib Metal Table",
		tiles = {
			-- up, down, right, left, back, front
			"moderntables_tubelib_metal_top.png",
			"moderntables_tubelib_metal_top.png^moderntables_tubelib_legs_bottom.png",
			"moderntables_tubelib_side.png",
			"moderntables_tubelib_side.png",
			"moderntables_tubelib_side.png",
			"moderntables_tubelib_side.png"
		},
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = table_nodebox,
		},
		selection_box = {
			type = "fixed",
			fixed = { -0.5, -0.5, -0.5,   0.5, 0.5, 0.5 },
		},
		paramtype = "light",
		paramtype2 = "facedir",
		place_param2 = 0,
		is_ground_content = false,
		groups = { choppy = 2, cracky = 2, crumbly = 2 },
		sounds = default.node_sound_metal_defaults(),
		on_rotate = screwdriver.disallow,
	})
	-- Tubelib-inspired metal table with drawer inventory
	minetest.register_node("moderntables:tubelib_storage_metal_table", {
		description = "Tubelib Metal Table with Drawer",
		tiles = {
			-- up, down, right, left, back, front
			"moderntables_tubelib_metal_top.png",
			"moderntables_tubelib_metal_top.png^moderntables_tubelib_legs_bottom.png",
			"moderntables_tubelib_side.png^moderntables_tubelib_metal_drawer_side.png",
			"moderntables_tubelib_side.png^moderntables_tubelib_metal_drawer_side.png",
			"moderntables_tubelib_side.png^moderntables_tubelib_metal_drawer_side.png",
			"moderntables_tubelib_side.png^moderntables_tubelib_metal_drawer_front.png^moderntables_drawer_handle.png",
		},
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = table_drawer_nodebox,
		},
		selection_box = {
			type = "fixed",
			fixed = { -0.5, -0.5, -0.5,   0.5, 0.5, 0.5 },
		},
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		groups = { choppy = 2, cracky = 2, crumbly = 2 },
		sounds = default.node_sound_metal_defaults(),
		formspec = inv_formspec,
		on_rotate = screwdriver.rotate_simple,
		can_dig = can_dig,
		after_place_node = after_place_node,
	})
	-- Four wooden legs with metal shoes to support Tubelib machines
	minetest.register_node("moderntables:tubelib_stand", {
		description = "Simple Tubelib Stand",
		tiles = {
			-- up, down, right, left, back, front
			"moderntables_tubelib_legs_top.png",
			"moderntables_tubelib_legs_bottom.png",
			"moderntables_tubelib_legs_side.png",
			"moderntables_tubelib_legs_side.png",
			"moderntables_tubelib_legs_side.png",
			"moderntables_tubelib_legs_side.png"
		},
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{ -0.5, -0.5, 0.375, -0.375, 0.5, 0.5 },
				{ 0.375, -0.5, 0.375, 0.5, 0.5, 0.5 },
				{ -0.5, -0.5, -0.5, -0.375, 0.5, -0.375 },
				{ 0.375, -0.5, -0.5, 0.5, 0.5, -0.375 },
			}
		},
		paramtype = "light",
		sunlight_propagates = true,
		paramtype2 = "facedir",
		place_param2 = 0,
		groups = { choppy = 2, cracky = 2, crumbly = 2 },
		is_ground_content = false,
		sounds = default.node_sound_wood_defaults(),
		on_rotate = screwdriver.disallow,
	})
	minetest.register_craft({
		output = "moderntables:tubelib_stand",
		recipe = {
			{ "group:wood", "", "group:wood" },
			{ "group:wood", "", "group:wood" },
			{ "default:steel_ingot", "", "default:steel_ingot" },
		},
	})
	minetest.register_craft({
		output = "moderntables:tubelib_table",
		type = "shapeless",
		recipe = { "moderntables:tubelib_stand", "group:wood",
			"group:wood", "group:wood" },
	})
	minetest.register_craft({
		output = "moderntables:tubelib_metal_table",
		type = "shapeless",
		recipe = { "moderntables:tubelib_stand", "default:steel_ingot",
			"default:steel_ingot", "default:steel_ingot" },
	})
	minetest.register_craft({
		output = "moderntables:tubelib_storage_table",
		type = "shapeless",
		recipe = { "moderntables:tubelib_table", "default:chest" },
	})
	minetest.register_craft({
		output = "moderntables:tubelib_storage_metal_table",
		type = "shapeless",
		recipe = { "moderntables:tubelib_metal_table", "default:chest" },
	})
end
