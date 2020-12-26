doors.register("door_copper_1", {
	tiles = {{ name = "door_base_1.png^[colorize:#ff780077", backface_culling = true }},
	description = "Copper Door One",
	inventory_image = "door_base_1_inv.png^[colorize:#ff780077",
	groups = {cracky = 2},
	recipe = {
		{"default:copper_ingot", "default:copper_ingot", ""},
		{"default:copper_ingot", "","default:copper_ingot"},
		{"default:copper_ingot", "default:copper_ingot", ""},
	}
})

doors.register("door_copper_2", {
	tiles = {{ name = "door_base_2.png^[colorize:#ff780077", backface_culling = true }},
	description = "Copper Door Two",
	inventory_image = "door_base_2_inv.png^[colorize:#ff780077",
	groups = {cracky = 2},
	recipe = {
		{"default:copper_ingot", "","default:copper_ingot"},
		{"default:copper_ingot", "default:copper_ingot", ""},
		{"default:copper_ingot", "default:copper_ingot", ""},
	}
})

doors.register("door_copper_3", {
	tiles = {{ name = "door_base_3.png^[colorize:#ff780077", backface_culling = true }},
	description = "Copper Door Three",
	inventory_image = "door_base_3_inv.png^[colorize:#ff780077",
	groups = {cracky = 2},
	recipe = {
		{"default:copper_ingot", "","default:copper_ingot"},
		{"default:copper_ingot", "","default:copper_ingot"},
		{"default:copper_ingot", "default:copper_ingot", ""},
	}
})

