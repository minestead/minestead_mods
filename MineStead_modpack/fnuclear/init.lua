minetest.register_node("fnuclear:lamp", {
	description = "Uranium Lamp",
	tiles = {"uranium_lamp.png"},
	paramtype = "light",
	light_source = LIGHT_MAX,
	groups = {cracky = 2, oddly_breakable_by_hand = 3},
	sounds = default.node_sound_glass_defaults(),
})

minetest.register_craft({
	output = "fnuclear:lamp",
	recipe = {
	{"technic:lead_ingot", "technic:lead_ingot", "technic:lead_ingot"},
	{"technic:lead_ingot", "technic:uranium0_block", "technic:lead_ingot"},
	{"technic:lead_ingot", "technic:lead_ingot", "technic:lead_ingot"}
  }
})

minetest.register_tool("fnuclear:uranium_pick", {
	description = "Uranium Pickaxe",
	inventory_image = "uranium_pickaxe.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level=3,
		groupcaps={
			cracky = {times={[1]=2.0, [2]=1.0, [3]=0.50}, uses=100, maxlevel=3},
		},
		damage_groups = {fleshy=5},
	},
	paramtype = "light",
	light_source = 12,
	sound = {breaks = "default_tool_breaks"},
})

minetest.register_craft({
	output = "fnuclear:uranium_pick",
	recipe = {
	{"technic:uranium0_ingot", "technic:uranium0_ingot", "technic:uranium0_ingot"},
	{"", "default:stick", ""},
	{"", "default:stick", ""}
  }
})

minetest.register_tool("fnuclear:uranium_axe", {
	description = "Uranium Axe",
	inventory_image = "uranium_axe.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level=1,
		groupcaps={
			choppy={times={[1]=2.10, [2]=0.90, [3]=0.50}, uses=100, maxlevel=3},
		},
		damage_groups = {fleshy=7},
	},
	paramtype = "light",
	light_source = 12,
	sound = {breaks = "default_tool_breaks"},
})

minetest.register_craft({
	output = "fnuclear:uranium_axe",
	recipe = {
	{"", "technic:uranium0_ingot", ""},
	{"technic:uranium0_ingot", "default:gold_ingot", "technic:uranium0_ingot"},
	{"", "default:gold_ingot", ""}
  }
})

minetest.register_tool("fnuclear:uranium_shovel", {
	description = "Uranium Shovel",
	inventory_image = "uranium_shovel.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			crumbly = {times={[1]=1.10, [2]=0.50, [3]=0.30}, uses=100, maxlevel=3},
		},
		damage_groups = {fleshy=4},
	},
	paramtype = "light",
	light_source = 12,
	sound = {breaks = "default_tool_breaks"},
})

minetest.register_craft({
	output = "fnuclear:uranium_shovel",
	recipe = {
	{"technic:uranium0_ingot", "", ""},
	{"default:stick", "", ""},
	{"moreores:silver_ingot", "", ""}
  }
})

minetest.register_tool("fnuclear:uranium_sword", {
	description = "Uranium Sword",
	inventory_image = "uranium_sword.png",
	tool_capabilities = {
		full_punch_interval = 0.7,
		max_drop_level=1,
		groupcaps={
			snappy={times={[1]=1.90, [2]=0.90, [3]=0.30}, uses=100, maxlevel=3},
		},
		damage_groups = {fleshy=8},
	},
	paramtype = "light",
	light_source = 12,
	sound = {breaks = "default_tool_breaks"},
})

minetest.register_craft({
	output = "fnuclear:uranium_sword",
	recipe = {
	{"technic:uranium0_ingot", "", ""},
	{"technic:uranium0_ingot", "", ""},
	{"default:bronze_ingot", "", ""}
  }
})

minetest.register_tool("fnuclear:uranium_crowbar", {
	description = "Uranium Crowbar",
	inventory_image = "uranium_crowbar.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level=1,
		groupcaps={
			choppy={times={[1]=2.10, [2]=0.90, [3]=0.50}, uses=100, maxlevel=3},
		},
		damage_groups = {fleshy=10},
	},
	paramtype = "light",
	light_source = 12,
	sound = {breaks = "default_tool_breaks"},
})

