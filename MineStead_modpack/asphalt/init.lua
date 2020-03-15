minetest.register_node("asphalt:asphalt", {
	description = "Asphalt",
	tiles = { "streets_asphalt.png" },
	groups = {cracky = 2},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_craft({
    output = "asphalt:asphalt",
	type = "cooking",
	recipe = "default:gravel",
	cooktime = 2
})

if minetest.get_modpath("stairs") then
	stairs.register_all("asphalt", "asphalt:asphalt",
		{cracky = 2},
		{"streets_asphalt.png"},
		"Asphalt",
		stairs.stone)
end

minetest.register_node("asphalt:manhole", {
	description = "Manhole",
	tiles = {
		"streets_asphalt.png^streets_manhole.png",
		"streets_asphalt.png",
		"streets_asphalt.png",
		"streets_asphalt.png",
		"streets_asphalt.png",
		"streets_asphalt.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {cracky = 2},
	on_rightclick = function(pos, node, name)
		node.name = node.name .. "_open"
		minetest.set_node(pos, node)
	end,
	sunlight_propagates = true,
	node_box = {
		type = "fixed",
		fixed = {
			{ -0.5, -0.5, -0.5, 0.5, 0.5, -0.375 }, -- F
			{ -0.5, -0.5, 0.375, 0.5, 0.5, 0.5 }, -- B
			{ -0.5, -0.5, -0.4375, -0.375, 0.5, 0.4375 }, -- L
			{ 0.375, -0.5, -0.4375, 0.5, 0.5, 0.4375 }, -- R
			{ -0.25, 0.4375, -0.25, 0.25, 0.5, 0.25 }, -- CenterPlate
			{ -0.5, 0.4375, -0.0625, 0.5, 0.5, 0.0625 }, -- CenterLR
			{ -0.0625, 0.4375, -0.5, 0.0625, 0.5, 0.5 }, -- CenterFR
		}
	},
})

minetest.register_node("asphalt:manhole_open", {
	tiles = {
		"streets_asphalt.png^streets_manhole.png",
		"streets_asphalt.png",
		"streets_asphalt.png",
		"streets_asphalt.png",
		"streets_asphalt.png",
		"streets_asphalt.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	climbable = true,
	drop = "asphalt:manhole",
	groups = { cracky = 2, not_in_creative_inventory = 1 },
	on_rightclick = function(pos, node, name)
		node.name = string.sub(node.name, 1, -6)
		minetest.set_node(pos, node)
	end,
	sunlight_propagates = true,
	node_box = {
		type = "fixed",
		fixed = {
			{ -0.5, -0.5, -0.5, 0.5, 0.5, -0.375 }, -- F
			{ -0.5, -0.5, 0.375, 0.5, 0.5, 0.5 }, -- B
			{ -0.5, -0.5, -0.4375, -0.375, 0.5, 0.4375 }, -- L
			{ 0.375, -0.5, -0.4375, 0.5, 0.5, 0.4375 }, -- R
		}
	},
})

minetest.register_craft({
	output = "asphalt:manhole 2",
	type = "shapeless",
	recipe = { "asphalt:asphalt", "default:steel_ingot", "asphalt:asphalt" }
})

minetest.register_node("asphalt:stormdrain", {
	description = "Stormdrain",
	tiles = {
		"streets_asphalt.png^streets_stormdrain.png",
		"streets_asphalt.png",
		"streets_asphalt.png",
		"streets_asphalt.png",
		"streets_asphalt.png",
		"streets_asphalt.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = { cracky = 2 },
	sunlight_propagates = true,
	node_box = {
		type = "fixed",
		fixed = {
			{ -0.5, -0.5, -0.5, 0.5, 0.5, -0.4375 }, -- F
			{ -0.5, -0.5, 0.4375, 0.5, 0.5, 0.5 }, -- B
			{ -0.5, -0.5, -0.4375, -0.375, 0.5, 0.4375 }, -- L
			{ 0.375, -0.5, -0.4375, 0.5, 0.5, 0.4375 }, -- R
			{ -0.4375, 0.4375, 0, 0.4375, 0.5, 0.4375 }, -- T1
			{ -0.3125, 0.4375, -0.4375, -0.25, 0.5, 0 }, -- S1
			{ 0.25, 0.4375, -0.4375, 0.3125, 0.5, 0 }, -- S2
			{ -0.1875, 0.4375, -0.4375, -0.125, 0.5, 0 }, -- S3
			{ 0.125, 0.4375, -0.4375, 0.1875, 0.5, 0 }, -- S4
			{ -0.0625, 0.4375, -0.3125, 0.0625, 0.5, 0 }, -- S5
			{ -0.125, 0.4375, -0.375, 0.125, 0.5, -0.3125 }, -- S6
		}
	},
	selection_box = {
		type = "regular"
	}
})

minetest.register_craft({
	output = "asphalt:stormdrain",
	type = "shapeless",
	recipe = { "asphalt:asphalt", "default:steel_ingot"}
})

minetest.register_node("asphalt:asphalt_center_line", {
	description = "Asphalt Center Line",
	paramtype2 = "facedir",
	tiles = {
		"streets_asphalt.png^streets_solid_center_line_wide.png",
		"streets_asphalt.png",
		"streets_asphalt.png",
		"streets_asphalt.png",
		"streets_asphalt.png",
		"streets_asphalt.png"
	},
	groups = {cracky = 2},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_craft({
	output = "asphalt:asphalt_center_line 6",
	recipe = {
	{"asphalt:asphalt", "dye:white", "asphalt:asphalt"},
	{"asphalt:asphalt", "dye:white", "asphalt:asphalt"},
	{"asphalt:asphalt", "dye:white", "asphalt:asphalt"},
  }
})

minetest.register_node("asphalt:asphalt_corner", {
	description = "Asphalt Corner",
	paramtype2 = "facedir",
	tiles = {
		"streets_asphalt.png^streets_solid_center_line_wide_corner.png",
		"streets_asphalt.png",
		"streets_asphalt.png",
		"streets_asphalt.png",
		"streets_asphalt.png",
		"streets_asphalt.png"
	},
	groups = {cracky = 2},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_craft({
	output = "asphalt:asphalt_corner 6",
	recipe = {
	{"asphalt:asphalt", "asphalt:asphalt", "asphalt:asphalt"},
	{"asphalt:asphalt", "dye:white", "dye:white"},
	{"asphalt:asphalt", "dye:white", "asphalt:asphalt"},
  }
})

minetest.register_node("asphalt:asphalt_cross", {
	description = "Asphalt Cross",
	paramtype2 = "facedir",
	tiles = {
		"streets_asphalt.png^streets_solid_center_line_wide_crossing.png",
		"streets_asphalt.png",
		"streets_asphalt.png",
		"streets_asphalt.png",
		"streets_asphalt.png",
		"streets_asphalt.png"
	},
	groups = {cracky = 2},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_craft({
	output = "asphalt:asphalt_cross 4",
	recipe = {
	{"asphalt:asphalt", "dye:white", "asphalt:asphalt"},
	{"dye:white", "dye:white", "dye:white"},
	{"asphalt:asphalt", "dye:white", "asphalt:asphalt"},
  }
})

minetest.register_node("asphalt:asphalt_tjunction", {
	description = "Asphalt Tjunction",
	paramtype2 = "facedir",
	tiles = {
		"streets_asphalt.png^streets_solid_center_line_wide_tjunction.png",
		"streets_asphalt.png",
		"streets_asphalt.png",
		"streets_asphalt.png",
		"streets_asphalt.png",
		"streets_asphalt.png"
	},
	groups = {cracky = 2},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_craft({
	output = "asphalt:asphalt_tjunction 5",
	recipe = {
	{"asphalt:asphalt", "dye:white", "asphalt:asphalt"},
	{"asphalt:asphalt", "dye:white", "dye:white"},
	{"asphalt:asphalt", "dye:white", "asphalt:asphalt"},
  }
})

minetest.register_node("asphalt:asphalt_stripe", {
	description = "Asphalt Stripe",
	paramtype2 = "facedir",
	tiles = {
		"streets_asphalt.png^streets_solid_stripe.png",
		"streets_asphalt.png",
		"streets_asphalt.png",
		"streets_asphalt.png",
		"streets_asphalt.png",
		"streets_asphalt.png"
	},
	groups = {cracky = 2},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_craft({
	output = "asphalt:asphalt_stripe 6",
	recipe = {
	{"asphalt:asphalt", "asphalt:asphalt", "asphalt:asphalt"},
	{"dye:white", "dye:white", "dye:white"},
	{"asphalt:asphalt", "asphalt:asphalt", "asphalt:asphalt"},
  }
})

minetest.register_node("asphalt:manhole_2", {
	description = "Round Manhole",
	tiles = {
		"streets_asphalt.png^streets_manhole2.png",
		"streets_asphalt.png",
		"streets_asphalt.png",
		"streets_asphalt.png",
		"streets_asphalt.png",
		"streets_asphalt.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = { cracky = 2 },
	sunlight_propagates = true,
	climbable = true,
	walkable = false,
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_craft({
	output = "asphalt:manhole_2",
	type = "shapeless",
	recipe = { "asphalt:asphalt", "default:steel_ingot", "default:steel_ingot" }
})
