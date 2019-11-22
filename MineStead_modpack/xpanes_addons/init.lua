xpanes.register_pane("glow_obsidian_pane", {
	description = "Glow Obsidian Glass Pane",
	textures = {"caverealms_glow_obsidian_glass.png","xpanes_pane_half.png","xpanes_edge_obsidian.png"},
	inventory_image = "caverealms_glow_obsidian_glass.png",
	wield_image = "caverealms_glow_obsidian_glass.png",
	sounds = default.node_sound_glass_defaults(),
	groups = {snappy=2, cracky=3},
	recipe = {
		{"caverealms:glow_obsidian_glass", "caverealms:glow_obsidian_glass", "caverealms:glow_obsidian_glass"},
		{"caverealms:glow_obsidian_glass", "caverealms:glow_obsidian_glass", "caverealms:glow_obsidian_glass"}
	}
})

