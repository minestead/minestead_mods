minetest.register_node(":minestead:trophy_1_year", {
	description = "Победитель квеста",
	drawtype = "mesh",
	paramtype = "light",
	paramtype2 = "facedir",
	mesh = "minestead_trophy.obj",
	tiles = {
		"minestead_trophy_1_year.png",
		{ name = "minestead_trophy_bg.png", color = 0xff643f23 },
		"minestead_trophy_back.png",
	},
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", "Победитель квеста на годовщину MineStead")
	end,
	inventory_image = "minestead_trophy_1_year_inv.png",
	wield_image = "minestead_trophy_1_year.png",
	groups = {snappy = 3},
	selection_box = {
		type = "fixed",
		fixed = { -0.18, -0.5, -0.08, 0.18, -0.08, 0.18 }
	},
	walkable = false,
	sounds = default.node_sound_glass_defaults()
})