minetest.register_craft({
	output = "fnuclear:uranium_crowbar",
	recipe = {
	{"", "technic:uranium0_ingot", ""},
	{"", "technic:uranium0_ingot", ""},
	{"", "technic:uranium0_ingot", ""}
  }
})

minetest.register_node("fnuclear:toxic_barrel", {
	description = "Toxic Barrel",
	tiles = {"toxic_barrel.png" },
	drawtype = "mesh",
	mesh = "wine_barrel.obj",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {
		choppy = 2, oddly_breakable_by_hand = 1,
		tubedevice = 1, tubedevice_receiver = 1
	},
	tube = {
		insert_object = function(pos, node, stack, direction)
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			return inv:add_item("main", stack)
		end,
		can_insert = function(pos, node, stack, direction)
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			if meta:get_int("splitstacks") == 1 then
				stack = stack:peek_item(1)
			end
			return inv:room_for_item("main", stack)
		end,
		input_inventory = "main",
		connect_sides = {left = 1, right = 1, back = 1, bottom = 1, top = 1}
	},
	legacy_facedir_simple = true,
	on_place = minetest.rotate_node,
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec",
				"size[8,9;]"..
				"list[current_name;main;0,0;8,4;]"..
				"list[current_player;main;0,5;8,4;]")
		meta:set_string("infotext", "Toxic Barrel")
		meta:set_float("status", 0.0)
		local inv = meta:get_inventory()
		inv:set_size("main", 8 * 4)
	end,

})

minetest.register_craft({
	output = "fnuclear:toxic_barrel",
	recipe = {
		{"technic:lead_ingot", "", "technic:lead_ingot"},
		{"technic:lead_ingot", "", "technic:lead_ingot"},
		{"technic:lead_ingot", "technic:lead_ingot", "technic:lead_ingot"},
	},
})

minetest.register_tool("fnuclear:uranium_sickle", {
	description = "Uranium Sickle",
	inventory_image = "uranium_sickle.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level=2,
		groupcaps={
			fleshy = {times = {[2] = 0.65, [3] = 0.25}, uses = 500, maxlevel = 2},
			snappy = {times = {[2] = 0.70, [3] = 0.25}, uses = 500, maxlevel = 2},
		},
		damage_groups = {fleshy=8},
	},
	paramtype = "light",
	light_source = 12,
	sound = {breaks = "default_tool_breaks"},
	on_place = function(itemstack, placer, pointed_thing)

		if pointed_thing.type ~= "node" then
			return
		end

		local pos = pointed_thing.under
		local name = placer:get_player_name()

		if minetest.is_protected(pos, name) then
			return
		end

		local node = minetest.get_node_or_nil(pos)

		if not node then
			return
		end

		local def = minetest.registered_nodes[node.name]

		if not def then
			return
		end

		if not def.drop then
			return
		end

		if not def.groups
		or not def.groups.plant then
			return
		end

		local drops = minetest.get_node_drops(node.name, "")

		if not drops
		or #drops == 0
		or (#drops == 1 and drops[1] == "") then
			return
		end

		-- get crop name
		local mname = node.name:split(":")[1]
		local pname = node.name:split(":")[2]
		local sname = tonumber(pname:split("_")[2])
		pname = pname:split("_")[1]

		if not sname then
			return
		end

		-- add dropped items
		for _, dropped_item in pairs(drops) do

			-- dont drop items on this list
			for _, not_item in pairs({"farming:trellis", "farming:beanpole"}) do

				if dropped_item == not_item then
					dropped_item = nil
				end
			end

			if dropped_item then

				local obj = minetest.add_item(pos, dropped_item)

				if obj then

					obj:set_velocity({
						x = math.random(-10, 10) / 9,
						y = 3,
						z = math.random(-10, 10) / 9,
					})
				end
			end
		end

		-- Run script hook
		for _, callback in pairs(core.registered_on_dignodes) do
			callback(pos, node, placer)
		end

		-- play sound
		minetest.sound_play("default_grass_footstep", {pos = pos, gain = 1.0})

		local replace = mname .. ":" .. pname .. "_1"

		if minetest.registered_nodes[replace] then

			local p2 = minetest.registered_nodes[replace].place_param2 or 1

			minetest.set_node(pos, {name = replace, param2 = p2})
		else
			minetest.set_node(pos, {name = "air"})
		end

		itemstack:add_wear(65535 / 500) -- 500 uses
		return itemstack

	end,
})

