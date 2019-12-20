mobs:register_mob("mobs_squid:squid", {
	type = "animal",
	passive = true,
    stepheight = 0.1,
--	pathfinding = 1,
	damage = 2,
	reach = 2,
	hp_min = 10,
	hp_max = 10,
	armor = 100,
	collisionbox = {-0.4, 0.1, -0.4, 0.4, 0.9, 0.4},
    visual = "mesh",
    mesh = "mobs_mc_squid.b3d",
    textures = {
        {"mobs_mc_squid.png"}
    },
    sounds = {
		damage = "mobs_mc_squid_hurt",
		distance = 16,
    },
    animation = {
		stand_start = 1,
		stand_end = 60,
		walk_start = 1,
		walk_end = 60,
		run_start = 1,
		run_end = 60,
	},
    drops = {
		{name = "dye:black", chance = 1, min = 1, max = 3,},
		{name = "mobs_squid:tentacle", chance = 1,	min = 1, max = 8,},
	},
    visual_size = {x=1.75, y=1.75},	
	makes_footstep_sound = false,
    fly = true,
    fly_in = "default:water_source",
    jump = false,
    fall_speed = 0.5,
    view_range = 16,
    water_damage = 0,
    lava_damage = 4,
    light_damage = 0,
    runaway = true,
    fear_height = 4,
    blood_texture = "mobs_mc_squid_blood.png",
})

mobs:spawn({
	name = "mobs_squid:squid",
	nodes = {"default:water_source"},
	neighbors = {"default:water_flowing","default:water_source"},
	min_light = 5,
	interval = 30,
	chance = 5500,
	max_height = -3,
})

-- spawn eggs
mobs:register_egg("mobs_squid:squid", "Squid", "mobs_mc_spawn_icon_squid.png", 0)

minetest.register_craftitem("mobs_squid:tentacle", {
	description = "Tentacle",
	inventory_image = "mobs_tentacle.png",
	on_use = minetest.item_eat(3),
	groups = {food_meat_raw = 1},
})

minetest.register_craftitem("mobs_squid:squid_salad", {
	description = "Squid Salad",
	inventory_image = "mobs_squid_salad.png",
	on_use = minetest.item_eat(10, "farming:bowl"),
})

minetest.register_craft({
	output = "mobs_squid:squid_salad",
	recipe = {
		{"group:food_cucumber","group:food_onion","mobs_squid:tentacle"},
		{"group:food_bowl", "", ""},
		{"", "", ""},
	}
})
