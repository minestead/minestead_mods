--stone brick

minetest.register_node("phosphorescent:phosphorescent_stonebrick_green_on", {
	description = "Phosphorescent Stone Brick Green",
	groups = {stone = 1, cracky=2, phosphorescent = 1},
	sunlight_propagates = false,
	paramtype = "light",
	light_source = default.LIGHT_MAX - 4,
	drawtype = "allfaces",
	tiles = {"default_stone_brick.png^[colorize:#A1FF5477"},
	sounds = default.node_sound_stone_defaults(),
	drop = "phosphorescent:phosphorescent_stonebrick_green_on", 
})

minetest.register_node("phosphorescent:phosphorescent_stonebrick_green_off", {
	description = "Phosphorescent Stone Brick",
	groups = {stone = 1, cracky=2, phosphorescent = 1},
	sunlight_propagates = false,
	paramtype = "light",
	drawtype = "allfaces",
	tiles = {"default_stone_brick.png"},
	sounds = default.node_sound_stone_defaults(),
	drop = "phosphorescent:phosphorescent_stonebrick_green_on", 
})

minetest.register_node("phosphorescent:phosphorescent_stonebrick_blue_on", {
	description = "Phosphorescent Stone Brick Blue",
	groups = {stone = 1, cracky=2, phosphorescent = 1},
	sunlight_propagates = false,
	paramtype = "light",
	light_source = default.LIGHT_MAX - 4,
	drawtype = "allfaces",
	tiles = {"default_stone_brick.png^[colorize:#30C5EB77"},
	sounds = default.node_sound_stone_defaults(),
	drop = "phosphorescent:phosphorescent_stonebrick_blue_on", 
})

minetest.register_node("phosphorescent:phosphorescent_stonebrick_blue_off", {
	description = "Phosphorescent Stone Brick",
	groups = {stone = 1, cracky=2, phosphorescent = 1},
	sunlight_propagates = false,
	paramtype = "light",
	drawtype = "allfaces",
	tiles = {"default_stone_brick.png"},
	sounds = default.node_sound_stone_defaults(),
	drop = "phosphorescent:phosphorescent_stonebrick_blue_on", 
})

--desert stone brick

minetest.register_node("phosphorescent:phosphorescent_desert_stonebrick_green_on", {
	description = "Phosphorescent Desert Stone Brick Green",
	groups = {stone = 1, cracky=2, phosphorescent = 1},
	sunlight_propagates = false,
	paramtype = "light",
	light_source = default.LIGHT_MAX - 4,
	drawtype = "allfaces",
	tiles = {"default_desert_stone_brick.png^[colorize:#A1FF5477"},
	sounds = default.node_sound_stone_defaults(),
	drop = "phosphorescent:phosphorescent_desert_stonebrick_green_on", 
})

minetest.register_node("phosphorescent:phosphorescent_desert_stonebrick_green_off", {
	description = "Phosphorescent Desert Stone Brick",
	groups = {stone = 1, cracky=2, phosphorescent = 1},
	sunlight_propagates = false,
	paramtype = "light",
	drawtype = "allfaces",
	tiles = {"default_desert_stone_brick.png"},
	sounds = default.node_sound_stone_defaults(),
	drop = "phosphorescent:phosphorescent_desert_stonebrick_green_on", 
})

minetest.register_node("phosphorescent:phosphorescent_desert_stonebrick_blue_on", {
	description = "Phosphorescent Desert Stone Brick Blue",
	groups = {stone = 1, cracky=2, phosphorescent = 1},
	sunlight_propagates = false,
	paramtype = "light",
	light_source = default.LIGHT_MAX - 4,
	drawtype = "allfaces",
	tiles = {"default_desert_stone_brick.png^[colorize:#30C5EB77"},
	sounds = default.node_sound_stone_defaults(),
	drop = "phosphorescent:phosphorescent_desert_stonebrick_blue_on", 
})

minetest.register_node("phosphorescent:phosphorescent_desert_stonebrick_blue_off", {
	description = "Phosphorescent Desert Stone Brick",
	groups = {stone = 1, cracky=2, phosphorescent = 1},
	sunlight_propagates = false,
	paramtype = "light",
	drawtype = "allfaces",
	tiles = {"default_desert_stone_brick.png"},
	sounds = default.node_sound_stone_defaults(),
	drop = "phosphorescent:phosphorescent_desert_stonebrick_blue_on", 
})

--desert sandstone brick

minetest.register_node("phosphorescent:phosphorescent_desert_sandstonebrick_green_on", {
	description = "Phosphorescent Desert Sandstone Brick Green",
	groups = {stone = 1, cracky=2, phosphorescent = 1},
	sunlight_propagates = false,
	paramtype = "light",
	light_source = default.LIGHT_MAX - 4,
	drawtype = "allfaces",
	tiles = {"default_desert_sandstone_brick.png^[colorize:#A1FF5477"},
	sounds = default.node_sound_stone_defaults(),
	drop = "phosphorescent:phosphorescent_desert_sandstonebrick_green_on", 
})

minetest.register_node("phosphorescent:phosphorescent_desert_sandstonebrick_green_off", {
	description = "Phosphorescent Desert Sandstone Brick",
	groups = {stone = 1, cracky=2, phosphorescent = 1},
	sunlight_propagates = false,
	paramtype = "light",
	drawtype = "allfaces",
	tiles = {"default_desert_sandstone_brick.png"},
	sounds = default.node_sound_stone_defaults(),
	drop = "phosphorescent:phosphorescent_desert_sandstonebrick_green_on", 
})