minetest.register_craft({
	output = "fnuclear:uranium_sickle",
	recipe = {
	{"technic:uranium0_ingot", "technic:uranium0_ingot", ""},
	{"", "", "technic:uranium0_ingot"},
	{"", "default:stick", ""}
  }
})

minetest.register_tool("fnuclear:uranium_hammer", {
	description = "Uranium Hammer",
	inventory_image = "uranium_hammer.png",
	paramtype = "light",
	light_source = 12,
	on_use = function(itemstack, user, pointed_thing)
	if pointed_thing.type ~= "node" then
		return
	end

	local pos = pointed_thing.under

	if minetest.is_protected(pos, user:get_player_name()) then
		minetest.record_protection_violation(pos, user:get_player_name())
		return
	end

	local node = minetest.get_node(pos)
	if node.name == "default:cobble" or node.name == "default:mossycobble"
		or node.name == "default:desert_cobble" or node.name == "default:stone"
		or node.name == "default:desert_sandstone" or node.name == "default:desert_stone"
		or node.name == "default:sandstone" or node.name == "default:silver_sandstone" then
		node.name = "default:gravel"
		minetest.swap_node(pos, node)
		minetest.sound_play({
			name="default_dig_crumbly"},{
			gain=1,
			pos=pos,
			max_hear_distance=6,
			loop=false})
	elseif node.name == "default:gravel" or node.name == "gravelsieve:compressed_gravel" then
		node.name = "default:sand"
		minetest.swap_node(pos, node)
		minetest.sound_play({
			name="default_dig_crumbly"},{
			gain=1,
			pos=pos,
			max_hear_distance=6,
			loop=false})
	end

	itemstack:add_wear(65535 / 500)
	return itemstack
	end,
})

minetest.register_craft({
	output = "fnuclear:uranium_hammer",
	recipe = {
		{"", "technic:uranium0_ingot", ""},
		{"", "default:stick", "technic:uranium0_ingot"},
		{"default:stick", "", ""},
	}
})

minetest.register_craft({
	type = "shapeless",
	output = "default:mese_crystal_fragment 15",
	recipe = {'default:pick_mese', 'fnuclear:uranium_hammer'},
	replacements = {{'fnuclear:uranium_hammer', 'fnuclear:uranium_hammer'}},
})

minetest.register_craft({
	type = "shapeless",
	output = "default:mese_crystal_fragment 15",
	recipe = {'default:axe_mese', 'fnuclear:uranium_hammer'},
	replacements = {{'fnuclear:uranium_hammer', 'fnuclear:uranium_hammer'}},
})

minetest.register_craft({
	type = "shapeless",
	output = "default:mese_crystal_fragment 15",
	recipe = {'default:shovel_mese', 'fnuclear:uranium_hammer'},
	replacements = {{'fnuclear:uranium_hammer', 'fnuclear:uranium_hammer'}},
})

minetest.register_craft({
	type = "shapeless",
	output = "default:mese_crystal_fragment 15",
	recipe = {'default:sword_mese', 'fnuclear:uranium_hammer'},
	replacements = {{'fnuclear:uranium_hammer', 'fnuclear:uranium_hammer'}},
})
minetest.register_craft({
	type = "shapeless",
	output = "default:diamond",
	recipe = {'default:pick_diamond', 'fnuclear:uranium_hammer'},
	replacements = {{'fnuclear:uranium_hammer', 'fnuclear:uranium_hammer'}},
})

minetest.register_craft({
	type = "shapeless",
	output = "default:diamond",
	recipe = {'default:axe_diamond', 'fnuclear:uranium_hammer'},
	replacements = {{'fnuclear:uranium_hammer', 'fnuclear:uranium_hammer'}},
})

minetest.register_craft({
	type = "shapeless",
	output = "default:diamond",
	recipe = {'default:shovel_diamond', 'fnuclear:uranium_hammer'},
	replacements = {{'fnuclear:uranium_hammer', 'fnuclear:uranium_hammer'}},
})

minetest.register_craft({
	type = "shapeless",
	output = "default:diamond",
	recipe = {'default:sword_diamond', 'fnuclear:uranium_hammer'},
	replacements = {{'fnuclear:uranium_hammer', 'fnuclear:uranium_hammer'}},
})
