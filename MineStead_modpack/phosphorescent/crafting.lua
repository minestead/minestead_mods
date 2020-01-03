minetest.register_craftitem("phosphorescent:zinc_sulphide", {
	description = "Zinc Sulphide",
	inventory_image = "phosphorescent_zinc_sulphide.png",
})

technic.register_alloy_recipe({input = {'technic:zinc_dust', 'technic:sulfur_dust'}, output = 'phosphorescent:zinc_sulphide 2', time = 6})

technic.register_alloy_recipe({input = {'phosphorescent:zinc_sulphide', 'technic:silver_dust'}, output = 'phosphorescent:phosphorescent_paint_blue 2', time = 6})
technic.register_alloy_recipe({input = {'phosphorescent:zinc_sulphide', 'technic:copper_dust'}, output = 'phosphorescent:phosphorescent_paint_green 2', time = 6})

minetest.register_craftitem("phosphorescent:phosphorescent_paint_blue", {
	description = "Phosphorescent Paint Blue",
	inventory_image = "phosphorescent_paint_blue.png",
})

minetest.register_craftitem("phosphorescent:phosphorescent_paint_green", {
	description = "Phosphorescent Paint Green",
	inventory_image = "phosphorescent_paint_green.png",
})

--stone brick

minetest.register_craft({
	output = "phosphorescent:phosphorescent_stonebrick_blue_on",
	recipe = {{'default:stonebrick', 'phosphorescent:phosphorescent_paint_blue'}}
})

minetest.register_craft({
	output = "phosphorescent:phosphorescent_stonebrick_green_on",
	recipe = {{'default:stonebrick', 'phosphorescent:phosphorescent_paint_green'}}
})

--desert stone brick

minetest.register_craft({
	output = "phosphorescent:phosphorescent_desert_stonebrick_blue_on",
	recipe = {{'default:desert_stonebrick', 'phosphorescent:phosphorescent_paint_blue'}}
})

minetest.register_craft({
	output = "phosphorescent:phosphorescent_desert_stonebrick_green_on",
	recipe = {{'default:desert_stonebrick', 'phosphorescent:phosphorescent_paint_green'}}
})

--desert sandstone brick

minetest.register_craft({
	output = "phosphorescent:phosphorescent_desert_sandstonebrick_blue_on",
	recipe = {{'default:desert_sandstone_brick', 'phosphorescent:phosphorescent_paint_blue'}}
})

minetest.register_craft({
	output = "phosphorescent:phosphorescent_desert_sandstonebrick_green_on",
	recipe = {{'default:desert_sandstone_brick', 'phosphorescent:phosphorescent_paint_green'}}
})

--sandstone brick

minetest.register_craft({
	output = "phosphorescent:phosphorescent_sandstonebrick_blue_on",
	recipe = {{'default:sandstonebrick', 'phosphorescent:phosphorescent_paint_blue'}}
})

minetest.register_craft({
	output = "phosphorescent:phosphorescent_sandstonebrick_green_on",
	recipe = {{'default:sandstonebrick', 'phosphorescent:phosphorescent_paint_green'}}
})

--silver andstone brick

minetest.register_craft({
	output = "phosphorescent:phosphorescent_silver_sandstonebrick_blue_on",
	recipe = {{'default:silver_sandstone_brick', 'phosphorescent:phosphorescent_paint_blue'}}
})

minetest.register_craft({
	output = "phosphorescent:phosphorescent_silver_sandstonebrick_green_on",
	recipe = {{'default:silver_sandstone_brick', 'phosphorescent:phosphorescent_paint_green'}}
})