minetest.register_node("phosphorescent:phosphorescent_desert_sandstonebrick_blue_on", {
	description = "Phosphorescent Desert Sandstone Brick Blue",
	groups = {stone = 1, cracky=2, phosphorescent = 1},
	sunlight_propagates = false,
	paramtype = "light",
	light_source = default.LIGHT_MAX - 4,
	drawtype = "allfaces",
	tiles = {"default_desert_sandstone_brick.png^[colorize:#30C5EB77"},
	sounds = default.node_sound_stone_defaults(),
	drop = "phosphorescent:phosphorescent_desert_sandstonebrick_blue_on", 
})

minetest.register_node("phosphorescent:phosphorescent_desert_sandstonebrick_blue_off", {
	description = "Phosphorescent Desert Sandstone Brick",
	groups = {stone = 1, cracky=2, phosphorescent = 1},
	sunlight_propagates = false,
	paramtype = "light",
	drawtype = "allfaces",
	tiles = {"default_desert_sandstone_brick.png"},
	sounds = default.node_sound_stone_defaults(),
	drop = "phosphorescent:phosphorescent_desert_sandstonebrick_blue_on", 
})

--sandstone brick

minetest.register_node("phosphorescent:phosphorescent_sandstonebrick_green_on", {
	description = "Phosphorescent Sandstone Brick Green",
	groups = {stone = 1, cracky=2, phosphorescent = 1},
	sunlight_propagates = false,
	paramtype = "light",
	light_source = default.LIGHT_MAX - 4,
	drawtype = "allfaces",
	tiles = {"default_sandstone_brick.png^[colorize:#A1FF5477"},
	sounds = default.node_sound_stone_defaults(),
	drop = "phosphorescent:phosphorescent_sandstonebrick_green_on", 
})

minetest.register_node("phosphorescent:phosphorescent_sandstonebrick_green_off", {
	description = "Phosphorescent Sandstone Brick",
	groups = {stone = 1, cracky=2, phosphorescent = 1},
	sunlight_propagates = false,
	paramtype = "light",
	drawtype = "allfaces",
	tiles = {"default_sandstone_brick.png"},
	sounds = default.node_sound_stone_defaults(),
	drop = "phosphorescent:phosphorescent_sandstonebrick_green_on", 
})

minetest.register_node("phosphorescent:phosphorescent_sandstonebrick_blue_on", {
	description = "Phosphorescent Sandstone Brick Blue",
	groups = {stone = 1, cracky=2, phosphorescent = 1},
	sunlight_propagates = false,
	paramtype = "light",
	light_source = default.LIGHT_MAX - 4,
	drawtype = "allfaces",
	tiles = {"default_sandstone_brick.png^[colorize:#30C5EB77"},
	sounds = default.node_sound_stone_defaults(),
	drop = "phosphorescent:phosphorescent_sandstonebrick_blue_on", 
})

minetest.register_node("phosphorescent:phosphorescent_sandstonebrick_blue_off", {
	description = "Phosphorescent Sandstone Brick",
	groups = {stone = 1, cracky=2, phosphorescent = 1},
	sunlight_propagates = false,
	paramtype = "light",
	drawtype = "allfaces",
	tiles = {"default_sandstone_brick.png"},
	sounds = default.node_sound_stone_defaults(),
	drop = "phosphorescent:phosphorescent_sandstonebrick_blue_on", 
})

--silver sandstone brick

minetest.register_node("phosphorescent:phosphorescent_silver_sandstonebrick_green_on", {
	description = "Phosphorescent Silver Sandstone Brick Green",
	groups = {stone = 1, cracky=2, phosphorescent = 1},
	sunlight_propagates = false,
	paramtype = "light",
	light_source = default.LIGHT_MAX - 4,
	drawtype = "allfaces",
	tiles = {"default_silver_sandstone_brick.png^[colorize:#A1FF5477"},
	sounds = default.node_sound_stone_defaults(),
	drop = "phosphorescent:phosphorescent_silver_sandstonebrick_green_on", 
})

minetest.register_node("phosphorescent:phosphorescent_silver_sandstonebrick_green_off", {
	description = "Phosphorescent Silver Sandstone Brick",
	groups = {stone = 1, cracky=2, phosphorescent = 1},
	sunlight_propagates = false,
	paramtype = "light",
	drawtype = "allfaces",
	tiles = {"default_silver_sandstone_brick.png"},
	sounds = default.node_sound_stone_defaults(),
	drop = "phosphorescent:phosphorescent_silver_sandstonebrick_green_on", 
})

minetest.register_node("phosphorescent:phosphorescent_silver_sandstonebrick_blue_on", {
	description = "Phosphorescent Silver Sandstone Brick Blue",
	groups = {stone = 1, cracky=2, phosphorescent = 1},
	sunlight_propagates = false,
	paramtype = "light",
	light_source = default.LIGHT_MAX - 4,
	drawtype = "allfaces",
	tiles = {"default_silver_sandstone_brick.png^[colorize:#30C5EB77"},
	sounds = default.node_sound_stone_defaults(),
	drop = "phosphorescent:phosphorescent_silver_sandstonebrick_blue_on", 
})

minetest.register_node("phosphorescent:phosphorescent_silver_sandstonebrick_blue_off", {
	description = "Phosphorescent Silver Sandstone Brick",
	groups = {stone = 1, cracky=2, phosphorescent = 1},
	sunlight_propagates = false,
	paramtype = "light",
	drawtype = "allfaces",
	tiles = {"default_silver_sandstone_brick.png"},
	sounds = default.node_sound_stone_defaults(),
	drop = "phosphorescent:phosphorescent_silver_sandstonebrick_blue_on", 
})
