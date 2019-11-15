stairs = {}
stairs.mod = "redo"


function default.node_sound_wool_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "wool_coat_movement", gain = 1.0}
	table.dug = table.dug or
			{name = "wool_coat_movement", gain = 0.25}
	table.place = table.place or
			{name = "default_place_node", gain = 1.0}
	return table
end


stairs.wood = default.node_sound_wood_defaults()
stairs.dirt = default.node_sound_dirt_defaults()
stairs.stone = default.node_sound_stone_defaults()
stairs.glass = default.node_sound_glass_defaults()
stairs.leaves = default.node_sound_leaves_defaults()
stairs.metal = default.node_sound_metal_defaults()
stairs.wool = stairs.leaves
if minetest.get_modpath("xanadu") then
	stairs.wool = default.node_sound_wool_defaults()
end


-- cache creative
local creative = minetest.settings:get_bool("creative_mode")
function is_creative_enabled_for(name)
	if creative or minetest.check_player_privs(name, {creative = true}) then
		return true
	end
	return false
end


-- stair rotation
local rotate_node = function(itemstack, placer, pointed_thing)
	core.rotate_and_place(itemstack, placer, pointed_thing,
			is_creative_enabled_for(placer:get_player_name()),
			{invert_wall = placer:get_player_control().sneak})

	return itemstack
end


-- process textures
local set_textures = function(images)
	local stair_images = {}
	for i, image in ipairs(images) do
		if type(image) == "string" then
			stair_images[i] = {
				name = image,
				backface_culling = true,
				align_style = "world",
			}
		elseif image.backface_culling == nil then -- override using any other value
			if stair_images[i].backface_culling == nil then
				stair_images[i].backface_culling = true
			end
			if stair_images[i].align_style == nil then
				stair_images[i].align_style = "world"
			end
		end
	end
	return stair_images
end


-- Node will be called stairs:stair_<subname>
function stairs.register_stair(subname, recipeitem, groups, images, description, snds, alpha)
	local stair_images = set_textures(images)
	local new_groups = table.copy(groups)
	new_groups.stair = 1

	minetest.register_node(":stairs:stair_" .. subname, {
		description = description .. " Stair",
		drawtype = "nodebox",
		tiles = stair_images,
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		use_texture_alpha = alpha,
		groups = new_groups,
		sounds = snds,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
				{-0.5, 0, 0, 0.5, 0.5, 0.5},
			},
		},
		on_place = rotate_node
	})

	-- if no recipe item provided then skip craft recipes
	if not recipeitem then
		return
	end

	-- stair recipes
	minetest.register_craft({
		output = "stairs:stair_" .. subname .. " 8",
		recipe = {
			{recipeitem, "", ""},
			{recipeitem, recipeitem, ""},
			{recipeitem, recipeitem, recipeitem},
		},
	})

	-- stair to original material recipe
	minetest.register_craft({
		output = recipeitem .. " 3",
		recipe = {
			{"stairs:stair_" .. subname, "stairs:stair_" .. subname},
			{"stairs:stair_" .. subname, "stairs:stair_" .. subname},
		},
	})
end


-- Node will be called stairs:slab_<subname>
function stairs.register_slab(subname, recipeitem, groups, images, description, snds, alpha)
	local slab_images = set_textures(images)
	local new_groups = table.copy(groups)
	new_groups.slab = 1

	minetest.register_node(":stairs:slab_" .. subname, {
		description = description .. " Slab",
		drawtype = "nodebox",
		tiles = slab_images,
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		use_texture_alpha = alpha,
		groups = new_groups,
		sounds = snds,
		node_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
		},
		on_place = rotate_node
	})

	-- if no recipe item provided then skip craft recipes
	if not recipeitem then
		return
	end

	-- slab recipe
	minetest.register_craft({
		output = "stairs:slab_" .. subname .. " 6",
		recipe = {
			{recipeitem, recipeitem, recipeitem},
		},
	})

	-- slab to original material recipe
	minetest.register_craft({
		output = recipeitem,
		recipe = {
			{"stairs:slab_" .. subname},
			{"stairs:slab_" .. subname},
		},
	})
