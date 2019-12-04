-- basic_materials compatibility

local brass_ingot_name

if minetest.get_modpath("basic_materials") then
  -- Use basic materials brass ingot
  brass_ingot_name = "basic_materials:brass_ingot"
else
  -- Register and use morelights brass ingot
  minetest.register_craftitem("morelights_vintage:brass_ingot", {
    description = "Brass Ingot",
    inventory_image = "default_steel_ingot.png^[multiply:#FFCE69"
  })

  minetest.register_craft({
    output = "morelights_vintage:brass_ingot 2",
    type = "shapeless",
    recipe = {
      "default:copper_ingot", "default:tin_ingot"
    }
  })

  brass_ingot_name = "morelights_vintage:brass_ingot"
end

minetest.register_node("morelights_vintage:chain_b", {
  description = "Brass Chain",
  drawtype = "mesh",
  mesh = "morelights_chain.obj",
  collision_box = {
    type = "fixed",
    fixed = {-1/16, -8/16, -1/16, 1/16, 8/16, 1/16}
  },
  selection_box = {
    type = "fixed",
    fixed = {-1/16, -8/16, -1/16, 1/16, 8/16, 1/16}
  },
  tiles = {"morelights_vintage_brass_32.png"},
  paramtype = "light",
  groups = {cracky = 3, oddly_breakable_by_hand = 3, mounted_ceiling = 1},
  sounds = default.node_sound_metal_defaults(),

  on_place = function(itemstack, placer, pointed_thing)
    return morelights.on_place_hanging(itemstack, placer, pointed_thing,
      "morelights_vintage:chain_ceiling_b")
  end,
})

minetest.register_node("morelights_vintage:chain_ceiling_b", {
  drawtype = "mesh",
  mesh = "morelights_chain_ceiling.obj",
  collision_box = {
    type = "fixed",
    fixed = {{-3/16,  7/16, -3/16, 3/16,  8/16, 3/16},
      {-1/16, -8/16, -1/16, 1/16, 7/16, 1/16}}
  },
  selection_box = {
    type = "fixed",
    fixed = {{-3/16,  7/16, -3/16, 3/16,  8/16, 3/16},
      {-1/16, -8/16, -1/16, 1/16, 7/16, 1/16}}
  },
  tiles = {"morelights_vintage_brass_32.png"},
  drop = "morelights_vintage:chain_b",
  paramtype = "light",
  groups = {cracky = 3, oddly_breakable_by_hand = 3,
    not_in_creative_inventory = 1, mounted_ceiling = 1},
  sounds = default.node_sound_metal_defaults(),
})

minetest.register_node("morelights_vintage:block", {
  description = "Vintage Light Block",
  tiles = {"morelights_vintage_block.png"},
  paramtype = "light",
  light_source = LIGHT_MAX,
  groups = {cracky = 2, oddly_breakable_by_hand = 3},
  sounds = default.node_sound_glass_defaults(),
})

minetest.register_node("morelights_vintage:smallblock", {
  description = "Vintage Light Block (small)",
  drawtype = "nodebox",
  node_box = {
    type = "fixed",
    fixed = {-1/4, -1/2, -1/4, 1/4, 0, 1/4}
  },
  tiles = {"morelights_vintage_block.png", "morelights_vintage_block.png",
    "[combine:16x16:0,4=morelights_vintage_block.png"},
  paramtype = "light",
  paramtype2 = "facedir",
  light_source = 12,
  groups = {cracky = 2, oddly_breakable_by_hand = 3},
  sounds = default.node_sound_glass_defaults(),
  on_place = function(itemstack, placer, pointed_thing)
    return morelights.rotate_and_place(itemstack, placer, pointed_thing)
  end,
})

minetest.register_node("morelights_vintage:lantern_f", {
  description = "Vintage Lantern (floor, wall, or ceiling)",
  drawtype = "mesh",
  mesh = "morelights_vintage_lantern_f.obj",
  tiles = {"morelights_vintage_lantern.png", "morelights_metal_dark_32.png"},
  collision_box = {
    type = "fixed",
    fixed = {-3/16, -1/2, -3/16, 3/16, 1/16, 3/16}
  },
  selection_box = {
    type = "fixed",
    fixed = {-3/16, -1/2, -3/16, 3/16, 1/16, 3/16}
  },
  paramtype = "light",
  light_source = 12,
  groups = {cracky = 2, oddly_breakable_by_hand = 3},
  sounds = default.node_sound_glass_defaults(),

  on_place = function(itemstack, placer, pointed_thing)
		local wdir = minetest.dir_to_wallmounted(
      vector.subtract(pointed_thing.under, pointed_thing.above))
		local fakestack = itemstack

		if wdir == 0 then
			fakestack:set_name("morelights_vintage:lantern_c")
		elseif wdir == 1 then
			fakestack:set_name("morelights_vintage:lantern_f")
		else
			fakestack:set_name("morelights_vintage:lantern_w")
		end

		itemstack = minetest.item_place(fakestack, placer, pointed_thing, wdir)
		itemstack:set_name("morelights_vintage:lantern_f")

		return itemstack
	end,
})

minetest.register_node("morelights_vintage:lantern_c", {
  drawtype = "mesh",
  mesh = "morelights_vintage_lantern_c.obj",
  tiles = {"morelights_vintage_lantern.png", "morelights_metal_dark_32.png"},
  collision_box = {
    type = "fixed",
    fixed = {-3/16, -1/16, -3/16, 3/16, 1/2, 3/16}
  },
  selection_box = {
    type = "fixed",
    fixed = {-3/16, 0, -3/16, 3/16, 1/2, 3/16}
  },
  paramtype = "light",
  light_source = 12,
  groups = {cracky = 2, oddly_breakable_by_hand = 3,
    not_in_creative_inventory = 1},
  sounds = default.node_sound_glass_defaults(),
  drop = "morelights_vintage:lantern_f",
})

