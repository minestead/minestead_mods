local sides = {
  {x = -1, z = 0},
  {x = 1, z = 0},
  {x = 0, z = -1},
  {x = 0, z = 1},
}

minetest.register_node("oak_steampunk:oak_acorn", {
	description = "Oak Acorn",
	drawtype = "plantlike",
	walkable = false,
	paramtype = "light",
	sunlight_propagates = true,
	tiles = {"oak_acorn.png"},
	inventory_image = "oak_acorn.png",
	wield_image = "oak_acorn.png",
	selection_box = {
		type = "fixed",
		fixed = {-0.31, -0.43, -0.31, 0.31, 0.44, 0.31}
	},
	groups = {
		snappy = 1, oddly_breakable_by_hand = 1, cracky = 1,
		choppy = 1, flammable = 1, leafdecay = 3, leafdecay_drop = 1
	},
	drop = "oak_steampunk:oak_acorn",
	sounds = default.node_sound_wood_defaults(),

  on_rightclick = function(pos)
    minetest.spawn_falling_node(pos)
    local near_spawn = minetest.find_node_near(pos, 1, {"oak_steampunk:oak_acorn"})
    if near_spawn then
      minetest.get_node_timer(pos):start(math.random(300, 1500))
    end
  end,
  on_construct = function(pos)
    minetest.get_node_timer(pos):start(math.random(300, 1500))
  end,
  on_timer = function(pos)
    if minetest.get_item_group(name_under, "soil") then
      minetest.set_node(pos, {name="air"})
      minetest.place_schematic({x = pos.x - 6, y = pos.y, z = pos.z - 6 }, oak_tree_schematic, "random", nil, false)
    end
  end
})

minetest.register_node("oak_steampunk:oak_tree_trunk", {
	description = "Oak Tree Trunk",
	tiles = {
		"oak_trunk_top.png",
		"oak_trunk_top.png",
		"oak_trunk.png"
	},
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	sounds = default.node_sound_wood_defaults(),
	paramtype2 = "facedir",
	on_place = minetest.rotate_node,
})

minetest.register_node("oak_steampunk:oak_tree_leaves", {
	description = "Oak Tree Leaves",
	drawtype = "allfaces_optional",
	tiles = {"oak_leaves.png"},
--	inventory_image = "moretrees_palm_leaves.png",
--	wield_image = "moretrees_palm_leaves.png",
	paramtype = "light",
	walkable = true,
	waving = 1,
	groups = {snappy = 3, leafdecay = 3, leaves = 1, flammable = 2},
	drop = {
		max_items = 1,
		items = {{
			items = {'oak_steampunk:oak_acorn'},
			rarity = 20,
		},
		{
			items = {"oak_steampunk:oak_tree_leaves"},
		},
	}},
	sounds = default.node_sound_leaves_defaults(),
	after_place_node = default.after_place_leaves,
})

local _ = {
  name = "air",
  prob = 0,
}

local T = {
  name = "oak_steampunk:oak_tree_trunk",
  force_place = true,
}

local L = {
  name = "oak_steampunk:oak_tree_leaves",
}

-- make schematic
oak_tree_schematic = {
  size = {x = 8, y = 8, z = 8},
  data = {
--1   
    _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _,
    _, _, L, L, L, L, _, _,
    _, _, L, L, L, L, _, _,
    _, _, _, _, _, _, _, _,
--2
    _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _,
    _, L, L, T, L, L, L, _,
    _, L, L, L, L, L, L, _,
    _, _, _, L, L, _, _, _,
--3
    _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _,
    L, L, L, T, _, L, L, L,
    L, L, L, L, L, L, L, L,
    _, _, L, L, L, L, _, _,
--4
    _, _, _, T, T, _, _, _,
    _, _, _, T, T, _, _, _,
    _, _, _, T, T, _, _, _,
    _, _, _, T, T, _, _, _,
    _, _, _, T, T, _, _, _,
    L, L, _, T, T, T, T, L,
    L, L, L, T, T, L, L, L,
    _, L, L, L, L, L, L, _,
--5
    _, _, _, T, T, _, _, _,
    _, _, _, T, T, _, _, _,
    _, _, _, T, T, _, _, _,
    _, _, _, T, T, _, _, _,
    _, _, _, T, T, _, _, _,
    L, T, T, T, T, _, L, L,
    L, L, L, T, T, L, L, L,
    _, L, L, L, L, L, L, _,
--6
    _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _,
    L, L, L, _, T, L, L, L,
    L, L, L, L, L, L, L, L,
    _, _, L, L, L, L, _, _,
--7
    _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _,
    _, L, L, L, T, L, L, _,
    _, L, L, L, L, L, L, _,
    _, _, _, L, L, _, _, _,
--8
    _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _,
    _, _, L, L, L, L, _, _,
    _, _, L, L, L, L, _, _,
    _, _, _, _, _, _, _, _,
  }
}