end


-- Node will be called stairs:stair_outer_<subname>
function stairs.register_stair_outer(subname, recipeitem, groups, images, description, snds, alpha)
	local stair_images = set_textures(images)
	local new_groups = table.copy(groups)
	new_groups.stair = 1

	minetest.register_node(":stairs:stair_outer_" .. subname, {
		description = "Outer " .. description .. " Stair",
		drawtype = "nodebox",
		tiles = stair_images,
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		use_texture_alpha = alpha,
		groups = new_groups,
		sounds = snds,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
				{-0.5, 0, 0, 0, 0.5, 0.5},
			},
		},
		on_place = rotate_node
	})

	-- add alias for old stairs redo name
	minetest.register_alias("stairs:corner_" .. subname, "stairs:stair_outer_" .. subname)

	-- if no recipe item provided then skip craft recipes
	if not recipeitem then
		return
	end

	-- corner stair recipe
	minetest.register_craft({
		output = "stairs:stair_outer_" .. subname .. " 6",
		recipe = {
			{"", "", ""},
			{"", recipeitem, ""},
			{recipeitem, recipeitem, recipeitem},
		},
	})

	-- corner stair to original material recipe
	minetest.register_craft({
		output = recipeitem .. " 2",
		recipe = {
			{"stairs:stair_outer_" .. subname, "stairs:stair_outer_" .. subname},
			{"stairs:stair_outer_" .. subname, "stairs:stair_outer_" .. subname},
		},
	})
end

-- compatibility function for previous stairs:corner_<subname>
function stairs.register_corner(subname, recipeitem, groups, images, description, snds, alpha)
	stairs.register_stair_outer(subname, recipeitem, groups, images, description, snds, alpha)
end


-- Node will be called stairs:stair_inner_<subname>
function stairs.register_stair_inner(subname, recipeitem, groups, images, description, snds, alpha)

	local stair_images = set_textures(images)
	local new_groups = table.copy(groups)
	new_groups.stair = 1

	minetest.register_node(":stairs:stair_inner_" .. subname, {
		description = "Inner " .. description .. " Stair",
		drawtype = "nodebox",
		tiles = stair_images,
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		use_texture_alpha = alpha,
		groups = new_groups,
		sounds = snds,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
				{-0.5, 0, 0, 0.5, 0.5, 0.5},
				{-0.5, 0, -0.5, 0, 0.5, 0},
			},
		},
		on_place = rotate_node
	})

	-- add alias for old stairs redo name
	minetest.register_alias("stairs:invcorner_" .. subname, "stairs:stair_inner_" .. subname)

	-- if no recipe item provided then skip craft recipes
	if not recipeitem then
		return
	end

	-- inside corner stair recipe
	minetest.register_craft({
		output = "stairs:stair_inner_" .. subname .. " 9",
		recipe = {
			{recipeitem, recipeitem, ""},
			{recipeitem, recipeitem, recipeitem},
			{recipeitem, recipeitem, recipeitem},
		},
	})

	-- inside corner stair to original material recipe
	minetest.register_craft({
		output = recipeitem .. " 3",
		recipe = {
			{"stairs:stair_inner_" .. subname, "stairs:stair_inner_" .. subname},
			{"stairs:stair_inner_" .. subname, "stairs:stair_inner_" .. subname},
		},
	})
end

-- compatibility function for previous stairs:invcorner_<subname>
function stairs.register_invcorner(subname, recipeitem, groups, images, description, snds, alpha)
	stairs.register_stair_inner(subname, recipeitem, groups, images, description, snds, alpha)
end


