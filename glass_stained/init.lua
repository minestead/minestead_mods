local alias = {
	"one",
	"two",
	"three",
	"four",
	"five",
	"six",
	"seven",
	"eight",
	"nine",
	"ten",
	"eleven",
	"twelve"
}

local crafting = {
	{"blue", "blue", "blue"},
	{"red", "blue", "white"},
	{"yellow", "blue", "blue"},
	{"yellow", "red", "red"},
	{"violet", "red", "blue"},
	{"violet", "blue", "blue"},
	{"red", "violet", "blue"},
	{"blue", "yellow", "dark_green"},
	{"blue", "red", "yellow"},
	{"dark_green", "cyan", "yellow"},
	{"blue", "dark_green", "dark_green"},
	{"yellow", "cyan", "cyan"},
	{"blue", "dark_green", "yellow"},
	{"dark_green", "blue", "white"},
	{"red", "red", "dark_green"},
	{"blue", "blue", "cyan"},
	{"red", "dark_green", "yellow"},
	{"violet", "yellow", "dark_green"},
}

local nodeboxes = {
	single = {{-0.5, -0.5, 0, 0.5, 0.5, 0}},
	double = {{-0.5, -0.5, 0, 0.5, 1.5, 0}},
	triple = {{-0.5, -0.5, 0, 0.5, 1.5, 0}, {0.5, -0.5, 0, 1.5, 0.5, 0}},
	quadruple = {{-0.5, -0.5, 0, 1.5, 1.5, 0}},
	noncuple = {{-1.5, -1.5, 0, 1.5, 1.5, 0}},
	offset = {{-0.5, -0.5, 1, 0.5, 0.5, 1}}
}

local thick_nodeboxes = {
	single = {{-0.5, -0.5, -0.03125, 0.5, 0.5, 0.03125}},
	double = {{-0.5, -0.5, -0.03125, 0.5, 1.5, 0.03125}},
	triple = {{-0.5, -0.5, -0.03125, 0.5, 1.5, 0.03125}, {-0.5, -0.5, -0.03125, 1.5, 0.5, 0.03125}},
	quadruple = {{-0.5, -0.5, -0.03125, 1.5, 1.5, 0.03125}},
	noncuple = {{-1.5, -1.5, -0.03125, 1.5, 1.5, 0.03125}},
	offset = {{-0.5, -0.5, 0.96875, 0.5, 0.5, 1.03125}}
}

local selection_boxes = {
	single = {{-0.5, -0.5, -0.25, 0.5, 0.5, 0.25}},
	double = {{-0.5, -0.5, -0.25, 0.5, 1.5, 0.25}},
	triple = {{-0.5, -0.5, -0.25, 0.5, 1.5, 0.25}, {-0.5, -0.5, -0.25, 1.5, 0.5, 0.25}},
	quadruple = {{-0.5, -0.5, -0.25, 1.5, 1.5, 0.25}},
	noncuple = {{-1.5, -1.5, -0.25, 1.5, 1.5, 0.25}},
	offset = {{-0.5, -0.5, 0.75, 0.5, 0.5, 1.25}}
}

local panes = {
	{
		"glass",
		"Glass Pane",
		"default_glass.png",
		"glass_stained_edge.png",
		default.node_sound_glass_defaults(),
		{
			{"xpanes:pane_flat", "xpanes:pane_flat"},
			{"xpanes:pane_flat", "xpanes:pane_flat"}
		},
		"4"
	},
	{
		"obsidian_glass",
		"Obsidian Glass Pane",
		"default_obsidian_glass.png",
		"xpanes_edge_obsidian.png",
		default.node_sound_glass_defaults(),
		{
			{"xpanes:obsidian_pane_flat", "xpanes:obsidian_pane_flat"},
			{"xpanes:obsidian_pane_flat", "xpanes:obsidian_pane_flat"}
		},
		"4"
	},
	{
		"bar",
		"Steel Bars",
		"xpanes_bar.png",
		"xpanes_bar_top.png",
		default.node_sound_metal_defaults(),
		{
			{"xpanes:bar_flat", "xpanes:bar_flat"},
			{"xpanes:bar_flat", "xpanes:bar_flat"}
		},
		"4"
	},
}

