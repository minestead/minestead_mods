local sides = {
  {x = -1, z = 0},
  {x = 1, z = 0},
  {x = 0, z = -1},
  {x = 0, z = 1},
}

minetest.register_node("palm:palm_tree_trunk", {
	description = "Palm Tree Trunk",
	tiles = {
		"moretrees_palm_trunk_top.png",
		"moretrees_palm_trunk_top.png",
		"moretrees_palm_trunk.png"
	},
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	sounds = default.node_sound_wood_defaults(),
	paramtype2 = "facedir",
	on_place = minetest.rotate_node,
})

minetest.register_node("palm:coconut", {
	description = "Coconut",
	drawtype = "plantlike",
	walkable = false,
	paramtype = "light",
	sunlight_propagates = true,
	tiles = {"moretrees_coconut.png"},
	inventory_image = "moretrees_coconut.png",
	wield_image = "moretrees_coconut.png",
	selection_box = {
		type = "fixed",
		fixed = {-0.31, -0.43, -0.31, 0.31, 0.44, 0.31}
	},
	groups = {
		snappy = 1, oddly_breakable_by_hand = 1, cracky = 1,
		choppy = 1, flammable = 1, leafdecay = 3, leafdecay_drop = 1
	},
	drop = "palm:coconut",
	sounds = default.node_sound_wood_defaults(),

  on_rightclick = function(pos)
    minetest.spawn_falling_node(pos)
    local near_spawn = minetest.find_node_near(pos, 1, {"palm:coconut"})
    if near_spawn then
      minetest.get_node_timer(pos):start(math.random(300, 1500))
    end
  end,
  on_construct = function(pos)
    minetest.get_node_timer(pos):start(math.random(300, 1500))
  end,
  on_timer = function(pos)
    if minetest.get_item_group(name_under, "sand") or minetest.get_item_group(name_under, "soil") then
      minetest.set_node(pos, {name="air"})
      minetest.place_schematic({x = pos.x - 6, y = pos.y, z = pos.z - 6 }, palm_tree_schematic, "random", nil, false)
    end
  end
})

minetest.register_node("palm:palm_tree_leaves", {
	description = "Palm Tree Leaves",
	drawtype = "allfaces_optional",
	tiles = {"moretrees_palm_leaves.png"},
--	inventory_image = "moretrees_palm_leaves.png",
--	wield_image = "moretrees_palm_leaves.png",
	paramtype = "light",
	walkable = true,
	waving = 1,
	groups = {snappy = 3, leafdecay = 3, leaves = 1, flammable = 2},
	drop = {
		max_items = 1,
		items = {
			{items = {"palm:palm_tree_leaves"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),
	after_place_node = default.after_place_leaves,
})

local _ = {
  name = "air",
  prob = 0,
}

local T = {
  name = "palm:palm_tree_trunk",
  force_place = true,
}

local C = {
  name = "palm:coconut",
  prob = 100,
}

local L = {
  name = "palm:palm_tree_leaves",
}

-- make schematic
palm_tree_schematic = {
  size = {x = 13, y = 10, z = 13},
  data = {
--1   
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,

--2
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
--3
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
--4
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
--5
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
--6
    _, _, _, _, _, _, T, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
--7
    _, _, _, _, _, T, T, T, _, _, _, _, _,
    _, _, _, _, _, _, T, T, _, _, _, _, _,
    _, _, _, _, _, _, _, T, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, L, _, L, _,
    _, _, _, _, _, _, _, _, _, _, _, L, _,
--8
    _, _, _, _, _, _, T, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, T, _, _, _, _, _,
    _, _, _, _, _, _, _, T, T, _, _, _, _,
    _, _, _, _, _, _, _, _, T, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, L, _, _, L, _, _, _,
    _, _, _, _, _, _, L, L, _, _, L, L, _,

    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, T, _, _, _, _,
    _, _, _, _, _, _, _, _, T, T, _, _, _,
    _, _, _, _, _, _, _, _, _, T, _, _, _,
    _, _, _, _, _, _, _, _, _, C, _, _, _,
    _, _, _, _, _, _, _, _, _, L, _, _, _,
    _, _, _, _, _, _, _, L, L, L, L, _, _,

    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, T, _, _, _,
    _, _, _, _, _, _, _, _, C, T, C, _, _,
    _, _, _, _, _, _, L, L, L, T, L, L, L,
    _, _, _, _, _, _, _, _, L, L, L, _, _,

    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, C, _, _, _,
    _, _, _, _, _, _, _, _, L, L, L, L, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,

    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, L, _, _, L,
    _, _, _, _, _, _, _, L, L, _, _, L, L,

    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, L, _, L, _, _, _,
    _, _, _, _, _, _, _, L, _, _, _, _, _,

  }
}

minetest.register_decoration({
  deco_type = "schematic",
  place_on = {"default:sand", "default:desert_sand", "default:dirt_with_dry_grass"},
  biomes = {"sandstone_desert_ocean", "desert_ocean", "savanna_ocean", "desert", "savanna"},
  sidelen = 5,
  fill_ratio = 0.01,
  schematic = palm_tree_schematic,
  rotation = 'random',
  y_min = 1,
  y_max = 5,
  flags = {place_center_z = true, place_center_x = true},
})

minetest.register_craftitem("palm:coconut_slice", {
	description = "Coconut Slice",
	inventory_image = "moretrees_coconut_slice.png",
	wield_image = "moretrees_coconut_slice.png",
	on_use = minetest.item_eat(6),
})

minetest.register_craft({
	output = "palm:palm_tree_planks 4",
	recipe = {{"palm:palm_tree_trunk"}}
})

minetest.register_craft({
	type = "shapeless",
	output = "palm:coconut_slice 2",
	recipe = {'palm:coconut', 'gravelsieve:hammer'},
	replacements = {{'gravelsieve:hammer', 'gravelsieve:hammer'}},
})

minetest.register_node("palm:palm_tree_planks", {
    description = "Palm Tree Planks",
    tiles = {"moretrees_palm_wood.png"},
    is_ground_content = false,
    groups = {wood = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
	sounds = default.node_sound_wood_defaults(),
})

if minetest.get_modpath("doors") then
	doors.register("door_palm", {
			tiles = {{ name = "palm_door_wood.png", backface_culling = true }},
			description = "Palm Door",
			inventory_image = "palm_door_wood_inv.png",
			groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
			recipe = {
				{"palm:palm_tree_planks", "palm:palm_tree_planks"},
				{"palm:palm_tree_leaves", "palm:palm_tree_leaves"},
				{"palm:palm_tree_planks", "palm:palm_tree_planks"},
			}
	})
end

if minetest.get_modpath("stairs") then
	stairs.register_all("palm_tree_planks", "palm:palm_tree_planks",
		{choppy = 2, oddly_breakable_by_hand = 2, flammable = 3},
		{"moretrees_palm_wood.png"},
		"Palm Wood",
		stairs.wood)
end
