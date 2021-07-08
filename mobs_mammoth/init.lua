local modpath = minetest.get_modpath(minetest.get_current_modname())

dofile(modpath .. "/mammoth.lua")
dofile(modpath .. "/moose.lua")
dofile(modpath .. "/reindeer.lua")



minetest.register_craftitem("mobs_mammoth:leather_sheet", {
    description = "Leather Sheet",
    inventory_image = "leather_block.png",
    groups = {leather = 1, flammable = 2},
})

minetest.register_node("mobs_mammoth:leather_block", {
    description = "Leather Block",
    tiles = {"leather_block.png"},
	drawtype = "nodebox",
	paramtype2 = "facedir",
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {cracky = 1},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_craft({
	output = "mobs_mammoth:leather_block",
	recipe = {
		{"mobs_mammoth:leather_sheet", "mobs_mammoth:leather_sheet", "mobs_mammoth:leather_sheet"},
		{"mobs_mammoth:leather_sheet", "mobs_mammoth:leather_sheet", "mobs_mammoth:leather_sheet"},
		{"mobs_mammoth:leather_sheet", "mobs_mammoth:leather_sheet", "mobs_mammoth:leather_sheet"},
	},
})

minetest.register_craft({
	output = "mobs_mammoth:leather_sheet 9",
	recipe = {
		{"mobs_mammoth:leather_block"},
	},
})

minetest.register_craft({
	output = "mobs_mammoth:leather_sheet",
	recipe = {
		{"water_life:beaver_fur", "water_life:beaver_fur"},
		{"water_life:beaver_fur", "water_life:beaver_fur"},
	},
})

minetest.register_craft({
	output = "mobs_mammoth:leather_sheet",
	recipe = {
		{"water_life:crocleather", "water_life:crocleather"},
	},
})

minetest.register_craft({
	output = "mobs_mammoth:leather_sheet",
	recipe = {
		{"mobs:leather", "mobs:leather"},
		{"mobs:leather", "mobs:leather"},
	},
})

minetest.register_craft({
	output = "mobs_mammoth:leather_sheet",
	recipe = {
		{"mobs:rabbit_hide", "mobs:rabbit_hide", "mobs:rabbit_hide"},
		{"mobs:rabbit_hide", "mobs:rabbit_hide", "mobs:rabbit_hide"},
	},
})

armor:register_armor("mobs_mammoth:leather_jacket", {
	description = "Leather Jacket",
	inventory_image = "leather_jacket_inv.png",
	groups = {armor_torso=1, armor_heal=1, armor_use=400,
		physics_speed=0.2, physics_gravity=0.0},
	armor_groups = {fleshy=15},
	damage_groups = {cracky=3, snappy=2, choppy=2, crumbly=1, level=2},
})

minetest.register_craft({
	output = "mobs_mammoth:leather_jacket",
	recipe = {
		{"mobs_mammoth:leather_sheet", "", "mobs_mammoth:leather_sheet"},
		{"mobs_mammoth:leather_sheet", "dye:black", "mobs_mammoth:leather_sheet"},
		{"mobs_mammoth:leather_sheet", "dye:black", "mobs_mammoth:leather_sheet"},
	},
})

minetest.register_craft({
	type = "shapeless",
	output = "default:paper 9",
	recipe = {"mobs_mammoth:leather_sheet"},
})

armor:register_armor("mobs_mammoth:brown_jacket", {
	description = "Brown Jacket",
	inventory_image = "brown_jacket_inv.png",
	groups = {armor_torso=1, armor_heal=1, armor_use=400, physics_speed=0.2, physics_gravity=0.0},
	armor_groups = {fleshy=15},
	damage_groups = {cracky=3, snappy=2, choppy=2, crumbly=1, level=2},
})

minetest.register_craft({
	output = "mobs_mammoth:brown_jacket",
	recipe = {
		{"mobs_mammoth:leather_sheet", "wool:white", "mobs_mammoth:leather_sheet"},
		{"mobs_mammoth:leather_sheet", "", "mobs_mammoth:leather_sheet"},
		{"mobs_mammoth:leather_sheet", "", "mobs_mammoth:leather_sheet"},
	},
})

minetest.register_node("mobs_mammoth:snow_brick", {
	description = "Snow Brick",
	tiles = {"snow_brick.png"},
	groups = {crumbly = 2, cools_lava = 1, snowy = 1},
	is_ground_content = false,
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_craft({
	output = "mobs_mammoth:snow_brick 4",
	recipe = {
	{ "default:snowblock", "default:snowblock" },
	{ "default:snowblock", "default:snowblock", }
	},
})

minetest.register_craft({
	output = "default:snowblock 4",
	recipe = { { "mobs_mammoth:snow_brick" } },
})

minetest.register_node("mobs_mammoth:ice_brick", {
	description = "Ice Brick",
	tiles = {"ice_brick.png"},
	groups = {crumbly = 2, cools_lava = 1, snowy = 1},
	is_ground_content = false,
	sounds = default.node_sound_glass_defaults(),
})

minetest.register_craft({
	output = "mobs_mammoth:ice_brick 4",
	recipe = {
	{ "default:ice", "default:ice" },
	{ "default:ice", "default:ice" },
	},
})

minetest.register_craft({
	output = "default:ice 4",
	recipe = { { "mobs_mammoth:ice_brick" } },
})

default.chest.register_chest("mobs_mammoth:leather_chest", {
	description = "Leather Chest",
	tiles = {
		"leather_block_top.png",
		"leather_block_top.png",
		"leather_block_side.png",
		"leather_block_side.png",
		"leather_block_front.png",
		"default_chest_inside.png"
	},
	sounds = default.node_sound_wood_defaults(),
	sound_open = "default_chest_open",
	sound_close = "default_chest_close",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
})

minetest.register_craft({
	type = "shapeless",
	output = "mobs_mammoth:leather_chest",
	recipe = {"default:chest", "mobs_mammoth:leather_block"},
})

if minetest.get_modpath("stairs") then
	stairs.register_all("ice_brick", "mobs_mammoth:ice_brick",
		{choppy = 2, oddly_breakable_by_hand = 2, flammable = 3},
		{"ice_brick.png"},
		"Ice Brick",
		stairs.glass)
	stairs.register_all("snow_brick", "mobs_mammoth:snow_brick",
		{choppy = 2, oddly_breakable_by_hand = 2, flammable = 3},
		{"snow_brick.png"},
		"Snow Brick",
		default.node_sound_stone_defaults())
end
