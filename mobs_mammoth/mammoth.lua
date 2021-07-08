local animation_awake = {
		speed_normal = 10,
		speed_sprint = 30,
		stand_start = 50,
		stand_end = 150,
		walk_start = 1,
		walk_end = 40,
		punch_start = 160,
		punch_end = 200,
		punch_loop = false,
		}
local animation_sleep = {
		speed_stand = 5,
		speed_normal = 10,
		speed_sprint = 30,
		stand_start = 205,
		stand_end = 230,
		walk_start = 205,
		walk_end = 230,
		}

-- Mammoth by ElCeejo

mobs:register_mob("mobs_mammoth:mammoth", {
	type = "animal",
	hp_min = 54,
	hp_max = 54,
	armor = 115,
	passive = false,
	walk_velocity = 0.8,
	run_velocity = 3,
        walk_chance = 40,
        jump = true,
        jump_height = 1.0,
        stepheight = 1.1,
        runaway = false,
        pushable = false,
        view_range = 8,
        knock_back = 0,
        damage = 13,
	fear_height = 6,
	fall_speed = -8,
	fall_damage = 20,
	water_damage = 0,
	lava_damage = 3,
	light_damage = 0,
        suffocation = false,
        floats = 1,
	follow = {"default:leaves", "default:apple", "farming:potato", "farming:melon_slice", "farming:cucumber", "farming:bread"},
        reach = 10,
        owner_loyal = true,
	attack_type = "dogfight",
	pathfinding = 0,
	makes_footstep_sound = true,
	sounds = {
--		random = "paleotest_mammoth",
	},
	drops = {
		{name = "mobs:meat_raw", chance = 1, min = 6, max = 9},
		{name = "mobs:leather", chance = 1, min = 1, max = 4},
	},
	visual = "mesh",
	visual_size = {x=18, y=18},
	collisionbox = {-1.2, -1.7, -1.2, 1.2, 0.8, 1.2},
	textures = {
		{"paleotest_mammoth1.png"},
		{"paleotest_mammoth2.png"},
	},
	child_texture = {
		{"paleotest_mammoth3.png"},
	},
	mesh = "paleotest_mammoth.b3d",
	animation = {
		speed_normal = 10,
		speed_sprint = 30,
		stand_start = 50,
		stand_end = 150,
		walk_start = 1,
		walk_end = 40,
		punch_start = 160,
		punch_end = 200,
		punch_loop = false,
	},

	on_rightclick = function(self, clicker)

		-- feed or tame
		if mobs:feed_tame(self, clicker, 8, true, true) then return end
		if mobs:protect(self, clicker) then return end

		if self.owner == "" then
			self.owner = clicker:get_player_name()
		else
			if self.order == "follow" then
				self.order = "stand"
			else
				self.order = "follow"

			end

		end

	end,

	replace_rate = 10,
	replace_what = {
		{"group:grass", "air", 0},
	},

	do_custom = function(self, dtime)

-- Diurnal mobs sleep at night and awake at day

	if self.time_of_day > 0.2
	and self.time_of_day < 0.8 then

        self.passive = false    
        self.view_range = 8
        self.walk_chance = 40
        self.jump = false
        self.animation = animation_awake
	mobs:set_animation(self, self.animation.current)
	elseif self.time_of_day > 0.0
	and self.time_of_day < 1.0 then

        self.passive = true     
        self.view_range = 0
        self.walk_chance = 0
        self.jump = false
        self.animation = animation_sleep
	mobs:set_animation(self, self.animation.current)
	end
	end,
})

mobs:spawn({
	name = "mobs_mammoth:mammoth",
	nodes = {"default:ice", "default:dirt_with_snow", "default:snowblock", "default:permafrost_with_moss", "default:permafrost_with_stones", "default:dirt_with_coniferous_litter"},
	interval = 60,
	chance = 8000,
	min_height = 0,
	max_height = 200,
})

mobs:register_egg("mobs_mammoth:mammoth", "Mammoth", "default_dirt.png", 1)
