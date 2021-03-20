minetest.clear_craft({output = "protector:protect"})

minetest.register_craft({
	output = "protector:protect",
	recipe = {
		{"default:stone", "default:tin_ingot", "default:stone"},
		{"default:tin_ingot", "default:goldblock", "default:tin_ingot"},
		{"default:stone", "default:tin_ingot", "default:stone"},
	}
})