minetest.register_decoration({
  deco_type = "schematic",
  place_on = {"default:dirt_with_grass", "default:dirt_with_coniferous_litter", "dirt_with_snow"},
  biomes = {"coniferous_forest", "taiga"}, -- "grassland", "deciduous_forest", 
  sidelen = 5,
  fill_ratio = 0.001,
  schematic = oak_tree_schematic,
  rotation = 'random',
  y_min = 20,
  y_max = 30000,
  flags = {place_center_z = true, place_center_x = true},
})

minetest.register_craft({
	output = "oak_steampunk:oak_tree_planks 4",
	recipe = {{"oak_steampunk:oak_tree_trunk"}}
})

minetest.register_node("oak_steampunk:oak_tree_planks", {
    description = "Oak Tree Planks",
    tiles = {"oak_wood.png"},
    is_ground_content = false,
    groups = {wood = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
	sounds = default.node_sound_wood_defaults(),
})

if minetest.get_modpath("stairs") then
	stairs.register_all("oak_tree_planks", "oak_steampunk:oak_tree_planks",
		{choppy = 2, oddly_breakable_by_hand = 2, flammable = 3},
		{"oak_wood.png"},
		"Oak Wood",
		stairs.wood)
end

-- aliases
minetest.register_alias("oak_steampunk:trunk", "oak_steampunk:oak_tree_trunk")
minetest.register_alias("oak_steampunk:leaves", "oak_steampunk:oak_tree_leaves")

minetest.register_node("oak_steampunk:oak_floor", {
    description = "Oak Floor",
    tiles = {"oak_floor.png"},
    is_ground_content = false,
    groups = {wood = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_craft({
	output = "oak_steampunk:oak_floor 5",
	recipe = {
	{"oak_steampunk:oak_tree_planks", "", "oak_steampunk:oak_tree_planks"},
	{"", "oak_steampunk:oak_tree_planks", ""},
	{"oak_steampunk:oak_tree_planks", "", "oak_steampunk:oak_tree_planks"}
  }
})

minetest.register_node("oak_steampunk:oak_floor2", {
    description = "Oak Floor 2",
    tiles = {"oak_floor2.png"},
    is_ground_content = false,
    groups = {wood = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_craft({
	output = "oak_steampunk:oak_floor2 4",
	recipe = {
	{"oak_steampunk:oak_tree_planks", "", "oak_steampunk:oak_tree_planks"},
	{"", "", ""},
	{"oak_steampunk:oak_tree_planks", "", "oak_steampunk:oak_tree_planks"}
  }
})

minetest.register_node("oak_steampunk:oak_floor3", {
    description = "Oak Floor 3",
    tiles = {"oak_floor3.png"},
    is_ground_content = false,
    groups = {wood = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_craft({
	output = "oak_steampunk:oak_floor3 6",
	recipe = {
	{"oak_steampunk:oak_tree_planks", "oak_steampunk:oak_tree_planks", "oak_steampunk:oak_tree_planks"},
	{"", "oak_steampunk:oak_tree_planks", ""},
	{"oak_steampunk:oak_tree_planks", "", "oak_steampunk:oak_tree_planks"}
  }
})

doors.register("oak_door", {
		tiles = {{ name = "oak_door_wood.png", backface_culling = true }},
		description = "Oak Door",
		inventory_image = "oak_door_wood_inv.png",
		groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
		recipe = {
			{"oak_steampunk:oak_tree_planks", "oak_steampunk:oak_tree_planks", ""},
			{"default:steel_ingot", "oak_steampunk:oak_tree_planks", ""},
			{"oak_steampunk:oak_tree_planks", "oak_steampunk:oak_tree_planks", ""},
		}
})

doors.register("oak_door_handweel", {
		tiles = {{ name = "oak_door_wood2.png", backface_culling = true }},
		description = "Oak Door Handweel",
		inventory_image = "oak_door_wood_inv2.png",
		groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
		recipe = {
			{"oak_steampunk:oak_tree_planks", "oak_steampunk:oak_tree_planks", ""},
			{"default:bronze_ingot", "oak_steampunk:oak_tree_planks", ""},
			{"oak_steampunk:oak_tree_planks", "oak_steampunk:oak_tree_planks", ""},
		}
})

minetest.register_node("oak_steampunk:oak_frame", {
    description = "Oak Frame",
    tiles = {"oak_frame.png"},
    is_ground_content = false,
    groups = {wood = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_craft({
	output = "oak_steampunk:oak_frame 4",
	recipe = {
	{"", "oak_steampunk:oak_tree_planks", ""},
	{"oak_steampunk:oak_tree_planks", "", "oak_steampunk:oak_tree_planks"},
	{"", "oak_steampunk:oak_tree_planks", ""}
  }
})

minetest.register_node("oak_steampunk:oak_fan", {
    description = "Oak Fan",
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	tiles = {
		"oak_floor3.png",
		"oak_floor3.png",
		"oak_floor3.png",
		"oak_floor3.png",
		{name="oak_fan.png",animation={type="vertical_frames", aspect_w=32, aspect_h=32, length=0.50}},
		{name="oak_fan.png",animation={type="vertical_frames", aspect_w=32, aspect_h=32, length=0.50}}
	},
--	tiles = {{name="oak_fan.png",animation={type="vertical_frames", aspect_w=32, aspect_h=32, length=0.50},}},
    is_ground_content = false,
    groups = {wood = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_craft({
	output = "oak_steampunk:oak_fan",
	type = "shapeless",
	recipe = {"oak_steampunk:oak_frame", "default:bronze_ingot"},
})

minetest.register_node("oak_steampunk:oak_gear", {
    description = "Oak Gear",
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	tiles = {
		"oak_floor3.png",
		"oak_floor3.png",
		"oak_gear.png",
		"oak_gear.png",
		"oak_gear.png",
		"oak_gear.png",
	},
    is_ground_content = false,
    groups = {wood = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_craft({
	output = "oak_steampunk:oak_gear",
	type = "shapeless",
	recipe = {"oak_steampunk:oak_frame", "basic_materials:gear_steel"},
})

minetest.register_node("oak_steampunk:oak_face", {
    description = "Oak Face",
    tiles = {"oak_face.png"},
    is_ground_content = false,
    groups = {wood = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_craft({
	output = "oak_steampunk:oak_face 2",
	type = "shapeless",
	recipe = {"oak_steampunk:oak_tree_trunk", "oak_steampunk:oak_tree_trunk"},
})

minetest.register_node("oak_steampunk:oak_bubble", {
    description = "Oak Bubble Tube",
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	tiles = {
		"oak_floor3.png",
		"oak_floor3.png",
		{name="oak_bubble.png",animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=3.50}},
		{name="oak_bubble.png",animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=3.50}},
		{name="oak_bubble.png",animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=3.50}},
		{name="oak_bubble.png",animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=3.50}},
	},
	light_source = 6,
    is_ground_content = false,
    groups = {wood = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_craft({
	output = "oak_steampunk:oak_bubble",
	type = "shapeless",
	recipe = {"oak_steampunk:oak_frame", "default:glass", "bucket:bucket_water"},
	replacements = {{"bucket:bucket_water", "bucket:bucket_empty"}}
})

minetest.register_node("oak_steampunk:oak_porthole", {
    description = "Oak Porthole",
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	tiles = {
		"oak_floor3.png",
		"oak_floor3.png",
		"oak_floor3.png",
		"oak_floor3.png",
		"oak_floor3.png",
		"oak_porthole.png",
	},
    is_ground_content = false,
    groups = {wood = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_craft({
	output = "oak_steampunk:oak_porthole",
	type = "shapeless",
	recipe = {"oak_steampunk:oak_frame", "dye:blue", "dye:green"},
})

minetest.register_node("oak_steampunk:oak_porthole2", {
    description = "Oak Porthole 2",
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	tiles = {
		"oak_floor3.png",
		"oak_floor3.png",
		"oak_floor3.png",
		"oak_floor3.png",
		"oak_floor3.png",
		"oak_porthole2.png",
	},
    is_ground_content = false,
    groups = {wood = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_craft({
	output = "oak_steampunk:oak_porthole2",
	type = "shapeless",
	recipe = {"oak_steampunk:oak_frame", "dye:blue", "dye:brown"},
})

minetest.register_node("oak_steampunk:oak_porthole3", {
    description = "Oak Porthole 3",
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	tiles = {
		"oak_floor3.png",
		"oak_floor3.png",
		"oak_floor3.png",
		"oak_floor3.png",
		"oak_floor3.png",
		"oak_porthole3.png",
	},
    is_ground_content = false,
    groups = {wood = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_craft({
	output = "oak_steampunk:oak_porthole3",
	type = "shapeless",
	recipe = {"oak_steampunk:oak_frame", "dye:blue", "dye:yellow"},
})

minetest.register_node("oak_steampunk:oak_porthole4", {
    description = "Oak Porthole 4",
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	tiles = {
		"oak_floor3.png",
		"oak_floor3.png",
		"oak_floor3.png",
		"oak_floor3.png",
		"oak_floor3.png",
		"oak_porthole4.png",
	},
    is_ground_content = false,
    groups = {wood = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_craft({
	output = "oak_steampunk:oak_porthole4",
	type = "shapeless",
	recipe = {"oak_steampunk:oak_frame", "dye:cyan", "dye:yellow"},
})

minetest.register_node("oak_steampunk:oak_porthole5", {
    description = "Oak Porthole 5",
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	tiles = {
		"oak_floor3.png",
		"oak_floor3.png",
		"oak_floor3.png",
		"oak_floor3.png",
		"oak_floor3.png",
		"oak_porthole5.png",
	},
    is_ground_content = false,
    groups = {wood = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_craft({
	output = "oak_steampunk:oak_porthole5",
	type = "shapeless",
	recipe = {"oak_steampunk:oak_frame", "dye:black", "dye:blue"},
})

minetest.register_node("oak_steampunk:oak_plasma", {
    description = "Oak Plasma Lamp",
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	tiles = {
		"oak_floor3.png",
		"oak_floor3.png",
		{name="oak_plasma.png",animation={type="vertical_frames", aspect_w=32, aspect_h=32, length=1.00}},
		{name="oak_plasma.png",animation={type="vertical_frames", aspect_w=32, aspect_h=32, length=1.00}},
		{name="oak_plasma.png",animation={type="vertical_frames", aspect_w=32, aspect_h=32, length=1.00}},
		{name="oak_plasma.png",animation={type="vertical_frames", aspect_w=32, aspect_h=32, length=1.00}},
	},
	light_source = 6,
    is_ground_content = false,
    groups = {wood = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
	sounds = default.node_sound_wood_defaults(),
	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		-- play sound
		minetest.sound_play("plasma",{
			max_hear_distance = 16,
			pos = pos,
			gain = 1.0
		})
	end,
})

minetest.register_craft({
	output = "oak_steampunk:oak_plasma",
	type = "shapeless",
	recipe = {"oak_steampunk:oak_frame", "default:meselamp", "dye:blue"},
})

minetest.register_node("oak_steampunk:oak_control", {
    description = "Oak Control Panel",
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	tiles = {
		"oak_floor3.png",
		"oak_floor3.png",
		"oak_floor3.png",
		"oak_floor3.png",
		"oak_floor3.png",
		"oak_control.png",
	},
    is_ground_content = false,
    groups = {wood = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_craft({
	output = "oak_steampunk:oak_control",
	type = "shapeless",
	recipe = {"oak_steampunk:oak_frame", "default:glass", "default:bronze_ingot"},
})

minetest.register_node("oak_steampunk:oak_glass_green", {
    description = "Oak Glass Green",
    tiles = {"oak_glass_green.png"},
    paramtype = "light",
    light_source = 5,
    is_ground_content = false,
    groups = {cracky = 1, oddly_breakable_by_hand = 1},
	sounds = default.node_sound_glass_defaults(),
})

minetest.register_craft({
	output = "oak_steampunk:oak_glass_green",
	type = "shapeless",
	recipe = {"oak_steampunk:oak_tree_planks", "default:glass", "default:mese_crystal", "dye:green"},
})

minetest.register_node("oak_steampunk:oak_glass_blue", {
    description = "Oak Glass Blue",
    tiles = {"oak_glass_blue.png"},
    paramtype = "light",
    light_source = 5,
    is_ground_content = false,
    groups = {cracky = 1, oddly_breakable_by_hand = 1},
	sounds = default.node_sound_glass_defaults(),
})

minetest.register_craft({
	output = "oak_steampunk:oak_glass_blue",
	type = "shapeless",
	recipe = {"oak_steampunk:oak_tree_planks", "default:glass", "default:mese_crystal", "dye:blue"},
})

minetest.register_node("oak_steampunk:oak_glass_red", {
    description = "Oak Glass Red",
    tiles = {"oak_glass_red.png"},
    paramtype = "light",
    light_source = 5,
    is_ground_content = false,
    groups = {cracky = 1, oddly_breakable_by_hand = 1},
	sounds = default.node_sound_glass_defaults(),
})

minetest.register_craft({
	output = "oak_steampunk:oak_glass_red",
	type = "shapeless",
	recipe = {"oak_steampunk:oak_tree_planks", "default:glass", "default:mese_crystal", "dye:red"},
})

minetest.register_node("oak_steampunk:oak_wood_armed", {
    description = "Armed Oak Wood",
    tiles = {"oak_wood_armed.png"},
    is_ground_content = false,
    groups = {wood = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_craft({
	output = "oak_steampunk:oak_wood_armed 2",
	type = "shapeless",
	recipe = {"oak_steampunk:oak_tree_planks", "oak_steampunk:oak_tree_planks", "default:bronze_ingot"},
})

--button

local function switch_on(pos, node)
	if tubelib.data_not_corrupted(pos) then
		node.name = "oak_steampunk:switch_on"
		minetest.swap_node(pos, node)
		minetest.sound_play("button", {
				pos = pos,
				gain = 0.5,
				max_hear_distance = 5,
			})
		local meta = minetest.get_meta(pos)
		local own_num = meta:get_string("own_num")
		local numbers = meta:get_string("numbers")
		local cycle_time = meta:get_int("cycle_time")
		if cycle_time > 0 then 	-- button mode?
			minetest.get_node_timer(pos):start(cycle_time)
		end
		local placer_name = meta:get_string("placer_name")
		local clicker_name = nil
		if meta:get_string("public") == "false" then
			clicker_name = meta:get_string("clicker_name")
		end
		tubelib.send_message(numbers, placer_name, clicker_name, "on", own_num)  -- <<=== tubelib
	end
end

local function switch_off(pos)
	if tubelib.data_not_corrupted(pos) then
		local node = minetest.get_node(pos)
		node.name = "oak_steampunk:switch_off"
		minetest.swap_node(pos, node)
		minetest.get_node_timer(pos):stop()
		minetest.sound_play("button", {
				pos = pos,
				gain = 0.5,
				max_hear_distance = 5,
			})
		local meta = minetest.get_meta(pos)
		local own_num = meta:get_string("own_num")
		local numbers = meta:get_string("numbers")
		local placer_name = meta:get_string("placer_name")
		local clicker_name = nil
		if meta:get_string("public") == "false" then
			clicker_name = meta:get_string("clicker_name")
		end
		tubelib.send_message(numbers, placer_name, clicker_name, "off", own_num)  -- <<=== tubelib
	end
end


minetest.register_node("oak_steampunk:switch_off", {
	description = "Steampunk Switch",
	tiles = {
		-- up, down, right, left, back, front
		'oak_floor3.png',
		'oak_floor3.png',
		'oak_floor3.png',
		'oak_floor3.png',
		'oak_floor3.png',
		"oak_switch_off.png",
	},

	after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos)
		local own_num = tubelib.add_node(pos, "oak_steampunk:switch_off")
		meta:set_string("own_num", own_num)
		meta:set_string("formspec", "size[7.5,6]"..
		"dropdown[0.2,0;3;type;switch,button 2s,button 4s,button 8s,button 16s;1]".. 
		"field[0.5,2;7,1;numbers;Insert destination node number(s);]" ..
		"checkbox[1,3;public;public;false]"..
		"button_exit[2,4;3,1;exit;Save]")
		meta:set_string("placer_name", placer:get_player_name())
		meta:set_string("public", "false")
		meta:set_int("cycle_time", 0)
		meta:set_string("infotext", "Steampunk Switch "..own_num)
	end,

	on_receive_fields = function(pos, formname, fields, player)
		local meta = minetest.get_meta(pos)
		if tubelib.check_numbers(fields.numbers) then  -- <<=== tubelib
			meta:set_string("numbers", fields.numbers)
			local own_num = meta:get_string("own_num")
			meta:set_string("infotext", "Steampunk Switch "..own_num..", connected with block "..fields.numbers)
		else
			return
		end
		if fields.public then
			meta:set_string("public", fields.public)
		end
		local cycle_time = nil
		if fields.type == "switch" then
			cycle_time = 0
		elseif fields.type == "button 2s" then
			cycle_time = 2
		elseif fields.type == "button 4s" then
			cycle_time = 4
		elseif fields.type == "button 8s" then
			cycle_time = 8
		elseif fields.type == "button 16s" then
			cycle_time = 16
		end
		if cycle_time ~= nil then
			meta:set_int("cycle_time", cycle_time)
		end
		if fields.exit then
			meta:set_string("formspec", nil)
		end
	end,
	
	on_rightclick = function(pos, node, clicker)
		local meta = minetest.get_meta(pos)
		if meta:get_string("numbers") ~= "" and meta:get_string("numbers") ~= nil then
			meta:set_string("clicker_name", clicker:get_player_name())
			switch_on(pos, node)
		end
	end,

	on_rotate = screwdriver.disallow,
	paramtype = "light",
	sunlight_propagates = true,
	paramtype2 = "facedir",
	groups = {choppy=2, cracky=2, crumbly=2},
	is_ground_content = false,
	sounds = default.node_sound_wood_defaults(),
})


minetest.register_node("oak_steampunk:switch_on", {
	description = "Steampunk Switch",
	tiles = {
		-- up, down, right, left, back, front
		'oak_floor3.png',
		'oak_floor3.png',
		'oak_floor3.png',
		'oak_floor3.png',
		'oak_floor3.png',
		"oak_switch_on.png",
	},

	on_rightclick = function(pos, node, clicker)
		local meta = minetest.get_meta(pos)
		meta:set_string("clicker_name", clicker:get_player_name())
		if meta:get_int("cycle_time") == nil or meta:get_int("cycle_time") == 0 then
			switch_off(pos, node)
		end
	end,

	on_timer = switch_off,
	on_rotate = screwdriver.disallow,

	paramtype = "light",
	sunlight_propagates = true,
	paramtype2 = "facedir",
	groups = {choppy=2, cracky=2, crumbly=2, not_in_creative_inventory=1},
	is_ground_content = false,
	sounds = default.node_sound_wood_defaults(),
	drop = "oak_steampunk:switch_off",
})

minetest.register_craft({
	output = "oak_steampunk:switch_off",
	type = "shapeless",
	recipe = {"oak_steampunk:oak_frame", "default:bronze_ingot", "default:bronze_ingot"},
})