-- Node will be called stairs:slope_<subname>
function stairs.register_slope(subname, recipeitem, groups, images, description, snds, alpha)
	local stair_images = set_textures(images)
	local new_groups = table.copy(groups)
	new_groups.stair = 1

	minetest.register_node(":stairs:slope_" .. subname, {
		description = description .. " Slope",
		drawtype = "mesh",
		mesh = "stairs_slope.obj",
		tiles = stair_images,
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		use_texture_alpha = alpha,
		groups = new_groups,
		sounds = snds,
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
				{-0.5, 0, 0, 0.5, 0.5, 0.5},
			},
		},
		collision_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
				{-0.5, 0, 0, 0.5, 0.5, 0.5},
			},
		},
		on_place = rotate_node
	})

	-- slope recipe
	minetest.register_craft({
		output = "stairs:slope_" .. subname .. " 6",
		recipe = {
			{recipeitem, "", ""},
			{recipeitem, recipeitem, ""},
		},
	})

	-- slope to original material recipe
	minetest.register_craft({
		output = recipeitem,
		recipe = {
			{"stairs:slope_" .. subname, "stairs:slope_" .. subname},
		},
	})
end


-- Nodes will be called stairs:{stair,slab}_<subname>
function stairs.register_stair_and_slab(subname, recipeitem, groups, images,
		desc_stair, desc_slab, sounds, alpha)
	stairs.register_stair(subname, recipeitem, groups, images, desc_stair, sounds, alpha)
	stairs.register_slab(subname, recipeitem, groups, images, desc_slab, sounds, alpha)
end

-- Nodes will be called stairs:{stair,slab,corner,invcorner,slope}_<subname>
function stairs.register_all(subname, recipeitem, groups, images, desc, snds, alpha)
	stairs.register_stair(subname, recipeitem, groups, images, desc, snds, alpha)
	stairs.register_slab(subname, recipeitem, groups, images, desc, snds, alpha)
	stairs.register_corner(subname, recipeitem, groups, images, desc, snds, alpha)
	stairs.register_invcorner(subname, recipeitem, groups, images, desc, snds, alpha)
	stairs.register_slope(subname, recipeitem, groups, images, desc, snds, alpha)
end


local grp = {} -- Helper

--= Default Minetest

-- Wood types

stairs.register_all("wood", "default:wood",
	{choppy = 2, oddly_breakable_by_hand = 2, flammable = 3},
	{"default_wood.png"},
	"Wooden",
	stairs.wood)

stairs.register_all("junglewood", "default:junglewood",
	{choppy = 2, oddly_breakable_by_hand = 2, flammable = 3},
	{"default_junglewood.png"},
	"Jungle Wood",
	stairs.wood)

