mobs:spawn({name = "ufowreck:floob",
       nodes = {"ufowreck:floob_spawner"},
       active_object_count = 2,
       chance = 1,
       interval = 1,
})

mobs:register_mob("ufowreck:floob", {
	type = "monster",
	passive = false,
	attack_type = "shoot",
	attack_animals = true;
	attack_players = true;
    shoot_interval = 2.5,
	arrow = "ufowreck:rayray",
	shoot_offset = 0.5,
	damage = 2.5,
	hp_min = 12,
	hp_max = 50,
	armor = 100,
	collisionbox = {-0.5, -0.01, -0.5, 0.5, 2.2, 0.5},
    rotate = 180,
	visual = "mesh",
	mesh = "amcaw_floob.b3d",
	textures = {
		{"amcaw_floob.png"},
	},
	visual_size = {x=4, y=4},
	makes_footstep_sound = true,
	sounds = {
--		random = "amcaw_floob",
--		damage = "amcaw_floobhurt",
		shoot_attack = "blaster_long",
		death = "amcaw_floobdeath",
	},
	walk_velocity = 1,
	run_velocity = 1.5,
	jump = true,
	floats = 1,
	view_range = 20,
	drops = {
		{name = "ufowreck:broken_raygun",
		chance = 3, min = 0, max = 1,},
	},
	water_damage = 0,
    fear_height = 6,
	lava_damage = 1,
	light_damage = 0,
	animation = {
		speed_normal = 25,		speed_run = 30,
		stand_start = 40,		stand_end = 80,
		walk_start = 0,		walk_end = 40,
		run_start = 0,		run_end = 40,
	},
})

-- raygun arrow (weapon)
mobs:register_arrow("ufowreck:rayray", {
	visual = "sprite",
	visual_size = {x = 0.5, y = 0.5},
	textures = {"amcaw_rayray.png"},
	velocity = 6,

	hit_player = function(self, player)
		player:punch(self.object, 1.0, {
			full_punch_interval = 1.0,
			damage_groups = {fleshy = 2},
		}, nil)
	end,

	hit_mob = function(self, player)
		player:punch(self.object, 1.0, {
			full_punch_interval = 1.0,
			damage_groups = {fleshy = 2},
		}, nil)
	end,

	hit_node = function(self, pos, node)
	end
})

mobs:register_egg("ufowreck:floob", "floob", "amcaw_a_floob_inv.png", 0)

minetest.register_node("ufowreck:floob_spawner", {
    description = "Alien Metal Block",
    tiles = {"scifi_nodes_lighttop.png"},
	drawtype = "nodebox",
	paramtype2 = "facedir",
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {cracky = 2, not_in_creative_inventory = 1},
	drop = {
		items = {
			{items = {'ufowreck:alien_metal'}},
		}
	},
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_craft({
	output = "ufowreck:floob_spawner",
	recipe = {
	{"ufowreck:alien_metal", "", ""},
	{"", "", ""},
	{"", "", "ufowreck:eye"}
  }
})
