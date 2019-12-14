minetest.register_node("fnuclear:lamp", {
	description = "Uranium Lamp",
	tiles = {"uranium_lamp.png"},
	paramtype = "light",
	light_source = LIGHT_MAX,
	groups = {cracky = 2, oddly_breakable_by_hand = 3},
	sounds = default.node_sound_glass_defaults(),
})

minetest.register_craft({
	output = "fnuclear:lamp",
	recipe = {
	{"technic:lead_ingot", "technic:lead_ingot", "technic:lead_ingot"},
	{"technic:lead_ingot", "technic:uranium0_block", "technic:lead_ingot"},
	{"technic:lead_ingot", "technic:lead_ingot", "technic:lead_ingot"}
  }
})

minetest.register_tool("fnuclear:uranium_pick", {
	description = "Uranium Pickaxe",
	inventory_image = "uranium_pickaxe.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level=3,
		groupcaps={
			cracky = {times={[1]=2.0, [2]=1.0, [3]=0.50}, uses=30, maxlevel=3},
		},
		damage_groups = {fleshy=5},
	},
	paramtype = "light",
	light_source = 12,
	sound = {breaks = "default_tool_breaks"},
})

minetest.register_craft({
	output = "fnuclear:uranium_pick",
	recipe = {
	{"technic:uranium0_ingot", "technic:uranium0_ingot", "technic:uranium0_ingot"},
	{"", "default:stick", ""},
	{"", "default:stick", ""}
  }
})

minetest.register_tool("fnuclear:uranium_axe", {
	description = "Uranium Axe",
	inventory_image = "uranium_axe.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level=1,
		groupcaps={
			choppy={times={[1]=2.10, [2]=0.90, [3]=0.50}, uses=30, maxlevel=3},
		},
		damage_groups = {fleshy=7},
	},
	paramtype = "light",
	light_source = 12,
	sound = {breaks = "default_tool_breaks"},
})

minetest.register_craft({
	output = "fnuclear:uranium_axe",
	recipe = {
	{"", "technic:uranium0_ingot", ""},
	{"technic:uranium0_ingot", "default:gold_ingot", "technic:uranium0_ingot"},
	{"", "default:gold_ingot", ""}
  }
})

minetest.register_tool("fnuclear:uranium_shovel", {
	description = "Uranium Shovel",
	inventory_image = "uranium_shovel.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			crumbly = {times={[1]=1.10, [2]=0.50, [3]=0.30}, uses=30, maxlevel=3},
		},
		damage_groups = {fleshy=4},
	},
	paramtype = "light",
	light_source = 12,
	sound = {breaks = "default_tool_breaks"},
})

minetest.register_craft({
	output = "fnuclear:uranium_shovel",
	recipe = {
	{"technic:uranium0_ingot", "", ""},
	{"default:stick", "", ""},
	{"moreores:silver_ingot", "", ""}
  }
})

minetest.register_tool("fnuclear:uranium_sword", {
	description = "Uranium Sword",
	inventory_image = "uranium_sword.png",
	tool_capabilities = {
		full_punch_interval = 0.7,
		max_drop_level=1,
		groupcaps={
			snappy={times={[1]=1.90, [2]=0.90, [3]=0.30}, uses=40, maxlevel=3},
		},
		damage_groups = {fleshy=8},
	},
	paramtype = "light",
	light_source = 12,
	sound = {breaks = "default_tool_breaks"},
})

minetest.register_craft({
	output = "fnuclear:uranium_sword",
	recipe = {
	{"technic:uranium0_ingot", "", ""},
	{"technic:uranium0_ingot", "", ""},
	{"default:bronze_ingot", "", ""}
  }
})

minetest.register_tool("fnuclear:uranium_crowbar", {
	description = "Uranium Crowbar",
	inventory_image = "uranium_crowbar.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level=1,
		groupcaps={
			choppy={times={[1]=2.10, [2]=0.90, [3]=0.50}, uses=50, maxlevel=3},
		},
		damage_groups = {fleshy=10},
	},
	paramtype = "light",
	light_source = 12,
	sound = {breaks = "default_tool_breaks"},
})

minetest.register_craft({
	output = "fnuclear:uranium_crowbar",
	recipe = {
	{"", "technic:uranium0_ingot", ""},
	{"", "technic:uranium0_ingot", ""},
	{"", "technic:uranium0_ingot", ""}
  }
})

minetest.register_node("fnuclear:toxic_barrel", {
	description = "Toxic Barrel",
	tiles = {"toxic_barrel.png" },
	drawtype = "mesh",
	mesh = "wine_barrel.obj",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {
		choppy = 2, oddly_breakable_by_hand = 1,
		tubedevice = 1, tubedevice_receiver = 1
	},
	tube = {
		insert_object = function(pos, node, stack, direction)
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			return inv:add_item("main", stack)
		end,
		can_insert = function(pos, node, stack, direction)
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			if meta:get_int("splitstacks") == 1 then
				stack = stack:peek_item(1)
			end
			return inv:room_for_item("main", stack)
		end,
		input_inventory = "main",
		connect_sides = {left = 1, right = 1, back = 1, bottom = 1, top = 1}
	},
	legacy_facedir_simple = true,
	on_place = minetest.rotate_node,
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec",
				"size[8,9;]"..
				"list[current_name;main;0,0;8,4;]"..
				"list[current_player;main;0,5;8,4;]")
		meta:set_string("infotext", "Toxic Barrel")
		meta:set_float("status", 0.0)
		local inv = meta:get_inventory()
		inv:set_size("main", 8 * 4)
	end,

})

minetest.register_craft({
	output = "fnuclear:toxic_barrel",
	recipe = {
		{"technic:lead_ingot", "", "technic:lead_ingot"},
		{"technic:lead_ingot", "", "technic:lead_ingot"},
		{"technic:lead_ingot", "technic:lead_ingot", "technic:lead_ingot"},
	},
})
