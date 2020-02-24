minetest.register_node("ufowreck:alien_engine", {
	description = "Alien Engine",
	sunlight_propagates = false,
	tiles = {
		"scifi_nodes_lighttop.png",
		"scifi_nodes_lighttop.png",
		{name="scifi_nodes_black_screen.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=2.00},},
		{name="scifi_nodes_black_screen.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=2.00},},
		{name="scifi_nodes_black_screen.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=2.00},},
		{name="scifi_nodes_black_screen.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=2.00},}
	},
	light_source = 10,
	paramtype = "light",
	groups = {cracky=2, technic_machine = 1, technic_hv = 1},
	sounds = default.node_sound_metal_defaults(),
	connect_sides = {"top", "bottom"},
	on_construct = function(pos)
			local meta = minetest.get_meta(pos)
			meta:set_string("infotext", "Alien Engine")
			meta:set_int("HV_EU_supply", 5000)
	end,
})

technic.register_machine("HV", "ufowreck:alien_engine", technic.producer)


minetest.register_node("ufowreck:alien_health_charger0", {
	description = "Alien Charger",
	tiles = {
		"scifi_nodes_lighttop.png",
		"scifi_nodes_lighttop.png",
		"scifi_nodes_lighttop.png",
		"scifi_nodes_lighttop.png",
		"scifi_nodes_lighttop.png",
		"healthcharger_front.png^technic_power_meter0.png"
	},
	light_source = 5,
	groups = {cracky=2, technic_machine = 1, technic_hv = 1},
	connect_sides = {"top", "bottom", "back", "left", "right"},
	paramtype2 = "facedir",
	sounds = default.node_sound_metal_defaults(),
	drop = "ufowreck:alien_health_charger0",
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", "Alien Charger")
		meta:set_int("HV_EU_demand", 5000)
		minetest.get_node_timer(pos):start(20)
	end,
	on_timer = function(pos)
		local meta = minetest.get_meta(pos)
		local eu_input = meta:get_int("HV_EU_input")
		if eu_input >= 5000 then
			local node = minetest.get_node(pos)
			minetest.set_node(pos, {name = "ufowreck:alien_health_charger2", param2=node.param2,})
		end
	end,
})

minetest.register_node("ufowreck:alien_health_charger2", {
	description = "Alien Charger",
	tiles = {
		"scifi_nodes_lighttop.png",
		"scifi_nodes_lighttop.png",
		"scifi_nodes_lighttop.png",
		"scifi_nodes_lighttop.png",
		"scifi_nodes_lighttop.png",
		"healthcharger_front.png^technic_power_meter2.png"
	},
	light_source = 5,
	groups = {cracky=2, technic_machine = 1, technic_hv = 1},
	connect_sides = {"top", "bottom", "back", "left", "right"},
	paramtype2 = "facedir",
	sounds = default.node_sound_metal_defaults(),
	drop = "ufowreck:alien_health_charger0",
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", "Alien Charger")
		meta:set_int("HV_EU_demand", 5000)
		minetest.get_node_timer(pos):start(20)
	end,
	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		if player:get_hp() < 20 then
			minetest.sound_play("beep")
			stamina.change(player, 20)
			player:set_hp(player:get_hp() + 10)
			node.name = "ufowreck:alien_health_charger0"
			minetest.set_node(pos,node)
		end
	end,
	on_timer = function(pos)
		local meta = minetest.get_meta(pos)
		local eu_input = meta:get_int("HV_EU_input")
		if eu_input >= 5000 then
			local node = minetest.get_node(pos)
			minetest.set_node(pos, {name = "ufowreck:alien_health_charger4", param2=node.param2,})
		end
	end,
})

minetest.register_node("ufowreck:alien_health_charger4", {
	description = "Alien Charger",
	tiles = {
		"scifi_nodes_lighttop.png",
		"scifi_nodes_lighttop.png",
		"scifi_nodes_lighttop.png",
		"scifi_nodes_lighttop.png",
		"scifi_nodes_lighttop.png",
		"healthcharger_front.png^technic_power_meter4.png"
	},
	light_source = 5,
	groups = {cracky=2, technic_machine = 1, technic_hv = 1},
	connect_sides = {"top", "bottom", "back", "left", "right"},
	paramtype2 = "facedir",
	sounds = default.node_sound_metal_defaults(),
	drop = "ufowreck:alien_health_charger0",
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", "Alien Charger")
		meta:set_int("HV_EU_demand", 5000)
		minetest.get_node_timer(pos):start(20)
	end,
	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		if player:get_hp() < 20 then
			minetest.sound_play("beep")
			stamina.change(player, 20)
			player:set_hp(player:get_hp() + 10)
			node.name = "ufowreck:alien_health_charger2"
			minetest.set_node(pos,node)
		end
	end,
	on_timer = function(pos)
		local meta = minetest.get_meta(pos)
		local eu_input = meta:get_int("HV_EU_input")
		if eu_input >= 5000 then
			local node = minetest.get_node(pos)
			minetest.set_node(pos, {name = "ufowreck:alien_health_charger6", param2=node.param2,})
		end
	end,
})

minetest.register_node("ufowreck:alien_health_charger6", {
	description = "Alien Charger",
	tiles = {
		"scifi_nodes_lighttop.png",
		"scifi_nodes_lighttop.png",
		"scifi_nodes_lighttop.png",
		"scifi_nodes_lighttop.png",
		"scifi_nodes_lighttop.png",
		"healthcharger_front.png^technic_power_meter6.png"
	},
	light_source = 5,
	groups = {cracky=2, technic_machine = 1, technic_hv = 1},
	connect_sides = {"top", "bottom", "back", "left", "right"},
	paramtype2 = "facedir",
	sounds = default.node_sound_metal_defaults(),
	drop = "ufowreck:alien_health_charger0",
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", "Alien Charger")
		meta:set_int("HV_EU_demand", 5000)
		minetest.get_node_timer(pos):start(20)
	end,
	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		if player:get_hp() < 20 then
			minetest.sound_play("beep")
			stamina.change(player, 20)
			player:set_hp(player:get_hp() + 10)
			node.name = "ufowreck:alien_health_charger4"
			minetest.set_node(pos,node)
		end
	end,
	on_timer = function(pos)
		local meta = minetest.get_meta(pos)
		local eu_input = meta:get_int("HV_EU_input")
		if eu_input >= 5000 then
			local node = minetest.get_node(pos)
			minetest.set_node(pos, {name = "ufowreck:alien_health_charger8", param2=node.param2,})
		end
	end,
})

minetest.register_node("ufowreck:alien_health_charger8", {
	description = "Alien Charger",
	tiles = {
		"scifi_nodes_lighttop.png",
		"scifi_nodes_lighttop.png",
		"scifi_nodes_lighttop.png",
		"scifi_nodes_lighttop.png",
		"scifi_nodes_lighttop.png",
		"healthcharger_front.png^technic_power_meter8.png"
	},
	light_source = 5,
	groups = {cracky=2, technic_machine = 1, technic_hv = 1},
	connect_sides = {"top", "bottom", "back", "left", "right"},
	paramtype2 = "facedir",
	sounds = default.node_sound_metal_defaults(),
	drop = "ufowreck:alien_health_charger0",
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", "Alien Charger")
--		meta:set_int("HV_EU_demand", 5000)
	end,
	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		if player:get_hp() < 20 then
			minetest.sound_play("beep")
			stamina.change(player, 20)
			player:set_hp(player:get_hp() + 10)
			node.name = "ufowreck:alien_health_charger6"
			minetest.set_node(pos,node)
		end
	end,
})

technic.register_machine("HV", "ufowreck:alien_health_charger0", technic.receiver)
technic.register_machine("HV", "ufowreck:alien_health_charger2", technic.receiver)
technic.register_machine("HV", "ufowreck:alien_health_charger4", technic.receiver)
technic.register_machine("HV", "ufowreck:alien_health_charger6", technic.receiver)
technic.register_machine("HV", "ufowreck:alien_health_charger8", technic.receiver)
