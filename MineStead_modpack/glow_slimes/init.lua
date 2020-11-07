mobs:register_mob("glow_slimes:ice_slime", {
	light_source = LIGHT_MAX,
	group_attack = true,
	type = "animal",
	passive = false,
	attack_type = "dogfight",
	pathfinding = 1,
	damage = 2,
	reach = 2,
	hp_min = 16,
	hp_max = 20,
	armor = 100,
	collisionbox = {-0.2, -0.01, -0.2, 0.2, 0.4, 0.2},
	visual_size = {x = 2, y = 2},
	visual = "mesh",
	mesh = "slime_liquid.b3d",
	blood_texture = "tmw_slime_goo.png^[colorize:#DFF:190]",
	textures = {
		{"tmw_slime_goo_block.png^[colorize:#DFF:190","tmw_slime_goo_block.png^[colorize:#DFF:190^[colorize:#FFF:96"},
	},
	makes_footstep_sound = false,
	walk_velocity = 0.5,
	run_velocity = 1.25,
	view_range = 15,
	drops = {
		{name = 'currency:minegeld_cent_5', chance = 5, min = 0, max = 1},
		{name = 'currency:minegeld_cent_10', chance = 5, min = 0, max = 1},
		{name = 'currency:minegeld_cent_25', chance = 5, min = 0, max = 1},
		{name = 'default:snow', chance = 5, min = 0, max = 1},
	},
	water_damage = 0,
	lava_damage = 10,
	light_damage = 2,
	replace_rate = 2,
	replace_what = {
		{"air", "default:snowblock", 0},
		{"air", "default:ice", 0},
		{"air", "glow_slimes:ice_crystal", 0},
	},
	animation = {
		idle_start = 0,
		idle_end = 19,
		move_start = 21,
		move_end = 41,
		fall_start = 42,
		fall_end = 62,
		jump_start = 63,
		jump_end = 83
	},
	on_rightclick = function(self, clicker)
		if mobs:capture_mob(self, clicker, 30, 50, 80, true, "glow_slimes:ice_slime") then return end
	end,
})

mobs:register_mob("glow_slimes:blue_slime", {
	group_attack = true,
	type = "animal",
	passive = false,
	attack_type = "dogfight",
	pathfinding = 1,
	damage = 2,
	reach = 2,
	hp_min = 16,
	hp_max = 20,
	armor = 100,
	collisionbox = {-0.2, -0.01, -0.2, 0.2, 0.4, 0.2},
	visual_size = {x = 2, y = 2},
	visual = "mesh",
	mesh = "slime_liquid.b3d",
	blood_texture = "tmw_slime_goo.png^[colorize:#00F:190]",
	textures = {
		{"tmw_slime_goo_block.png^[colorize:#00F:190","tmw_slime_goo_block.png^[colorize:#00F:190^[colorize:#FFF:96"},
	},
	makes_footstep_sound = false,
	view_range = 15,
	walk_velocity = 0.5,
	run_velocity = 4,
	view_range = 48, --This thing will chase you all the way to shore.
	fly = true,
	fly_in = {"default:water_source", "default:water_flowing", "default:river_water_source", "default:river_water_flowing"},
	drops = {
		{name = 'currency:minegeld_cent_5', chance = 5, min = 0, max = 1},
		{name = 'currency:minegeld_cent_10', chance = 5, min = 0, max = 1},
		{name = 'currency:minegeld_cent_25', chance = 5, min = 0, max = 1},
		{name = 'dye:blue', chance = 5, min = 0, max = 1},
		{name = 'dye:cyan', chance = 5, min = 0, max = 1},
	},
	water_damage = 0,
	lava_damage = 10,
	light_damage = 0,
	animation = {
		idle_start = 0,
		idle_end = 19,
		move_start = 21,
		move_end = 41,
		fall_start = 42,
		fall_end = 62,
		jump_start = 63,
		jump_end = 83
	},
	on_rightclick = function(self, clicker)
		if mobs:capture_mob(self, clicker, 30, 50, 80, true, "glow_slimes:blue_slime") then return end
	end,
})