minetest.register_node("morelights_vintage:lantern_w", {
  drawtype = "mesh",
  mesh = "morelights_vintage_lantern_w.obj",
  tiles = {"morelights_vintage_lantern.png", "morelights_metal_dark_32.png"},
  collision_box = {
    type = "fixed",
    fixed = {-3/16, -1/4, -5/16, 3/16, 1/8, 3/16}
  },
  selection_box = {
    type = "wallmounted",
    wall_bottom = {-3/16, -1/4, -5/16, 3/16, 1/8, 3/16},
    wall_side = {-1/4, -5/16, -3/16, 1/8, 3/16, 3/16},
    wall_top = {-3/16, -1/8, -5/16, 3/16, 1/4, 3/16}
  },
  paramtype = "light",
  paramtype2 = "wallmounted",
  light_source = 12,
  groups = {cracky = 2, oddly_breakable_by_hand = 3,
    not_in_creative_inventory = 1},
  sounds = default.node_sound_glass_defaults(),
  drop = "morelights_vintage:lantern_f",
})

minetest.register_node("morelights_vintage:hangingbulb", {
  description = "Vintage Hanging Light Bulb",
  drawtype = "mesh",
  mesh = "morelights_vintage_hangingbulb.obj",
  tiles = {"morelights_vintage_hangingbulb.png^[lowpart:50:morelights_metal_dark_32.png"},
  use_texture_alpha = true,
  collision_box = {
    type = "fixed",
    fixed = {-1/8, -1/8, -1/8, 1/8, 1/2, 1/8}
  },
  selection_box = {
    type = "fixed",
    fixed = {-1/8, -1/8, -1/8, 1/8, 1/2, 1/8}
  },
  paramtype = "light",
  light_source = 10,
  groups = {cracky = 2, oddly_breakable_by_hand = 3},
  sounds = default.node_sound_glass_defaults(),
})

minetest.register_node("morelights_vintage:oillamp", {
  description = "Vintage Oil Lamp",
  drawtype = "mesh",
  mesh = "morelights_vintage_oillamp.obj",
  tiles = {{name = "morelights_vintage_oil_flame.png",
    animation = {type = "sheet_2d", frames_w = 16, frames_h = 1, frame_length = 0.3}},
    "morelights_vintage_oillamp.png",
    "morelights_vintage_brass_32.png"},
  collision_box = {
    type = "fixed",
    fixed = {-1/8, -1/2, -1/8, 1/8, 1/4, 1/8}
  },
  selection_box = {
    type = "fixed",
    fixed = {-1/8, -1/2, -1/8, 1/8, 1/4, 1/8}
  },
  paramtype = "light",
  light_source = 8,
  groups = {cracky = 2, oddly_breakable_by_hand = 3},
  sounds = default.node_sound_glass_defaults(),
})

minetest.register_node("morelights_vintage:chandelier", {
  description = "Vintage Chandelier",
  drawtype = "mesh",
  mesh = "morelights_vintage_chandelier.obj",
  tiles = {"morelights_vintage_chandelier.png",
    "morelights_vintage_brass_32.png^[multiply:#DFDFDF"},
  collision_box = {
    type = "fixed",
    fixed = {-3/8, -1/2, -3/8, 3/8, 1/2, 3/8}
  },
  selection_box = {
    type = "fixed",
    fixed = {-3/8, -1/2, -3/8, 3/8, 1/2, 3/8}
  },
  paramtype = "light",
  light_source = 10,
  groups = {cracky = 2, oddly_breakable_by_hand = 3},
  sounds = default.node_sound_glass_defaults(),
})

--
-- Craft recipes
--

minetest.register_craft({
  output = "morelights_vintage:chain_b",
  recipe = {
    {"", brass_ingot_name, ""},
    {"", "", ""},
    {"", brass_ingot_name, ""}
  }
})

minetest.register_craft({
  output = "morelights_vintage:block",
  recipe = {
    {"", "default:junglewood", ""},
    {morelights.glass, "morelights:bulb", morelights.glass},
    {"", "default:junglewood", ""}
  }
})

minetest.register_craft({
  output = "morelights_vintage:smallblock",
  recipe = {
    {"", morelights.glass, ""},
    {"default:junglewood", "morelights:bulb", "default:junglewood"}
  }
})

minetest.register_craft({
  output = "morelights_vintage:lantern_f",
  recipe = {
    {"", "default:steel_ingot", ""},
    {morelights.glass, "morelights:bulb", morelights.glass},
    {"default:stick", "default:steel_ingot", "default:stick"}
  }
})

minetest.register_craft({
  output = "morelights_vintage:hangingbulb",
  recipe = {
    {"", "default:steel_ingot", ""},
    {"", "default:copper_ingot", ""},
    {"", "morelights:bulb", ""}
  }
})

minetest.register_craft({
  output = "morelights_vintage:oillamp",
  recipe = {
    {"", "default:glass", ""},
    {"farming:cotton", brass_ingot_name, ""},
    {"", "default:glass", ""}
  }
})

minetest.register_craft({
  output = "morelights_vintage:chandelier",
  recipe = {
    {"", brass_ingot_name, ""},
    {"morelights:bulb", brass_ingot_name, "morelights:bulb"},
    {"default:steel_ingot", brass_ingot_name, "default:steel_ingot"}
  }
})
