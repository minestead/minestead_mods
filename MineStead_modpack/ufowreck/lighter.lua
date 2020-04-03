minetest.register_node("ufowreck:alien_lighter", {
	description = "Alien Lighter",
	tiles = {
		"scifi_nodes_lighttop.png",
		"scifi_nodes_lighttop.png",
		{name="alien_lighter.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=2.00},},
		{name="alien_lighter.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=2.00},},
		{name="alien_lighter.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=2.00},},
		{name="alien_lighter.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=2.00},}
	},
	light_source = 5,
	groups = {cracky=2, technic_machine = 1, technic_hv = 1, technic_mv = 1},
	connect_sides = {"top", "bottom"},
	sounds = default.node_sound_metal_defaults(),
	drop = "ufowreck:alien_lighter",
	after_place_node = function(pos,placer,itemstack)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", "Alien Lighter")
		meta:set_int("HV_EU_demand", 4500)
		pos.x = pos.x - 6
		pos.y = pos.y + 2
		pos.z = pos.z - 6
		local xi, yi, zi
		for xi = 0, 6 do
			for zi = 0, 6 do
				if (minetest.get_node(pos)).name == "air" then
					minetest.set_node(pos,{name = "ufowreck:airlight"})
--					minetest.set_node(pos,{name = "default:torch"})
				end
				pos.z = pos.z + 2
			end
			pos.x = pos.x + 2
			pos.z = pos.z - 14
		end
	end,
	after_dig_node = function(pos)
		pos.x = pos.x - 6
		pos.y = pos.y + 2
		pos.z = pos.z - 6
		local xi, yi, zi
		for xi = 0, 6 do
			for zi = 0, 6 do
				if (minetest.get_node(pos)).name == "ufowreck:airlight" then
--				if (minetest.get_node(pos)).name == "default:torch" then
					minetest.set_node(pos,{name = "air"})
				end
				pos.z = pos.z + 2
			end
			pos.x = pos.x + 2
			pos.z = pos.z - 14
		end	
	end,
})

technic.register_machine("HV", "ufowreck:alien_lighter", technic.receiver)

minetest.register_node("ufowreck:airlight", {
   description = "air light",
   paramtype = "light",
   drawtype = "airlike",
   light_source = 14,
   sunlight_propagates = true,
   walkable = false,
   pointable = false,
   diggable = false,
   buildable_to = true,
   on_construct = function(pos)
      local meta = minetest.get_meta(pos)
      meta:set_int("life", 12)
   end
})

minetest.register_abm({
	nodenames = {"ufowreck:alien_lighter"},
	interval = 10,
	chance = 1,
	action = function(pos, node, active_object_count, 	active_object_count_wider)
		local meta = minetest.get_meta(pos)
		pos.x = pos.x - 6
		pos.y = pos.y + 2
		pos.z = pos.z - 6
		if meta:get_int("HV_EU_input") < 4500 then
		local xi, yi, zi
		for xi = 0, 6 do
			for zi = 0, 6 do
				if (minetest.get_node(pos)).name == "ufowreck:airlight" then
--				if (minetest.get_node(pos)).name == "default:torch" then
					minetest.set_node(pos,{name = "air"})
				end
				pos.z = pos.z + 2
			end
			pos.x = pos.x + 2
			pos.z = pos.z - 14
		end
		
		else
		
		for xi = 0, 6 do
			for zi = 0, 6 do
				if (minetest.get_node(pos)).name == "air" then
					minetest.set_node(pos,{name = "ufowreck:airlight"})
--					minetest.set_node(pos,{name = "default:torch"})
				end
				pos.z = pos.z + 2
			end
			pos.x = pos.x + 2
			pos.z = pos.z - 14
		end
				
		end
	end
})