mobs:register_mob("glow_slimes:green_slime", {
	light_source = LIGHT_MAX,
	group_attack = true,
	type = "animal",
	passive = false,
	attack_type = "dogfight",
	pathfinding = 1,
	damage = 2,
	reach = 2,
	hp_min = 16,
	hp_max = 20,
	armor = 100,
	collisionbox = {-0.2, -0.01, -0.2, 0.2, 0.4, 0.2},
	visual_size = {x = 2, y = 2},
	visual = "mesh",
	mesh = "slime_liquid.b3d",
	blood_texture = "tmw_slime_goo.png^[colorize:#0F0:190]",
	textures = {
		{"tmw_slime_goo_block.png^[colorize:#0F0:190","tmw_slime_goo_block.png^[colorize:#0F0:190^[colorize:#FFF:96"},
	},
	makes_footstep_sound = false,
	walk_velocity = 0.5,
	run_velocity = 1.25,
	jump_height = 7,
	jump = true,
	view_range = 15,
	drops = {
		{name = 'currency:minegeld_cent_5', chance = 5, min = 0, max = 1},
		{name = 'currency:minegeld_cent_10', chance = 5, min = 0, max = 1},
		{name = 'currency:minegeld_cent_25', chance = 5, min = 0, max = 1},
		{name = 'dye:green', chance = 5, min = 0, max = 1},
	},
	water_damage = 0,
	lava_damage = 10,
	light_damage = 2,
	replace_rate = 2,
	replace_what = {
		{"default:stone", "glow_slimes:stone_with_green_slime", -1},
		{"default:cobble", "glow_slimes:stone_with_green_slime", -1},
	},
	animation = {
		idle_start = 0,
		idle_end = 19,
		move_start = 21,
		move_end = 41,
		fall_start = 42,
		fall_end = 62,
		jump_start = 63,
		jump_end = 83
	},
	on_rightclick = function(self, clicker)
		if mobs:capture_mob(self, clicker, 30, 50, 80, true, "glow_slimes:green_slime") then return end
	end,
})

mobs:register_mob("glow_slimes:pink_slime", {
	light_source = LIGHT_MAX,
	group_attack = true,
	type = "animal",
	passive = false,
	attack_type = "dogfight",
	pathfinding = 1,
	damage = 2,
	reach = 2,
	hp_min = 30,
	hp_max = 50,
	armor = 100,
	collisionbox = {-0.1, -0.01, -0.1, 0.1, 0.2, 0.1},
	visual_size = {x = 1, y = 1},
	visual = "mesh",
	mesh = "slime_liquid.b3d",
	blood_texture = "tmw_slime_goo.png^[colorize:#F7B:190]",
	textures = {
		{"tmw_slime_goo_block.png^[colorize:#F7B:190","tmw_slime_goo_block.png^[colorize:#F7B:190^[colorize:#FFF:96"},
	},
	makes_footstep_sound = false,
	walk_velocity = 1.5,
	run_velocity = 2.25,
	jump_height = 20,
	jump = true,
	view_range = 15,
	drops = {
		{name = 'default:gold_lump', chance = 25, min = 0, max = 10},
		{name = 'default:diamond', chance = 25, min = 0, max = 2},
		{name = 'default:pick_diamond', chance = 5, min = 0, max = 1},
		{name = 'default:axe_diamond', chance = 5, min = 0, max = 1},
		{name = 'dye:pink', chance = 5, min = 0, max = 1},
	},
	water_damage = 0,
	lava_damage = 10,
	light_damage = 0,
--	replace_rate = 2,
--	replace_what = {
--		{"default:stone", "glow_slimes:stone_with_yellow_slime", -1},
--		{"default:cobble", "glow_slimes:stone_with_yellow_slime", -1},
--	},
	animation = {
		idle_start = 0,
		idle_end = 19,
		move_start = 21,
		move_end = 41,
		fall_start = 42,
		fall_end = 62,
		jump_start = 63,
		jump_end = 83
	},
	on_rightclick = function(self, clicker)
		if mobs:capture_mob(self, clicker, 30, 50, 80, true, "glow_slimes:pink_slime") then return end
	end,
})

