mobs:register_mob("mobs_mammoth:reindeer", {
	stepheight = 1,
	type = "animal",
	passive = true,
	attack_type = "dogfight",
	group_attack = true,
	owner_loyal = true,
	attack_npcs = false,
	reach = 2,
	damage = 2,
	hp_min = 25,
	hp_max = 50,
	armor = 100,
	collisionbox = {-0.6, -0.01, -0.6, 0.6, 0.95, 0.6},
	visual = "mesh",
	mesh = "Reindeer.b3d",
	textures = {
		{"texturereindeer.png"},
	},
	makes_footstep_sound = true,
	sounds = {

	},
	walk_velocity = 1,
	run_velocity = 3,
	jump = false,
	jump_height = 3,
	pushable = true,
	follow = {"default:apple", "farming:potato", "farming:melon_slice", "farming:cucumber", "farming:cabbage", "farming:lettuce", "farming:bread"},
	view_range = 10,
	drops = {
		{name = "mobs:meat_raw", chance = 1, min = 1, max = 1},
		{name = "mobs:leather", chance = 1, min = 1, max = 1},
	},
	water_damage = 0,
	lava_damage = 5,
	light_damage = 0,
	fear_height = 2,
	animation = {
		speed_normal = 70,
		stand_start = 0,
		stand_end = 100,
		walk_start = 100,
		walk_end = 200,
		punch_start = 200,
		punch_end = 300,

		die_start = 1, -- we dont have a specific death animation so we will
		die_end = 2, --   re-use 2 standing frames at a speed of 1 fps and
		die_speed = 1, -- have mob rotate when dying.
		die_loop = false,
		die_rotate = true,
	},
	on_rightclick = function(self, clicker)
		if mobs:feed_tame(self, clicker, 8, true, true) then return end
		if mobs:protect(self, clicker) then return end
		if mobs:capture_mob(self, clicker, 0, 5, 50, false, nil) then return end
	end,
})

mobs:spawn({
	name = "mobs_mammoth:reindeer",
	nodes = {"default:dirt_with_snow", "default:permafrost_with_moss", "default:permafrost_with_stones"},
	min_light = 0,
	interval = 60,
	chance = 8000, -- 15000
	min_height = 0,
	max_height = 80,
	day_toggle = true,
})

mobs:register_egg("mobs_mammoth:reindeer", ("Reindeer"), "areindeer.png")
