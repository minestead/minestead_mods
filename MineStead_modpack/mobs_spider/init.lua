mobs:register_mob("mobs_spider:spider", {
	type = "animal",
	passive = true,
	attack_type = "dogfight",
	pathfinding = 1,
	damage = 2,
	reach = 2,
	hp_min = 16,
	hp_max = 20,
	armor = 200,
	collisionbox = {-0.7, -0.01, -0.7, 0.7, 0.89, 0.7},
	visual = "mesh",
	mesh = "mobs_mc_spider.b3d",
	textures = {
		{"mobs_mc_spider.png^(mobs_mc_spider_eyes.png^[makealpha:0,0,0)"},
	},
	visual_size = {x=3, y=3},
	makes_footstep_sound = false,
	walk_velocity = 3.9,
	jump = true,
	jump_height = 2,
	view_range = 16,
	floats = 1,
	drops = {
		{name = "farming:string", chance = 1, min = 0, max = 2,},
	},
	runaway = true,
	runaway_from = {"player"},
	water_damage = 0,
	lava_damage = 4,
	light_damage = 0,
	fear_height = 4,
	animation = {
		stand_speed = 10,
		walk_speed = 25,
		run_speed = 50,
		stand_start = 20,
		stand_end = 40,
		walk_start = 0,
		walk_end = 20,
		run_start = 0,
		run_end = 20,
	},
	blood_amount = 0,
	follow = {"mobs_animal:rat", "mobs_animal:chicken", "mobs_animal:bunny", "mobs_animal:kitten", "mobs:egg", "mobs:chicken_raw", "mobs:meat_raw", "mobs:mutton_raw", "mobs:pork_raw", "mobs:rabbit_raw"},
	view_range = 5,

	on_rightclick = function(self, clicker)

		if mobs:feed_tame(self, clicker, 2, true, true) then return end
		if mobs:protect(self, clicker) then return end
		if mobs:capture_mob(self, clicker, 30, 50, 80, false, nil) then return end
	end,

	do_custom = function(self, dtime)

		self.cobweb_timer = (self.cobweb_timer or 0) + dtime
		if self.cobweb_timer < 10 then
			return
		end
		self.cobweb_timer = 0

		local pos = self.object:get_pos()
		
		if (minetest.get_node(pos)).name == "air" then
			minetest.set_node(pos, {name="xdecor:cobweb"})
		end;
	end,
})

mobs:spawn({
	name = "mobs_spider:spider",
	nodes = {"default:stone"},
	interval = 60,
	chance = 8000,
	min_height = -1000,
	max_height = -50,
})


mobs:register_egg("mobs_spider:spider", "Spider", "mobs_spider_inv.png", 0)

minetest.register_craft({
	output = "wool:white",
	recipe = {
		{"farming:string", "farming:string", ""},
		{"farming:string", "farming:string", ""},
		{"", "", ""},
	},
})

minetest.register_craft({
	output = "farming:string 5",
	recipe = {
		{"xdecor:cobweb"},
	},
})

minetest.register_craft({
	output = "xdecor:cobweb",
	recipe = {
		{"farming:string", "", "farming:string"},
		{"", "farming:string", ""},
		{"farming:string", "", "farming:string"},
	},
})