mobs:register_mob("glow_slimes:yellow_slime", {
	light_source = LIGHT_MAX,
	group_attack = true,
	type = "animal",
	passive = false,
	attack_type = "dogfight",
	pathfinding = 1,
	damage = 2,
	reach = 2,
	hp_min = 16,
	hp_max = 20,
	armor = 100,
	collisionbox = {-0.2, -0.01, -0.2, 0.2, 0.4, 0.2},
	visual_size = {x = 2, y = 2},
	visual = "mesh",
	mesh = "slime_liquid.b3d",
	blood_texture = "tmw_slime_goo.png^[colorize:#FF0:190]",
	textures = {
		{"tmw_slime_goo_block.png^[colorize:#FF0:190","tmw_slime_goo_block.png^[colorize:#FF0:190^[colorize:#FFF:96"},
	},
	makes_footstep_sound = false,
	walk_velocity = 0.5,
	run_velocity = 1.25,
	jump_height = 7,
	jump = true,
	view_range = 15,
	drops = {
		{name = 'currency:minegeld_cent_5', chance = 5, min = 0, max = 1},
		{name = 'currency:minegeld_cent_10', chance = 5, min = 0, max = 1},
		{name = 'currency:minegeld_cent_25', chance = 5, min = 0, max = 1},
		{name = 'dye:orange', chance = 5, min = 0, max = 1},
		{name = 'dye:white', chance = 5, min = 0, max = 1},
	},
	water_damage = 0,
	lava_damage = 0,
	light_damage = 2,
	replace_rate = 2,
	replace_what = {
		{"default:stone", "glow_slimes:stone_with_yellow_slime", -1},
		{"default:cobble", "glow_slimes:stone_with_yellow_slime", -1},
	},
	animation = {
		idle_start = 0,
		idle_end = 19,
		move_start = 21,
		move_end = 41,
		fall_start = 42,
		fall_end = 62,
		jump_start = 63,
		jump_end = 83
	},
	on_rightclick = function(self, clicker)
		if mobs:capture_mob(self, clicker, 30, 50, 80, true, "glow_slimes:yellow_slime") then return end
	end,
})

mobs:register_mob("glow_slimes:orange_slime", {
	light_source = LIGHT_MAX,
	group_attack = true,
	type = "animal",
	passive = false,
	attack_type = "dogfight",
	pathfinding = 1,
	damage = 2,
	reach = 2,
	hp_min = 16,
	hp_max = 20,
	armor = 100,
	collisionbox = {-0.2, -0.01, -0.2, 0.2, 0.4, 0.2},
	visual_size = {x = 2, y = 2},
	visual = "mesh",
	mesh = "slime_liquid.b3d",
	blood_texture = "tmw_slime_goo.png^[colorize:#F80:190]",
	textures = {
		{"tmw_slime_goo_block.png^[colorize:#F80:190","tmw_slime_goo_block.png^[colorize:#F80:190^[colorize:#FFF:96"},
	},
	makes_footstep_sound = false,
	walk_velocity = 0.5,
	run_velocity = 1.25,
	jump_height = 7,
	jump = true,
	view_range = 15,
	drops = {
		{name = 'currency:minegeld_cent_5', chance = 5, min = 0, max = 1},
		{name = 'currency:minegeld_cent_10', chance = 5, min = 0, max = 1},
		{name = 'currency:minegeld_cent_25', chance = 5, min = 0, max = 1},
		{name = 'dye:orange', chance = 5, min = 0, max = 1},
		{name = 'dye:white', chance = 5, min = 0, max = 1},
	},
	water_damage = 0,
	lava_damage = 0,
	light_damage = 2,
	replace_rate = 2,
	replace_what = {
		{"default:stone", "glow_slimes:stone_with_yellow_slime", -1},
		{"default:cobble", "glow_slimes:stone_with_yellow_slime", -1},
	},
	animation = {
		idle_start = 0,
		idle_end = 19,
		move_start = 21,
		move_end = 41,
		fall_start = 42,
		fall_end = 62,
		jump_start = 63,
		jump_end = 83
	},
	on_rightclick = function(self, clicker)
		if mobs:capture_mob(self, clicker, 30, 50, 80, true, "glow_slimes:orange_slime") then return end
	end,
})

minetest.registered_entities["glow_slimes:ice_slime"].glow = 10
minetest.registered_entities["glow_slimes:blue_slime"].glow = 10
minetest.registered_entities["glow_slimes:green_slime"].glow = 10
minetest.registered_entities["glow_slimes:pink_slime"].glow = 10
minetest.registered_entities["glow_slimes:yellow_slime"].glow = 10
minetest.registered_entities["glow_slimes:orange_slime"].glow = 10