local function define_crafts(pane, main_craft, main_output)
	single_pane = pane.."_single"
	
	minetest.register_craft({
		output = single_pane.." "..main_output,
		recipe = main_craft,
	})
	
	minetest.register_craft({
		output = pane.."_double",
		recipe = {
			{single_pane},
			{single_pane}
		},
	})
	
	minetest.register_craft({
		output = single_pane.." 2",
		recipe = {
			{pane.."_double"}
		},
	})
	
	minetest.register_craft({
		output = pane.."_triple",
		recipe = {
			{single_pane, ""},
			{single_pane, single_pane}
		},
	})
	
	minetest.register_craft({
		output = single_pane.." 3",
		recipe = {
			{pane.."_triple"}
		},
	})
	
	minetest.register_craft({
		output = pane.."_quadruple",
		recipe = {
			{single_pane, single_pane},
			{single_pane, single_pane}
		},
	})
	
	minetest.register_craft({
		output = single_pane.." 4",
		recipe = {
			{pane.."_quadruple"}
		},
	})
	
	minetest.register_craft({
		output = pane.."_noncuple",
		recipe = {
			{single_pane, single_pane, single_pane},
			{single_pane, single_pane, single_pane},
			{single_pane, single_pane, single_pane}
		},
	})
	
	minetest.register_craft({
		output = single_pane.." 9",
		recipe = {
			{pane.."_noncuple"}
		},
	})
	
	minetest.register_craft({
		output = pane.."_offset",
		recipe = {
			{single_pane}
		},
	})
	
	minetest.register_craft({
		output = single_pane,
		recipe = {
			{pane.."_offset"}
		},
	})
end

for name, selection_box in pairs(selection_boxes) do
	for node = 1, 18 do
		minetest.register_node("glass_stained:glass_"..node.."_"..name, {
			description = "Stained Glass "..node.." ("..name:sub(1, 1):upper()..name:sub(2, -1)..")",
			drawtype = "nodebox",
			tiles = {"glass_stained_"..node..".png"},
			wield_image = "glass_stained_"..node..".png",
			paramtype = "light",
			paramtype2 = "facedir",
			sunlight_propagates = true,
			is_ground_content = false,
			node_box = {
				type = "fixed",
				fixed = nodeboxes[name],
			},
			selection_box = {
				type = "fixed",
				fixed = selection_box,
			},
			groups = {cracky = 3, oddly_breakable_by_hand = 3},
			use_texture_alpha = true,
			sounds = default.node_sound_glass_defaults()
		})
		
		if name == "noncuple" then
			define_crafts("glass_stained:glass_"..node, {
				{"dye:"..crafting[node][1], "xpanes:pane_flat"},
				{"dye:"..crafting[node][2], "xpanes:pane_flat"},
				{"dye:"..crafting[node][3], "xpanes:pane_flat"}
			}, "3")
		end
		
		if node <= 12 then
			minetest.register_alias("glass_stained:glass_number_"..alias[node], "glass_stained:glass_"..node.."single")
			minetest.register_alias("glass_stained:glass_number_"..alias[node].."top", "glass_stained:glass_"..node.."double")
		end
	end
	
	for _, pane in ipairs(panes) do
		minetest.register_node("glass_stained:pane_"..pane[1].."_"..name, {
			description = pane[2].." ("..name:sub(1, 1):upper()..name:sub(2, -1)..")",
			drawtype = "nodebox",
			tiles = {pane[4], pane[4], pane[3]},
			wield_image = pane[3],
			paramtype = "light",
			paramtype2 = "facedir",
			sunlight_propagates = true,
			is_ground_content = false,
			node_box = {
				type = "fixed",
				fixed = thick_nodeboxes[name],
			},
			selection_box = {
				type = "fixed",
				fixed = selection_box,
			},
			groups = {cracky = 3, oddly_breakable_by_hand = 3},
			sounds = pane[5]
		})
		
		if name == "noncuple" then
			define_crafts("glass_stained:pane_"..pane[1], pane[6], pane[7])
		end
	end
end

