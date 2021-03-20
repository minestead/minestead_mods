minetest.clear_craft({output = "protector:protect"})

minetest.register_craft({
	output = "protector:protect",
	recipe = {
		{"default:stone", "default:tin_ingot", "default:stone"},
		{"default:tin_ingot", "default:goldblock", "default:tin_ingot"},
		{"default:stone", "default:tin_ingot", "default:stone"},
	}
})

minetest.register_craft({
	type = "shapeless",
	output = "protector:protect",
	recipe = {"protector:protect2"}
})
