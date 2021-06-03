minetest.clear_craft({ output='towercrane:base' })
minetest.register_craft({
	output = "towercrane:base",
	recipe = {
		{"default:steelblock", "default:steelblock", "default:steelblock"},
		{"default:steelblock", "", ""},
		{"default:steelblock", "dye:yellow", ""}
	}
})