doors.register_trapdoor("more_metal_stuff:trapdoor_copper_bar", {
	description = "Copper Bar Trapdoor",
	inventory_image = "trapdoor_steel_bar.png^[colorize:#ff780077",
	wield_image = "trapdoor_steel_bar.png^[colorize:#ff780077",
	tile_front = "trapdoor_steel_bar.png^[colorize:#ff780077",
	tile_side = "trapdoor_steel_bar_side.png^[colorize:#ff780077",
	groups = {cracky = 2},
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_craft({
	output = "more_metal_stuff:trapdoor_copper_bar",
	recipe = {
		{"default:copper_ingot", "default:copper_ingot"},
		{"default:copper_ingot", "default:copper_ingot"},
	},
})

doors.register("door_zinc_1", {
	tiles = {{ name = "door_base_1.png^[colorize:#00a8ff77", backface_culling = true }},
	description = "Zinc Door One",
	inventory_image = "door_base_1_inv.png^[colorize:#00a8ff77",
	groups = {cracky = 2},
	recipe = {
		{"technic:zinc_ingot", "technic:zinc_ingot", ""},
		{"technic:zinc_ingot", "","technic:zinc_ingot"},
		{"technic:zinc_ingot", "technic:zinc_ingot", ""},
	}
})

doors.register("door_zinc_2", {
	tiles = {{ name = "door_base_2.png^[colorize:#00a8ff77", backface_culling = true }},
	description = "Zinc Door Two",
	inventory_image = "door_base_2_inv.png^[colorize:#00a8ff77",
	groups = {cracky = 2},
	recipe = {
		{"technic:zinc_ingot", "","technic:zinc_ingot"},
		{"technic:zinc_ingot", "technic:zinc_ingot", ""},
		{"technic:zinc_ingot", "technic:zinc_ingot", ""},
	}
})

doors.register("door_zinc_3", {
	tiles = {{ name = "door_base_3.png^[colorize:#00a8ff77", backface_culling = true }},
	description = "Zinc Door Three",
	inventory_image = "door_base_3_inv.png^[colorize:#00a8ff77",
	groups = {cracky = 2},
	recipe = {
		{"technic:zinc_ingot", "","technic:zinc_ingot"},
		{"technic:zinc_ingot", "","technic:zinc_ingot"},
		{"technic:zinc_ingot", "technic:zinc_ingot", ""},
	}
})

doors.register_trapdoor("more_metal_stuff:trapdoor_zinc_bar", {
	description = "Zinc Bar Trapdoor",
	inventory_image = "trapdoor_steel_bar.png^[colorize:#00a8ff77",
	wield_image = "trapdoor_steel_bar.png^[colorize:#00a8ff77",
	tile_front = "trapdoor_steel_bar.png^[colorize:#00a8ff77",
	tile_side = "trapdoor_steel_bar_side.png^[colorize:#00a8ff77",
	groups = {cracky = 2},
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_craft({
	output = "more_metal_stuff:trapdoor_zinc_bar",
	recipe = {
		{"technic:zinc_ingot", "technic:zinc_ingot"},
		{"technic:zinc_ingot", "technic:zinc_ingot"},
	},
})

doors.register("door_chromium_1", {
	tiles = {{ name = "door_base_1.png^[colorize:#a0feff77", backface_culling = true }},
	description = "Chromium Door One",
	inventory_image = "door_base_1_inv.png^[colorize:#a0feff77",
	groups = {cracky = 2},
	recipe = {
		{"technic:chromium_ingot", "technic:chromium_ingot", ""},
		{"technic:chromium_ingot", "","technic:chromium_ingot"},
		{"technic:chromium_ingot", "technic:chromium_ingot", ""},
	}
})

doors.register("door_chromium_2", {
	tiles = {{ name = "door_base_2.png^[colorize:#a0feff77", backface_culling = true }},
	description = "Chromium Door Two",
	inventory_image = "door_base_2_inv.png^[colorize:#a0feff77",
	groups = {cracky = 2},
	recipe = {
		{"technic:chromium_ingot", "","technic:chromium_ingot"},
		{"technic:chromium_ingot", "technic:chromium_ingot", ""},
		{"technic:chromium_ingot", "technic:chromium_ingot", ""},
	}
})

doors.register("door_chromium_3", {
	tiles = {{ name = "door_base_3.png^[colorize:#a0feff77", backface_culling = true }},
	description = "Chromium Door Three",
	inventory_image = "door_base_3_inv.png^[colorize:#a0feff77",
	groups = {cracky = 2},
	recipe = {
		{"technic:chromium_ingot", "","technic:chromium_ingot"},
		{"technic:chromium_ingot", "","technic:chromium_ingot"},
		{"technic:chromium_ingot", "technic:chromium_ingot", ""},
	}
})

doors.register_trapdoor("more_metal_stuff:trapdoor_chromium_bar", {
	description = "Chromium Bar Trapdoor",
	inventory_image = "trapdoor_steel_bar.png^[colorize:#a0feff77",
	wield_image = "trapdoor_steel_bar.png^[colorize:#a0feff77",
	tile_front = "trapdoor_steel_bar.png^[colorize:#a0feff77",
	tile_side = "trapdoor_steel_bar_side.png^[colorize:#a0feff77",
	groups = {cracky = 2},
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_craft({
	output = "more_metal_stuff:trapdoor_chromium_bar",
	recipe = {
		{"technic:chromium_ingot", "technic:chromium_ingot"},
		{"technic:chromium_ingot", "technic:chromium_ingot"},
	},
})

doors.register("door_uranium_1", {
	tiles = {{ name = "door_base_1.png^[colorize:#18ff0077", backface_culling = true }},
	description = "Uranium Door One",
	inventory_image = "door_base_1_inv.png^[colorize:#18ff0077",
	groups = {cracky = 2},
	recipe = {
		{"technic:uranium0_ingot", "technic:uranium0_ingot", ""},
		{"technic:uranium0_ingot", "","technic:uranium0_ingot"},
		{"technic:uranium0_ingot", "technic:uranium0_ingot", ""},
	}
})

doors.register("door_uranium_2", {
	tiles = {{ name = "door_base_2.png^[colorize:#18ff0077", backface_culling = true }},
	description = "Uranium Door Two",
	inventory_image = "door_base_2_inv.png^[colorize:#18ff0077",
	groups = {cracky = 2},
	recipe = {
		{"technic:uranium0_ingot", "","technic:uranium0_ingot"},
		{"technic:uranium0_ingot", "technic:uranium0_ingot", ""},
		{"technic:uranium0_ingot", "technic:uranium0_ingot", ""},
	}
})

doors.register("door_uranium_3", {
	tiles = {{ name = "door_base_3.png^[colorize:#18ff0077", backface_culling = true }},
	description = "Uranium Door Three",
	inventory_image = "door_base_3_inv.png^[colorize:#18ff0077",
	groups = {cracky = 2},
	recipe = {
		{"technic:uranium0_ingot", "","technic:uranium0_ingot"},
		{"technic:uranium0_ingot", "","technic:uranium0_ingot"},
		{"technic:uranium0_ingot", "technic:uranium0_ingot", ""},
	}
})

doors.register_trapdoor("more_metal_stuff:trapdoor_uranium_bar", {
	description = "Uranium Bar Trapdoor",
	inventory_image = "trapdoor_steel_bar.png^[colorize:#18ff0077",
	wield_image = "trapdoor_steel_bar.png^[colorize:#18ff0077",
	tile_front = "trapdoor_steel_bar.png^[colorize:#18ff0077",
	tile_side = "trapdoor_steel_bar_side.png^[colorize:#18ff0077",
	groups = {cracky = 2},
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_craft({
	output = "more_metal_stuff:trapdoor_uranium_bar",
	recipe = {
		{"technic:uranium0_ingot", "technic:uranium0_ingot"},
		{"technic:uranium0_ingot", "technic:uranium0_ingot"},
	},
})

doors.register_trapdoor("more_metal_stuff:trapdoor_steel_vent", {
	description = "Vent Trapdoor",
	inventory_image = "vent.png",
	wield_image = "vent.png",
	tile_front = "vent.png",
	tile_side = "trapdoor_steel_bar_side.png",
	use_texture_alpha = true,
	groups = {cracky = 2},
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_craft({
	output = "more_metal_stuff:trapdoor_steel_vent",
	recipe = {
		{"basic_materials:steel_bar", "basic_materials:steel_bar"},
		{"basic_materials:steel_bar", "basic_materials:steel_bar"},
	},
})

minetest.register_craft({
	output = "basic_materials:steel_bar 6",
	recipe = {
		{"", "", "technic:lead_ingot"},
		{"", "technic:lead_ingot", ""},
		{"technic:lead_ingot", "", ""},
	},
})

minetest.register_craft({
	output = "basic_materials:steel_bar 6",
	recipe = {
		{"", "", "default:tin_ingot"},
		{"", "default:tin_ingot", ""},
		{"default:tin_ingot", "", ""},
	},
})

minetest.register_craft({
	output = "basic_materials:steel_bar 6",
	recipe = {
		{"", "", "moreores:silver_ingot"},
		{"", "moreores:silver_ingot", ""},
		{"moreores:silver_ingot", "", ""},
	},
})

--decorative ores

minetest.register_node("more_metal_stuff:deco_uranium_ore", {
	description = "Deco Uranium Ore",
	tiles = { "default_stone.png^technic_mineral_uranium.png" },
	paramtype = "light",
	is_ground_content = true,
	groups = {cracky = 3},
	light_source = 4,
	sounds = default.node_sound_stone_defaults(),
})

local recipes = {
	{"default:coal_lump", "default:stone", "default:stone_with_coal"},
	{"default:copper_lump", "default:stone", "default:stone_with_copper"},
	{"default:diamond", "default:stone", "default:stone_with_diamond"},
	{"default:gold_lump", "default:stone", "default:stone_with_gold"},
	{"default:iron_lump", "default:stone", "default:stone_with_iron"},
	{"default:mese_crystal", "default:stone", "default:stone_with_mese"},
	{"default:tin_lump", "default:stone", "default:stone_with_tin"},
	{"technic:chromium_lump", "default:stone", "technic:mineral_chromium"},	
	{"technic:lead_lump", "default:stone", "technic:mineral_lead"},	
	{"technic:sulfur_lump", "default:stone", "technic:mineral_sulfur"},
	{"technic:zinc_lump", "default:stone", "technic:mineral_zinc"},
	{"moreores:silver_lump", "default:stone", "moreores:mineral_silver"},
	{"moreores:mithril_lump", "default:stone", "moreores:mineral_mithril"},
	{"technic:uranium0_ingot", "default:stone", "more_metal_stuff:deco_uranium_ore"},
	{"technic:uranium0_ingot", "default:meselamp", "more_metal_stuff:uranium_mese_lamp"},
	{"technic:zinc_ingot", "default:meselamp", "more_metal_stuff:zinc_mese_lamp"},
	{"technic:uranium0_ingot", "default:glass", "more_metal_stuff:green_glass"},
}

for _, data in pairs(recipes) do
	technic.register_alloy_recipe({input = {data[1], data[2]}, output = data[3], time = data[4]})
end

-- ladder

minetest.register_node("more_metal_stuff:ladder_copper", {
	description = "Copper Ladder",
	drawtype = "signlike",
	tiles = {"default_ladder_steel.png^[colorize:#ff780077"},
	inventory_image = "default_ladder_steel.png^[colorize:#ff780077",
	wield_image = "default_ladder_steel.png^[colorize:#ff780077",
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	climbable = true,
	is_ground_content = false,
	selection_box = {
		type = "wallmounted",
	},
	groups = {cracky = 2},
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_craft({
	output = "more_metal_stuff:ladder_copper 15",
	recipe = {
		{"default:copper_ingot", "", "default:copper_ingot"},
		{"default:copper_ingot", "default:copper_ingot", "default:copper_ingot"},
		{"default:copper_ingot", "", "default:copper_ingot"},
	}
})

minetest.register_node("more_metal_stuff:ladder_gold", {
	description = "Gold Ladder",
	drawtype = "signlike",
	tiles = {"default_ladder_steel.png^[colorize:#fcff0077"},
	inventory_image = "default_ladder_steel.png^[colorize:#fcff0077",
	wield_image = "default_ladder_steel.png^[colorize:#fcff0077",
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	climbable = true,
	is_ground_content = false,
	selection_box = {
		type = "wallmounted",
	},
	groups = {cracky = 2},
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_craft({
	output = "more_metal_stuff:ladder_gold 15",
	recipe = {
		{"default:gold_ingot", "", "default:gold_ingot"},
		{"default:gold_ingot", "default:gold_ingot", "default:gold_ingot"},
		{"default:gold_ingot", "", "default:gold_ingot"},
	}
})

minetest.register_node("more_metal_stuff:ladder_chromium", {
	description = "Chromium Ladder",
	drawtype = "signlike",
	tiles = {"default_ladder_steel.png^[colorize:#a0feff77"},
	inventory_image = "default_ladder_steel.png^[colorize:#a0feff77",
	wield_image = "default_ladder_steel.png^[colorize:#a0feff77",
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	climbable = true,
	is_ground_content = false,
	selection_box = {
		type = "wallmounted",
	},
	groups = {cracky = 2},
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_craft({
	output = "more_metal_stuff:ladder_chromium 15",
	recipe = {
		{"technic:chromium_ingot", "", "technic:chromium_ingot"},
		{"technic:chromium_ingot", "technic:chromium_ingot", "technic:chromium_ingot"},
		{"technic:chromium_ingot", "", "technic:chromium_ingot"},
	}
})

minetest.register_node("more_metal_stuff:ladder_uranium", {
	description = "Uranium Ladder",
	drawtype = "signlike",
	tiles = {"default_ladder_steel.png^[colorize:#18ff0077"},
	inventory_image = "default_ladder_steel.png^[colorize:#18ff0077",
	wield_image = "default_ladder_steel.png^[colorize:#18ff0077",
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	climbable = true,
	is_ground_content = false,
	selection_box = {
		type = "wallmounted",
	},
	light_source = 8,
	groups = {cracky = 2},
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_craft({
	output = "more_metal_stuff:ladder_uranium 15",
	recipe = {
		{"technic:uranium0_ingot", "", "technic:uranium0_ingot"},
		{"technic:uranium0_ingot", "technic:uranium0_ingot", "technic:uranium0_ingot"},
		{"technic:uranium0_ingot", "", "technic:uranium0_ingot"},
	}
})

minetest.register_node("more_metal_stuff:ladder_zinc", {
	description = "Zinc Ladder",
	drawtype = "signlike",
	tiles = {"default_ladder_steel.png^[colorize:#00a8ff77"},
	inventory_image = "default_ladder_steel.png^[colorize:#00a8ff77",
	wield_image = "default_ladder_steel.png^[colorize:#00a8ff77",
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	climbable = true,
	is_ground_content = false,
	selection_box = {
		type = "wallmounted",
	},
	groups = {cracky = 2},
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_craft({
	output = "more_metal_stuff:ladder_zinc 15",
	recipe = {
		{"technic:zinc_ingot", "", "technic:zinc_ingot"},
		{"technic:zinc_ingot", "technic:zinc_ingot", "technic:zinc_ingot"},
		{"technic:zinc_ingot", "", "technic:zinc_ingot"},
	}
})

minetest.register_craft({
	output = "default:ladder_steel 15",
	recipe = {
		{"default:tin_ingot", "", "default:tin_ingot"},
		{"default:tin_ingot", "default:tin_ingot", "default:tin_ingot"},
		{"default:tin_ingot", "", "default:tin_ingot"},
	}
})

minetest.register_craft({
	output = "default:ladder_steel 15",
	recipe = {
		{"technic:lead_ingot", "", "technic:lead_ingot"},
		{"technic:lead_ingot", "technic:lead_ingot", "technic:lead_ingot"},
		{"technic:lead_ingot", "", "technic:lead_ingot"},
	}
})

minetest.register_craft({
	output = "default:ladder_steel 15",
	recipe = {
		{"moreores:silver_ingot", "", "moreores:silver_ingot"},
		{"moreores:silver_ingot", "moreores:silver_ingot", "moreores:silver_ingot"},
		{"moreores:silver_ingot", "", "moreores:silver_ingot"},
	}
})

-- lattice

minetest.register_node("more_metal_stuff:uranium_lattice", {
	description = "Uranium Lattice",
	tiles = {
		'techpack_stairway_lattice.png^[colorize:#18ff0077',
	},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-8/16, -8/16, -8/16, -7/16,  8/16,  8/16},
			{ 7/16, -8/16, -8/16,  8/16,  8/16,  8/16},
			{-8/16, -8/16, -8/16,  8/16, -7/16,  8/16},
			{-8/16,  7/16, -8/16,  8/16,  8/16,  8/16},
			{-8/16, -8/16, -8/16,  8/16,  8/16, -7/16},
			{-8/16, -8/16,  7/16,  8/16,  8/16,  8/16},
		},
	},

	selection_box = {
		type = "fixed",
		fixed = {-8/16, -8/16, -8/16,  8/16, 8/16, 8/16},
	},
	
	paramtype2 = "facedir",
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {cracky = 2},
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_craft({
	output = "more_metal_stuff:uranium_lattice",
	recipe = {
		{"technic:uranium0_ingot", "", "technic:uranium0_ingot"},
		{"", "technic:uranium0_ingot", ""},
		{"technic:uranium0_ingot", "", "technic:uranium0_ingot"},
	},
})

minetest.register_node("more_metal_stuff:zinc_lattice", {
	description = "Zinc Lattice",
	tiles = {
		'techpack_stairway_lattice.png^[colorize:#00a8ff77',
	},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-8/16, -8/16, -8/16, -7/16,  8/16,  8/16},
			{ 7/16, -8/16, -8/16,  8/16,  8/16,  8/16},
			{-8/16, -8/16, -8/16,  8/16, -7/16,  8/16},
			{-8/16,  7/16, -8/16,  8/16,  8/16,  8/16},
			{-8/16, -8/16, -8/16,  8/16,  8/16, -7/16},
			{-8/16, -8/16,  7/16,  8/16,  8/16,  8/16},
		},
	},

	selection_box = {
		type = "fixed",
		fixed = {-8/16, -8/16, -8/16,  8/16, 8/16, 8/16},
	},
	
	paramtype2 = "facedir",
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {cracky = 2},
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_craft({
	output = "more_metal_stuff:zinc_lattice",
	recipe = {
		{"technic:zinc_ingot", "", "technic:zinc_ingot"},
		{"", "technic:zinc_ingot", ""},
		{"technic:zinc_ingot", "", "technic:zinc_ingot"},
	},
})

minetest.register_node("more_metal_stuff:gold_lattice", {
	description = "Gold Lattice",
	tiles = {
		'techpack_stairway_lattice.png^[colorize:#fcff0077',
	},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-8/16, -8/16, -8/16, -7/16,  8/16,  8/16},
			{ 7/16, -8/16, -8/16,  8/16,  8/16,  8/16},
			{-8/16, -8/16, -8/16,  8/16, -7/16,  8/16},
			{-8/16,  7/16, -8/16,  8/16,  8/16,  8/16},
			{-8/16, -8/16, -8/16,  8/16,  8/16, -7/16},
			{-8/16, -8/16,  7/16,  8/16,  8/16,  8/16},
		},
	},

	selection_box = {
		type = "fixed",
		fixed = {-8/16, -8/16, -8/16,  8/16, 8/16, 8/16},
	},
	
	paramtype2 = "facedir",
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {cracky = 2},
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_craft({
	output = "more_metal_stuff:gold_lattice",
	recipe = {
		{"default:gold_ingot", "", "default:gold_ingot"},
		{"", "default:gold_ingot", ""},
		{"default:gold_ingot", "", "default:gold_ingot"},
	},
})

minetest.register_node("more_metal_stuff:chromium_lattice", {
	description = "Chromium Lattice",
	tiles = {
		'techpack_stairway_lattice.png^[colorize:#a0feff77',
	},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-8/16, -8/16, -8/16, -7/16,  8/16,  8/16},
			{ 7/16, -8/16, -8/16,  8/16,  8/16,  8/16},
			{-8/16, -8/16, -8/16,  8/16, -7/16,  8/16},
			{-8/16,  7/16, -8/16,  8/16,  8/16,  8/16},
			{-8/16, -8/16, -8/16,  8/16,  8/16, -7/16},
			{-8/16, -8/16,  7/16,  8/16,  8/16,  8/16},
		},
	},

	selection_box = {
		type = "fixed",
		fixed = {-8/16, -8/16, -8/16,  8/16, 8/16, 8/16},
	},
	
	paramtype2 = "facedir",
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {cracky = 2},
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_craft({
	output = "more_metal_stuff:chromium_lattice",
	recipe = {
		{"technic:chromium_ingot", "", "technic:chromium_ingot"},
		{"", "technic:chromium_ingot", ""},
		{"technic:chromium_ingot", "", "technic:chromium_ingot"},
	},
})

minetest.register_node("more_metal_stuff:copper_lattice", {
	description = "Copper Lattice",
	tiles = {
		'techpack_stairway_lattice.png^[colorize:#ff780077',
	},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-8/16, -8/16, -8/16, -7/16,  8/16,  8/16},
			{ 7/16, -8/16, -8/16,  8/16,  8/16,  8/16},
			{-8/16, -8/16, -8/16,  8/16, -7/16,  8/16},
			{-8/16,  7/16, -8/16,  8/16,  8/16,  8/16},
			{-8/16, -8/16, -8/16,  8/16,  8/16, -7/16},
			{-8/16, -8/16,  7/16,  8/16,  8/16,  8/16},
		},
	},

	selection_box = {
		type = "fixed",
		fixed = {-8/16, -8/16, -8/16,  8/16, 8/16, 8/16},
	},
	
	paramtype2 = "facedir",
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {cracky = 2},
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_craft({
	output = "more_metal_stuff:copper_lattice",
	recipe = {
		{"default:copper_ingot", "", "default:copper_ingot"},
		{"", "default:copper_ingot", ""},
		{"default:copper_ingot", "", "default:copper_ingot"},
	},
})

--square

minetest.register_node("more_metal_stuff:copper_square", {
	description = "Copper Square",
	tiles = {
		'metal_square.png^[colorize:#ff780077',
	},
	paramtype = "light",
	groups = {cracky = 2},
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_craft({
	output = "more_metal_stuff:copper_square 8",
	recipe = {
		{"default:copperblock", "default:copperblock", "default:copperblock"},
		{"default:copperblock", "", "default:copperblock"},
		{"default:copperblock", "default:copperblock", "default:copperblock"},
	},
})

minetest.register_craft({
	output = "default:copper_ingot 9",
	recipe = {
		{"more_metal_stuff:copper_square"},
	},
})

minetest.register_node("more_metal_stuff:chromium_square", {
	description = "Chromium Square",
	tiles = {
		'metal_square.png^[colorize:#a0feff77',
	},
	paramtype = "light",
	groups = {cracky = 2},
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_craft({
	output = "more_metal_stuff:chromium_square 8",
	recipe = {
		{"technic:chromium_block", "technic:chromium_block", "technic:chromium_block"},
		{"technic:chromium_block", "", "technic:chromium_block"},
		{"technic:chromium_block", "technic:chromium_block", "technic:chromium_block"},
	},
})

minetest.register_craft({
	output = "technic:chromium_ingot 9",
	recipe = {
		{"more_metal_stuff:chromium_square"},
	},
})

minetest.register_node("more_metal_stuff:uranium_square", {
	description = "Uranium Square",
	tiles = {
		'metal_square.png^[colorize:#18ff0077',
	},
	paramtype = "light",
	groups = {cracky = 2},
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_craft({
	output = "more_metal_stuff:uranium_square 8",
	recipe = {
		{"technic:uranium0_block", "technic:uranium0_block", "technic:uranium0_block"},
		{"technic:uranium0_block", "", "technic:uranium0_block"},
		{"technic:uranium0_block", "technic:uranium0_block", "technic:uranium0_block"},
	},
})

minetest.register_craft({
	output = "technic:uranium0_ingot 9",
	recipe = {
		{"more_metal_stuff:uranium_square"},
	},
})

minetest.register_node("more_metal_stuff:zinc_square", {
	description = "Zinc Square",
	tiles = {
		'metal_square.png^[colorize:#00a8ff77',
	},
	paramtype = "light",
	groups = {cracky = 2},
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_craft({
	output = "more_metal_stuff:zinc_square 8",
	recipe = {
		{"technic:zinc_block", "technic:zinc_block", "technic:zinc_block"},
		{"technic:zinc_block", "", "technic:zinc_block"},
		{"technic:zinc_block", "technic:zinc_block", "technic:zinc_block"},
	},
})

minetest.register_craft({
	output = "technic:zinc_ingot 9",
	recipe = {
		{"more_metal_stuff:zinc_square"},
	},
})

--light

minetest.register_node("more_metal_stuff:uranium_mese_lamp", {
	description = "Uranium Mese Lamp",
	sunlight_propagates = false,
	tiles = {
		"default_meselamp.png^[colorize:#18ff0077",
	},
	light_source = 14,
	paramtype = "light",
	groups = {cracky=1},
	sounds = default.node_sound_glass_defaults()
})

minetest.register_node("more_metal_stuff:zinc_mese_lamp", {
	description = "Zinc Mese Lamp",
	sunlight_propagates = false,
	tiles = {
		"default_meselamp.png^[colorize:#00a8ff77",
	},
	light_source = 14,
	paramtype = "light",
	groups = {cracky=1},
	sounds = default.node_sound_glass_defaults()
})

minetest.register_node("more_metal_stuff:green_glass", {
	description = "Green Glass",
	drawtype = "glasslike",
	sunlight_propagates = true,
	tiles = {"green_glass.png"},
	use_texture_alpha = true,
	paramtype = "light",
	groups = {cracky=2},
	sounds = default.node_sound_glass_defaults()
})