mobs:register_egg("glow_slimes:ice_slime", "Ice Slime", "tmw_slime_inventory.png^[colorize:#DFF:190", 0)
mobs:register_egg("glow_slimes:blue_slime", "Blue Slime", "tmw_slime_inventory.png^[colorize:#00F:190", 0)
mobs:register_egg("glow_slimes:green_slime", "Green Slime", "tmw_slime_inventory.png^[colorize:#0F0:190", 0)
mobs:register_egg("glow_slimes:pink_slime", "Pink Slime", "tmw_slime_inventory.png^[colorize:#F7B:190", 0)
mobs:register_egg("glow_slimes:yellow_slime", "Yellow Slime", "tmw_slime_inventory.png^[colorize:#FF0:190", 0)
mobs:register_egg("glow_slimes:orange_slime", "Orange Slime", "tmw_slime_inventory.png^[colorize:#F80:190", 0)

minetest.register_node("glow_slimes:stone_with_yellow_slime", {
	description = "Stone with yellow slime",
	tiles = {
		"stone_with_yellow_slime_top.png",
		"default_cobble.png",
		"stone_with_yellow_slime_side.png",
		"stone_with_yellow_slime_side.png",
		"stone_with_yellow_slime_side.png",
		"stone_with_yellow_slime_side.png",
	},
	light_source = 6,
	groups = {cracky=2, slippery = 3, soil = 3, field = 1, wet = 1},
	sounds = default.node_sound_stone_defaults(),
	drop = {
		max_items = 2,
		items = {
			{items = {'default:cobble'}},
			{items = {'dye:yellow'},rarity = 3},
			{items = {'dye:orange'},rarity = 3},
			{items = {'dye:white'},rarity = 3},
		}
	},
})

minetest.register_node("glow_slimes:stone_with_green_slime", {
	description = "Stone with green slime",
	tiles = {
		"stone_with_green_slime_top.png",
		"default_cobble.png",
		"stone_with_green_slime_side.png",
		"stone_with_green_slime_side.png",
		"stone_with_green_slime_side.png",
		"stone_with_green_slime_side.png",
	},
	light_source = 6,
	groups = {cracky=2, slippery = 3, soil = 3, field = 1, wet = 1},
	sounds = default.node_sound_stone_defaults(),
	drop = {
		max_items = 2,
		items = {
			{items = {'default:cobble'}},
			{items = {'dye:green'},rarity = 3},
		}
	},
})

minetest.register_node("glow_slimes:ice_crystal", {
	description = "Ice Crystal",
	tiles = {"default_ice.png"},
	groups = {cracky = 2, falling_node = 1},
	paramtype = "light",
	paramtype2 = "facedir",
	drawtype = "mesh",
	mesh = "underch_crystal.obj",
	light_source = 6,
	is_ground_content = false,
	sounds = default.node_sound_glass_defaults(),
})

minetest.register_craft({
	output = "default:ice 4",
	type = "shapeless",
	recipe = {"glow_slimes:ice_crystal"}
})

minetest.register_alias("glow_slimes:stone_with_yellow_slime", "farming:soil_wet")
minetest.register_alias("glow_slimes:stone_with_green_slime", "farming:soil_wet")

mobs:spawn({
	name = "glow_slimes:ice_slime",
	nodes = {"default:stone", "default:cobble", "default:snowblock", "default:ice"},
	interval = 30,
	chance = 25000,
	max_height = -15000,
})

mobs:spawn({
	name = "glow_slimes:blue_slime",
	nodes = {"default:water_source", "default:river_water_source", "default:sand"},
	neighbors = {"default:water_flowing","default:water_source"},
	interval = 30,
	chance = 25000,
	max_height = -5,
})

mobs:spawn({
	name = "glow_slimes:green_slime",
	nodes = {"default:stone", "default:cobble", "glow_slimes:stone_with_green_slime"},
	interval = 30,
	chance = 6000,
	max_height = -40,
})

mobs:spawn({
	name = "glow_slimes:pink_slime",
	nodes = {"default:stone", "default:cobble", "glow_slimes:stone_with_yellow_slime"},
	interval = 30,
	chance = 3000,
	max_height = -250,
})

mobs:spawn({
	name = "glow_slimes:yellow_slime",
	nodes = {"default:stone", "default:cobble", "glow_slimes:stone_with_yellow_slime"},
	interval = 30,
	chance = 6000,
	max_height = -1000,
})

mobs:spawn({
	name = "glow_slimes:orange_slime",
	nodes = {"default:stone", "default:cobble", "glow_slimes:stone_with_yellow_slime"},
	interval = 30,
	chance = 6000,
	max_height = -2000,
})
