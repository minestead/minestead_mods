minetest.register_node("ufowreck:alien_antigrav_off", {
	description = "Alien Antigrav OFF",
	tiles = {
		"alien_ag_top_off.png",
		"alien_ag_bottom.png",
		"alien_ag_side_off.png",
		"alien_ag_side_off.png",
		"alien_ag_side_off.png",
		"alien_ag_side_off.png",
	},
	groups = {cracky=2, technic_machine = 1, technic_hv = 1},
	connect_sides = {"bottom"},
	sounds = default.node_sound_metal_defaults(),
	drop = "ufowreck:alien_antigrav",
	on_rightclick = function(pos, node, clicker)
		local meta = minetest.get_meta(pos)
		minetest.swap_node(pos,{name = "ufowreck:alien_antigrav"})
		meta:set_int("HV_EU_demand", 2000)
		meta:set_string("infotext", "Alien Antigrav")
		pos.y = pos.y + 1
		local yi
		if meta:get_int("HV_EU_input") < 2000 then
			minetest.sound_play("ag_on",{max_hear_distance = 16,pos = pos,gain = 1.0})
			for yi = 0, 100 do
				if (minetest.get_node(pos)).name == "air" then
					minetest.set_node(pos,{name = "ufowreck:ag_beam"})
				else
					break
				end
				pos.y = pos.y + 1
			end
		end
	end,
})

minetest.register_node("ufowreck:alien_antigrav", {
	description = "Alien Antigrav",
	tiles = {
		{name="alien_ag_top.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=2.00},},
		"alien_ag_bottom.png",
		{name="alien_ag_side.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=2.00},},
		{name="alien_ag_side.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=2.00},},
		{name="alien_ag_side.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=2.00},},
		{name="alien_ag_side.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=2.00},},
	},
	light_source = 5,
	groups = {cracky=2, technic_machine = 1, technic_hv = 1},
	connect_sides = {"bottom"},
	sounds = default.node_sound_metal_defaults(),
	drop = "ufowreck:alien_antigrav",
	after_place_node = function(pos,placer,itemstack)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", "Alien Antigrav")
		meta:set_int("HV_EU_demand", 2000)
		pos.y = pos.y + 1
		local yi
		if meta:get_int("HV_EU_input") < 2000 then
			for yi = 0, 100 do
				if (minetest.get_node(pos)).name == "air" then
					minetest.set_node(pos,{name = "ufowreck:ag_beam"})
				else
					break
				end
				pos.y = pos.y + 1
			end
		end
	end,
	after_dig_node = function(pos)
		pos.y = pos.y + 1
		local yi
		for yi = 0, 100 do
			if (minetest.get_node(pos)).name == "ufowreck:ag_beam" then
				minetest.set_node(pos,{name = "air"})			
			end
			pos.y = pos.y + 1
		end
	end,
	on_rightclick = function(pos, node, clicker)
		local meta = minetest.get_meta(pos)
		minetest.swap_node(pos,{name = "ufowreck:alien_antigrav_off"})
		meta:set_int("HV_EU_demand", 0)
		meta:set_string("infotext", "Alien Antigrav Off")
		pos.y = pos.y + 1
		local yi
		for yi = 0, 100 do
			if (minetest.get_node(pos)).name == "ufowreck:ag_beam" then
				minetest.set_node(pos,{name = "air"})			
			end
			pos.y = pos.y + 1
		end
	end,
})

technic.register_machine("HV", "ufowreck:alien_antigrav", technic.receiver)
technic.register_machine("HV", "ufowreck:alien_antigrav_off", technic.receiver)

minetest.register_node("ufowreck:ag_beam", {
   description = "antigrav beam",
   paramtype = "light",
 	tiles = {
		"alien_ag_beam.png",
	},
	drawtype = "nodebox",
	paramtype = "light",
	use_texture_alpha = true,
	light_source = 14,
	sunlight_propagates = true,
	pointable = false,
	diggable = false,
	buildable_to = true,
	walkable = false,
	climbable = true,
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_int("life", 12)
	end,
})

minetest.register_abm({
	nodenames = {"ufowreck:alien_antigrav"},
	interval = 10,
	chance = 1,
	action = function(pos, node, active_object_count, 	active_object_count_wider)
		local meta = minetest.get_meta(pos)
		pos.y = pos.y + 1
		if meta:get_int("HV_EU_input") < 2000 then
		local yi
		for yi = 0, 100 do
			if (minetest.get_node(pos)).name == "ufowreck:ag_beam" then
				minetest.set_node(pos,{name = "air"})			
			end
			pos.y = pos.y + 1
		end
	
		else
		
		for yi = 0, 100 do
			if (minetest.get_node(pos)).name == "air" then
				minetest.set_node(pos,{name = "ufowreck:ag_beam"})
			else
				break
			end
			pos.y = pos.y + 1
		end
		end
	end
})

minetest.register_craft({
	output = "ufowreck:alien_antigrav",
	recipe = {
	{"technic:copper_coil", "basic_materials:silver_wire", "technic:copper_coil"},
	{"ufowreck:alien_control", "technic:hv_transformer", "ufowreck:alien_control"},
	{"ufowreck:alien_metal", "technic:hv_cable", "ufowreck:alien_metal"}
  }
})