minetest.register_alias("glass_stained:glass_normal", "glass_stained:pane_glass_single")
minetest.register_alias("glass_stained:glass_normal_top", "glass_stained:pane_glass_double")
minetest.register_alias("glass_stained:obsidian_glass_normal", "glass_stained:pane_obsidian_glass_single")
minetest.register_alias("glass_stained:obsidian_glass_normal_top", "glass_stained:pane_obsidian_glass_double")
minetest.register_alias("glass_stained:steel_bars_normal", "glass_stained:pane_bar_single")
minetest.register_alias("glass_stained:steel_bars_normal_top", "glass_stained:pane_bar_double")
minetest.register_alias("glass_stained:steel_bars_fancy", "glass_stained:pane_bar_top_pane_single")

xpanes.register_pane("bar_top", {
	description = "Spiked Steel Railing",
	textures = {"glass_stained_bar_fancy.png", "xpanes_pane_half.png", "default_glass_detail.png"},
	inventory_image = "glass_stained_bar_fancy.png",
	wield_image = "glass_stained_bar_fancy.png",
	groups = {cracky = 2},
	sounds = default.node_sound_metal_defaults(),
	recipe = {
		{"", "default:steel_ingot", ""},
		{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
		{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"}
	}
})

xpanes.register_pane("pane", {
	description = "Glass Pane",
	textures = {"default_glass.png","xpanes_pane_half.png","glass_stained_edge.png"},
	inventory_image = "default_glass.png",
	wield_image = "default_glass.png",
	sounds = default.node_sound_glass_defaults(),
	groups = {snappy = 2, cracky = 3, oddly_breakable_by_hand = 3},
	recipe = {
		{"default:glass", "default:glass", "default:glass"},
		{"default:glass", "default:glass", "default:glass"}
	}
})

xpanes.register_pane("obsidian_pane", {
	description = "Obsidian Glass Pane",
	textures = {"default_obsidian_glass.png","xpanes_pane_half.png","xpanes_edge_obsidian.png"},
	inventory_image = "default_obsidian_glass.png",
	wield_image = "default_obsidian_glass.png",
	sounds = default.node_sound_glass_defaults(),
	groups = {snappy = 2, cracky = 3},
	recipe = {
		{"default:obsidian_glass", "default:obsidian_glass", "default:obsidian_glass"},
		{"default:obsidian_glass", "default:obsidian_glass", "default:obsidian_glass"}
	}
})

minetest.register_node("glass_stained:pane_bar_top_pane_single", {
	description = "Spiked Steel Railing Pane (Single)",
	drawtype = "nodebox",
	tiles = {"blank.png", "blank.png", "glass_stained_bar_fancy.png"},
	wield_image = "glass_stained_bar_fancy.png",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	is_ground_content = false,
	node_box = {
		type = "fixed",
		fixed = thick_nodeboxes["single"],
	},
	selection_box = {
		type = "fixed",
		fixed = selection_boxes["single"],
	},
	groups = {cracky = 3, oddly_breakable_by_hand = 3},
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_node("glass_stained:pane_bar_top_pane_offset", {
	description = "Spiked Steel Railing Pane (Offset)",
	drawtype = "nodebox",
	tiles = {"blank.png", "blank.png", "glass_stained_bar_fancy.png"},
	wield_image = "glass_stained_bar_fancy.png",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	is_ground_content = false,
	node_box = {
		type = "fixed",
		fixed = thick_nodeboxes["offset"],
	},
	selection_box = {
		type = "fixed",
		fixed = selection_boxes["offset"],
	},
	groups = {cracky = 3, oddly_breakable_by_hand = 3},
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_craft({
	output = "glass_stained:pane_bar_top_pane_single",
	recipe = {
		{"xpanes:bar_top_flat"}
	},
})

minetest.register_craft({
	output = "glass_stained:pane_bar_top_pane_offset",
	recipe = {
		{"glass_stained:pane_bar_top_pane_single"}
	},
})

minetest.register_craft({
	output = "glass_stained:pane_bar_top_pane_single",
	recipe = {
		{"glass_stained:pane_bar_top_pane_offset"}
	},
})