stairs.register_all("pine_wood", "default:pinewood",
	{choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
	{"default_pine_wood.png"},
	"Pine Wood",
	stairs.wood)

stairs.register_all("acacia_wood", "default:acacia_wood",
	{choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
	{"default_acacia_wood.png"},
	"Acacia Wood",
	stairs.wood)

stairs.register_all("aspen_wood", "default:aspen_wood",
	{choppy = 2, oddly_breakable_by_hand = 2, flammable = 3},
	{"default_aspen_wood.png"},
	"Aspen Wood",
	stairs.wood)

-- Stone types

stairs.register_all("stone", "default:stone",
	{cracky=3,stone=1, },
	{"default_stone.png"},
	"Stone",
	stairs.stone)

stairs.register_all("stonebrick", "default:stonebrick",
	{cracky = 2},
	{"default_stone_brick.png"},
	"Stone Brick",
	stairs.stone)

stairs.register_all("stone_block", "default:stone_block",
	{cracky = 2},
	{"default_stone_block.png"},
	"Stone Block",
	stairs.stone)

stairs.register_all("cobble", "default:cobble",
	{cracky = 3},
	{"default_cobble.png"},
	"Cobble",
	stairs.stone)

stairs.register_all("mossycobble", "default:mossycobble",
	{cracky = 3},
	{"default_mossycobble.png"},
	"Mossy Cobble",
	stairs.stone)

stairs.register_all("desert_stone", "default:desert_stone",
	{cracky = 3},
	{"default_desert_stone.png"},
	"Desert Stone",
	stairs.stone)

stairs.register_all("desert_stonebrick", "default:desert_stonebrick",
	{cracky = 3},
	{"default_desert_stone_brick.png"},
	"Desert Stone Brick",
	stairs.stone)

stairs.register_all("desert_stone_block", "default:desert_stone_block",
	{cracky = 2},
	{"default_desert_stone_block.png"},
	"Desert Stone Block",
	stairs.stone)

stairs.register_all("desert_cobble", "default:desert_cobble",
	{cracky = 3},
	{"default_desert_cobble.png"},
	"Desert Cobble", 
	stairs.stone)

-- Sandstone types

stairs.register_all("sandstone", "default:sandstone",
	{crumbly = 1, cracky = 3},
	{"default_sandstone.png"},
	"Sandstone",
	stairs.stone)

stairs.register_all("sandstonebrick", "default:sandstonebrick",
	{cracky = 2},
	{"default_sandstone_brick.png"},
	"Sandstone Brick",
	stairs.stone)

stairs.register_all("sandstone_block", "default:sandstone_block",
	{cracky = 2},
	{"default_sandstone_block.png"},
	"Sandstone Block",
	stairs.stone)

stairs.register_all("desert_sandstone", "default:desert_sandstone",
	{crumbly = 1, cracky = 3},
	{"default_desert_sandstone.png"},
	"Desert Sandstone",
	stairs.stone)

stairs.register_all("desert_sandstone_brick", "default:desert_sandstone_brick",
	{cracky = 2},
	{"default_desert_sandstone_brick.png"},
	"Desert Sandstone Brick",
	stairs.stone)

stairs.register_all("desert_sandstone_block", "default:desert_sandstone_block",
	{cracky = 2},
	{"default_desert_sandstone_block.png"},
	"Desert Sandstone Block",
	stairs.stone)

stairs.register_all("silver_sandstone", "default:silver_sandstone",
	{crumbly = 1, cracky = 3},
	{"default_silver_sandstone.png"},
	"Silver Sandstone",
	stairs.stone)

stairs.register_all("silver_sandstone_brick", "default:silver_sandstone_brick",
	{cracky = 2},
	{"default_silver_sandstone_brick.png"},
	"Silver Sandstone Brick",
	stairs.stone)

stairs.register_all("silver_sandstone_block", "default:silver_sandstone_block",
	{cracky = 2},
	{"default_silver_sandstone_block.png"},
	"Silver Sandstone Block",
	stairs.stone)

-- Obsidian

stairs.register_all("obsidian", "default:obsidian",
	{cracky = 1, level = 2},
	{"default_obsidian.png"},
	"Obsidian",
	stairs.stone)

stairs.register_all("obsidianbrick", "default:obsidianbrick",
	{cracky = 1, level = 3},
	{"default_obsidian_brick.png"},
	"Obsidian Brick",
	stairs.stone)

stairs.register_all("obsidian_block", "default:obsidian_block",
	{cracky = 1, level = 3},
	{"default_obsidian_block.png"},
	"Obsidian block",
	stairs.stone)

-- Cloud (with overrides)

stairs.register_stair("cloud", "default:cloud",
	{unbreakable = 1, not_in_creative_inventory = 1},
	{"default_cloud.png"},
	"Cloud Stair",
	stairs.wool)

minetest.override_item("stairs:stair_cloud", {
	on_blast = function() end,
})

stairs.register_slab("cloud", "default:cloud",
	{unbreakable = 1, not_in_creative_inventory = 1},
	{"default_cloud.png"},
	"Cloud Slab",
	stairs.wool)

minetest.override_item("stairs:slab_cloud", {
	on_blast = function() end,
})

-- Ores

stairs.register_all("coal", "default:coalblock",
	{cracky = 3},
	{"default_coal_block.png"},
	"Coal",
	stairs.stone)

stairs.register_all("steelblock", "default:steelblock",
	{cracky = 1, level = 2},
	{"default_steel_block.png"},
	"Steel",
	stairs.metal)

stairs.register_all("copperblock", "default:copperblock",
	{cracky = 1, level = 2},
	{"default_copper_block.png"},
	"Copper",
	stairs.metal)

stairs.register_all("bronzeblock", "default:bronzeblock",
	{cracky = 1, level = 2},
	{"default_bronze_block.png"},
	"Bronze",
	stairs.metal)

stairs.register_all("tinblock", "default:tinblock",
	{cracky = 1, level = 2},
	{"default_tin_block.png"},
	"Tin",
	stairs.metal)

stairs.register_all("mese", "default:mese",
	{cracky = 1, level = 2},
	{"default_mese_block.png"},
	"Mese",
	stairs.stone)

stairs.register_all("goldblock", "default:goldblock",
	{cracky = 1},
	{"default_gold_block.png"},
	"Gold",
	stairs.metal)

stairs.register_all("diamondblock", "default:diamondblock",
	{cracky = 1, level = 3},
	{"default_diamond_block.png"},
	"Diamond",
	stairs.stone)

-- Glass types

stairs.register_all("glass", "default:glass",
	{cracky = 3, oddly_breakable_by_hand = 3},
	{"default_glass.png"},
	"Glass",
	stairs.glass)

stairs.register_all("obsidian_glass", "default:obsidian_glass",
	{cracky = 2},
	{"default_obsidian_glass.png"},
	"Obsidian Glass",
	stairs.glass)

-- Brick, Snow and Ice

stairs.register_all("brick", "default:brick",
	{cracky = 3},
	{"default_brick.png"},
	"Brick",
	stairs.stone)

stairs.register_all("snowblock", "default:snowblock",
	{crumbly = 3, puts_out_fire = 1, cools_lava = 1, snowy = 1},
	{"default_snow.png"},
	"Snow Block",
	default.node_sound_dirt_defaults({
		footstep = {name = "default_snow_footstep", gain = 0.15},
		dug = {name = "default_snow_footstep", gain = 0.2},
		dig = {name = "default_snow_footstep", gain = 0.2}
	}))

stairs.register_all("ice", "default:ice",
	{cracky = 3, puts_out_fire = 1, cools_lava = 1},
	{"default_ice.png"},
	"Ice",
	default.node_sound_glass_defaults())


local colours = {
	{"black",      "Black",      "#000000b0"},
	{"blue",       "Blue",       "#015dbb70"},
	{"brown",      "Brown",      "#a78c4570"},
	{"cyan",       "Cyan",       "#01ffd870"},
	{"dark_green", "Dark Green", "#005b0770"},
	{"dark_grey",  "Dark Grey",  "#303030b0"},
	{"green",      "Green",      "#61ff0170"},
	{"grey",       "Grey",       "#5b5b5bb0"},
	{"magenta",    "Magenta",    "#ff05bb70"},
	{"orange",     "Orange",     "#ff840170"},
	{"pink",       "Pink",       "#ff65b570"},
	{"red",        "Red",        "#ff000070"},
	{"violet",     "Violet",     "#2000c970"},
	{"white",      "White",      "#abababc0"},
	{"yellow",     "Yellow",     "#e3ff0070"},
}

--= Coloured Blocks Mod
if minetest.get_modpath("cblocks") then

local col

for i = 1, #colours, 1 do

col = colours[i][1]

stairs.register_all(colours[i][1] .. "_glass", "cblocks:glass_" .. colours[i][1],
	{cracky = 3, oddly_breakable_by_hand = 3},
	{"cblocks.png^[colorize:" .. colours[i][3]},
	colours[i][2] .. " Glass",
	stairs.glass, true)

if col == "yellow" then col = "yellow2" end -- fixes ethereal yellow wood and cblocks yellow wood mixup

stairs.register_all(col .. "_wood", "cblocks:wood_" .. colours[i][1],
	{choppy = 2, oddly_breakable_by_hand = 2, flammable = 3},
	{"default_wood.png^[colorize:" .. colours[i][3]},
	colours[i][2] .. " Wooden",
	stairs.wood)

end --for

end

--= More Ores Mod
if minetest.get_modpath("moreores") then

grp = {cracky = 1, level = 2}

stairs.register_all("silver_block", "moreores:silver_block",
	grp,
	{"moreores_silver_block.png"},
	"Silver",
	stairs.metal)

stairs.register_all("mithril_block", "moreores:mithril_block",
	grp,
	{"moreores_mithril_block.png"},
	"Mithril",
	stairs.metal)

end

--[[= Farming Mod
if minetest.get_modpath("farming") then

stairs.register_all("straw", "farming:straw",
	{snappy = 3, flammable = 4},
	{"farming_straw.png"},
	"Straw",
	stairs.leaves)

if minetest.registered_nodes["farming:hemp_block"] then
stairs.register_all("hemp_block", "farming:hemp_block",
	{snappy = 1, flammable = 2},
	{"farming_hemp_block.png"},
	"Hemp Block",
	stairs.leaves)
end

end
]]
--= Mobs Mod

if minetest.registered_nodes["mobs:cheeseblock"] then

grp = {crumbly = 3, flammable = 2}

stairs.register_all("cheeseblock", "mobs:cheeseblock",
	grp,
	{"mobs_cheeseblock.png"},
	"Cheese Block",
	stairs.dirt)

stairs.register_all("honey_block", "mobs:honey_block",
	grp,
	{"mobs_honey_block.png"},
	"Honey Block",
	stairs.dirt)

end

--= Lapis Mod

if minetest.get_modpath("lapis") then

grp = {cracky = 3}

stairs.register_all("lapis_block", "lapis:lapis_block",
	grp,
	{"lapis_block_side.png"},
	"Lapis",
	stairs.stone)

stairs.register_all("lapis_brick", "lapis:lapis_brick",
	grp,
	{"lapis_brick.png"},
	"Lapis Brick",
	stairs.stone)

stairs.register_all("lapis_cobble", "lapis:lapis_cobble",
	grp,
	{"lapis_cobble.png"},
	"Lapis Cobble",
	stairs.stone)

end

--= Homedecor Mod

if minetest.get_modpath("homedecor") then

local grp = {snappy = 3}

stairs.register_all("shingles_asphalt", "homedecor:shingles_asphalt",
	grp,
	{"homedecor_shingles_asphalt.png"},
	"Asphalt Shingle",
	stairs.leaves)

stairs.register_all("shingles_terracotta", "homedecor:roof_tile_terracotta",
	grp,
	{"homedecor_shingles_terracotta.png"},
	"Terracotta Shingle",
	stairs.leaves)

stairs.register_all("shingles_wood", "homedecor:shingles_wood",
	grp,
	{"homedecor_shingles_wood.png"},
	"Wooden Shingle",
	stairs.leaves)

end

--= Xanadu Mod

if minetest.get_modpath("xanadu") then

grp = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 3}

stairs.register_all("stained_wood_white", "xanadu:stained_wood_white",
	grp,
	{"stained_wood_white.png"},
	"White Wooden",
	stairs.wood)

stairs.register_all("stained_wood_red", "xanadu:stained_wood_red",
	grp,
	{"stained_wood_red.png"},
	"Red Wooden",
	stairs.wood)

-- Decorative blocks

grp = {cracky = 3}

stairs.register_all("stone1", "xanadu:stone1",
	grp,
	{"stone1.png"},
	"Decorative Stone 1",
	stairs.stone)

stairs.register_all("stone2", "xanadu:stone2",
	grp,
	{"stone2.png"},
	"Decorative Stone 2",
	stairs.stone)

stairs.register_all("stone3", "xanadu:stone3",
	grp,
	{"stone3.png"},
	"Decorative Stone 3",
	stairs.stone)

stairs.register_all("stone4", "xanadu:stone4",
	grp,
	{"stone4.png"},
	"Decorative Stone 4",
	stairs.stone)

stairs.register_all("stone5", "xanadu:stone5",
	grp,
	{"stone5.png"},
	"Decorative Stone 5",
	stairs.stone)

stairs.register_all("stone6", "xanadu:stone6",
	grp,
	{"stone6.png"},
	"Decorative Stone 6",
	stairs.stone)

stairs.register_all("sandstonebrick4", "xanadu:sandstonebrick4",
	grp,
	{"sandstonebrick4.png"},
	"Decorative Sandstone 4",
	stairs.stone)

stairs.register_slab("desert_cobble1", "xanadu:desert_cobble1",
	grp,
	{"desert_cobble1.png"},
	"Decorative desert cobble 1 slab",
	stairs.stone)

stairs.register_slab("desert_cobble5", "xanadu:desert_cobble5",
	grp,
	{"desert_cobble5.png"},
	"Decorative desert cobble 5 slab",
	stairs.stone)

stairs.register_slab("desert_stone1", "xanadu:desert_stone1",
	grp,
	{"desert_stone1.png"},
	"Decorative desert stone 1 slab",
	stairs.stone)

stairs.register_slab("desert_stone3", "xanadu:desert_stone3",
	grp,
	{"desert_stone3.png"},
	"Decorative desert stone 3 slab",
	stairs.stone)

stairs.register_slab("desert_stone4", "xanadu:desert_stone4",
	grp,
	{"desert_stone4.png"},
	"Decorative desert stone 4 slab",
	stairs.stone)

stairs.register_stair("desert_stone4", "xanadu:desert_stone4",
	grp,
	{"desert_stone4.png"},
	"Decorative desert stone 4 stair",
	stairs.stone)

stairs.register_slab("desert_stone5", "xanadu:desert_stone5",
	grp,
	{"desert_stone5.png"},
	"Decorative desert stone 5 slab",
	stairs.stone)

stairs.register_slab("red1", "xanadu:red1",
	grp,
	{"baked_clay_red1.png"},
	"Decorative baked red clay 1 slab",
	stairs.stone)

stairs.register_all("bred2", "xanadu:red2",
	grp,
	{"baked_clay_red2.png"},
	"Decorative baked red clay 2",
	stairs.stone)

end

--= Castle Mod

if minetest.get_modpath("castle") then

grp = {cracky = 2}

stairs.register_all("dungeon_stone", "castle:dungeon_stone",
	grp,
	{"castle_dungeon_stone.png"},
	"Dungeon",
	stairs.stone)

stairs.register_all("stonewall", "castle:stonewall",
	grp,
	{"castle_stonewall.png"},
	"Castle Wall",
	stairs.stone)

end

--= Wool Mod

if minetest.get_modpath("wool") then

for i = 1, #colours, 1 do

stairs.register_all("wool_" .. colours[i][1], "wool:" .. colours[i][1],
	{snappy = 2, choppy = 2, oddly_breakable_by_hand = 3, flammable = 3},
	{"wool_" .. colours[i][1] .. ".png"},
	colours[i][2] .. " Wool",
	stairs.wool)

end -- END for

end

--= Caverealms lite mod
if minetest.get_modpath("caverealms")
and minetest.registered_nodes["caverealms:glow_obsidian_brick"] then

stairs.register_all("hot_cobble", "caverealms:hot_cobble",
	{cracky = 3},
	{"caverealms_hot_cobble.png"},
	"Hot Cobble",
	stairs.stone)

stairs.register_all("glow_obsidian_brick", "caverealms:glow_obsidian_brick",
	{cracky = 1, level = 3},
	{"caverealms_glow_obsidian_brick.png"},
	"Glow Obsidian Brick",
	stairs.stone)

stairs.register_all("glow_obsidian_brick_2", "caverealms:glow_obsidian_brick_2",
	{cracky = 1, level = 3},
	{"caverealms_glow_obsidian_brick_2.png"},
	"Glow Obsidian Brick 2",
	stairs.stone)
end

--= technic
stairs.register_all("rubber_tree_planks", "moretrees:rubber_tree_planks",
	{choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
	{"moretrees_rubber_tree_wood.png"},
	"Rubber Tree Wood",
	stairs.wood)


print ("[MOD] Stairs Redo loaded")
