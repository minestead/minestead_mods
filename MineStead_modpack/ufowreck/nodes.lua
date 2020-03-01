local chest_formspec =
	"size[8,9]" ..
	default.gui_bg ..
	default.gui_bg_img ..
	default.gui_slots ..
	"list[current_name;main;0,0.3;8,4;]" ..
	"list[current_player;main;0,4.85;8,1;]" ..
	"list[current_player;main;0,6.08;8,3;8]" ..
	"listring[current_name;main]" ..
	"listring[current_player;main]" ..
	default.get_hotbar_bg(0,4.85)

minetest.register_node("ufowreck:locked_crate", {
	description = "Locked Crate",
	tiles = {"scifi_nodes_crate.png"},
	paramtype2 = "facedir",
	groups = {cracky = 1, oddly_breakable_by_hand = 2, fuel = 8},
	legacy_facedir_simple = true,
	is_ground_content = false,
	sounds = default.node_sound_metal_defaults(),
	drop = {
		max_items = 3,
		items = {
			{items = {'ufowreck:pad'}, rarity = 10},
			{items = {'ufowreck:glow_plant'},rarity = 5},
			{items = {'ufowreck:eye'},rarity = 5},
			{items = {'ufowreck:predatory_plant'},rarity = 5},
			{items = {'default:mese'},rarity = 5},
			{items = {'technic:uranium_block'},rarity = 5},
			{items = {'ufowreck:powered_stand'},rarity = 5},
			{items = {'ufowreck:ladder 9'},rarity = 5},
			{items = {'ufowreck:crate'}},
		}
	},
})

minetest.register_node("ufowreck:crate", {
	description = "Crate",
	tiles = {"scifi_nodes_crate.png"},
	paramtype2 = "facedir",
	groups = {cracky = 1, oddly_breakable_by_hand = 2},
	legacy_facedir_simple = true,
	is_ground_content = false,
	sounds = default.node_sound_metal_defaults(),
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", chest_formspec)
		meta:set_string("infotext", "Crate")
		local inv = meta:get_inventory()
		inv:set_size("main", 8 * 4)
	end,
	on_metadata_inventory_move = function(pos, from_list, from_index,
			to_list, to_index, count, player)
		minetest.log("action", player:get_player_name() ..
			" moves stuff in chest at " .. minetest.pos_to_string(pos))
	end,
    on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name() ..
			" moves stuff to chest at " .. minetest.pos_to_string(pos))
	end,
    on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name() ..
			" takes stuff from chest at " .. minetest.pos_to_string(pos))
	end,
})

minetest.register_node("ufowreck:alien_metal", {
    description = "Alien Metal Block",
    tiles = {"scifi_nodes_lighttop.png"},
	drawtype = "nodebox",
	paramtype2 = "facedir",
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {cracky = 1},
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_craft({
    output = "default:steel_ingot 9",
    type = "shapeless",
    recipe = {"ufowreck:alien_metal"}
})

minetest.register_node("ufowreck:alien_light", {
	description = "Alien Lightbox",
	sunlight_propagates = false,
	tiles = {
		"scifi_nodes_lighttop.png",
		"scifi_nodes_lighttop.png",
		"scifi_nodes_greenlight.png",
		"scifi_nodes_greenlight.png",
		"scifi_nodes_greenlight.png",
		"scifi_nodes_greenlight.png"
	},
	light_source = 10,
	paramtype = "light",
	groups = {cracky=1},
	sounds = default.node_sound_glass_defaults()
})

minetest.register_craft({
    output = "ufowreck:alien_light",
    type = "shapeless",
    recipe = {"ufowreck:alien_metal", "technic:uranium0_ingot"}
})

minetest.register_node("ufowreck:alien_glass", {
	description = "Alien Glass",
	drawtype = "glasslike",
	sunlight_propagates = true,
	tiles = {
		"scifi_nodes_glass.png"
	},
	use_texture_alpha = true,
	paramtype = "light",
	groups = {cracky=1},
	sounds = default.node_sound_glass_defaults()
})

minetest.register_craft({
    output = "ufowreck:alien_glass 2",
    type = "shapeless",
    recipe = {"ufowreck:alien_metal", "default:obsidian_glass"}
})

minetest.register_node("ufowreck:alien_control", {
	description = "Alien Control Block",
	sunlight_propagates = false,
	tiles = {{
		name="scifi_nodes_black_lights.png",
		animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=3.50}, --length=0.50
	}},
	paramtype = "light",
	groups = {cracky=1},
	sounds = default.node_sound_metal_defaults(),
})

--door

minetest.register_node("ufowreck:alien_door_closed", {
	description = "Alien Door",
	inventory_image = "scifi_nodes_door_black_inv.png",
	wield_image = "scifi_nodes_door_black_inv.png",
	tiles = {
		"scifi_nodes_door_black_edge.png",
		"scifi_nodes_door_black_edge.png",
		"scifi_nodes_door_black_edge.png",
		"scifi_nodes_door_black_edge.png",
		"scifi_nodes_door_black_rbottom.png",
		"scifi_nodes_door_black_bottom.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {cracky = 1, oddly_breakable_by_hand = 1},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.0625, 0.5, 0.5, 0.0625}
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.0625, 0.5, 1.5, 0.0625}
		}
	},
	on_place = function(itemstack, placer, pointed_thing)
		-- Is there room enough ?
		local pos1 = pointed_thing.above
		local pos2 = {x=pos1.x, y=pos1.y, z=pos1.z}
			  pos2.y = pos2.y+1 -- 2 nodes above

		if
		not minetest.registered_nodes[minetest.get_node(pos1).name].buildable_to or
		not minetest.registered_nodes[minetest.get_node(pos2).name].buildable_to or
		not placer or
		not placer:is_player() or
		minetest.is_protected(pos1, placer:get_player_name()) or
		minetest.is_protected(pos2, placer:get_player_name()) then
			return
		end

		local pt = pointed_thing.above
		local pt2 = {x=pt.x, y=pt.y, z=pt.z}
		pt2.y = pt2.y+1
		-- Player look dir is converted to node rotation ?
		local p2 = minetest.dir_to_facedir(placer:get_look_dir())
		-- Where to look for another door ?
		local pt3 = {x=pt.x, y=pt.y, z=pt.z}

		-- Door param2 depends of placer's look dir
		local p4 = 0
		if p2 == 0 then
			pt3.x = pt3.x-1
			p4 = 2
		elseif p2 == 1 then
			pt3.z = pt3.z+1
			p4 = 3
		elseif p2 == 2 then
			pt3.x = pt3.x+1
			p4 = 0
		elseif p2 == 3 then
			pt3.z = pt3.z-1
			p4 = 1
		end

		-- First door of a pair is already there
		if minetest.get_node(pt3).name == "ufowreck:alien_door_closed" then
			minetest.set_node(pt, {name="ufowreck:alien_door_closed", param2=p4,})
			minetest.set_node(pt2, {name="ufowreck:alien_door_closed_top", param2=p4})
		--	Placed door is the first of a pair
		else
			minetest.set_node(pt, {name="ufowreck:alien_door_closed", param2=p2,})
			minetest.set_node(pt2, {name="ufowreck:alien_door_closed_top", param2=p2})
		end

		itemstack:take_item(1)
		return itemstack;
	end,

	after_destruct = function(pos, oldnode)
		minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z},{name="air"})
	end,

	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		-- play sound
		minetest.sound_play("scifi_nodes_door_mechanic",{
			max_hear_distance = 16,
			pos = pos,
			gain = 1.0
		})

		local timer = minetest.get_node_timer(pos)
		local a = minetest.get_node({x=pos.x, y=pos.y, z=pos.z-1})
		local b = minetest.get_node({x=pos.x, y=pos.y, z=pos.z+1})
		local c = minetest.get_node({x=pos.x+1, y=pos.y, z=pos.z})
		local d = minetest.get_node({x=pos.x-1, y=pos.y, z=pos.z})
		local e = minetest.get_node({x=pos.x+1, y=pos.y, z=pos.z-1})
		local f = minetest.get_node({x=pos.x-1, y=pos.y, z=pos.z-1})
		local g = minetest.get_node({x=pos.x+1, y=pos.y, z=pos.z+1})
		local h = minetest.get_node({x=pos.x-1, y=pos.y, z=pos.z+1})


			minetest.set_node(pos, {name="ufowreck:alien_door_opened", param2=node.param2})
			minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z}, {name="ufowreck:alien_door_opened_top", param2=node.param2})

			 if a.name == "ufowreck:alien_door_closed" then
			minetest.set_node({x=pos.x, y=pos.y, z=pos.z-1}, {name="ufowreck:alien_door_opened", param2=a.param2})
			minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z-1}, {name="ufowreck:alien_door_opened_top", param2=a.param2})
			end
			 if b.name == "ufowreck:alien_door_closed" then
			minetest.set_node({x=pos.x, y=pos.y, z=pos.z+1}, {name="ufowreck:alien_door_opened", param2=b.param2})
			minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z+1}, {name="ufowreck:alien_door_opened_top", param2=b.param2})
			end
			 if c.name == "ufowreck:alien_door_closed" then
			minetest.set_node({x=pos.x+1, y=pos.y, z=pos.z}, {name="ufowreck:alien_door_opened", param2=c.param2})
			minetest.set_node({x=pos.x+1,y=pos.y+1,z=pos.z}, {name="ufowreck:alien_door_opened_top", param2=c.param2})
			end
			 if d.name == "ufowreck:alien_door_closed" then
			minetest.set_node({x=pos.x-1, y=pos.y, z=pos.z}, {name="ufowreck:alien_door_opened", param2=d.param2})
			minetest.set_node({x=pos.x-1,y=pos.y+1,z=pos.z}, {name="ufowreck:alien_door_opened_top", param2=d.param2})
			end
			 if e.name == "ufowreck:alien_door_closed" then
			minetest.set_node({x=pos.x+1, y=pos.y, z=pos.z-1}, {name="ufowreck:alien_door_opened", param2=e.param2})
			minetest.set_node({x=pos.x+1, y=pos.y+1, z=pos.z-1}, {name="ufowreck:alien_door_opened_top", param2=e.param2})
			end
			 if f.name == "ufowreck:alien_door_closed" then
			minetest.set_node({x=pos.x-1, y=pos.y, z=pos.z-1}, {name="ufowreck:alien_door_opened", param2=f.param2})
			minetest.set_node({x=pos.x-1, y=pos.y+1, z=pos.z-1}, {name="ufowreck:alien_door_opened_top", param2=f.param2})
			end
			 if g.name == "ufowreck:alien_door_closed" then
			minetest.set_node({x=pos.x+1, y=pos.y, z=pos.z+1}, {name="ufowreck:alien_door_opened", param2=g.param2})
			minetest.set_node({x=pos.x+1, y=pos.y+1, z=pos.z+1}, {name="ufowreck:alien_door_opened_top", param2=g.param2})
			end
			 if h.name == "ufowreck:alien_door_closed" then
			minetest.set_node({x=pos.x-1, y=pos.y, z=pos.z+1}, {name="ufowreck:alien_door_opened", param2=h.param2})
			minetest.set_node({x=pos.x-1, y=pos.y+1, z=pos.z+1}, {name="ufowreck:alien_door_opened_top", param2=h.param2})
			end
			timer:start(5)
	end,
})

minetest.register_node("ufowreck:alien_door_closed_top", {
	tiles = {
		"scifi_nodes_door_black_edge.png",
		"scifi_nodes_door_black_edge.png",
		"scifi_nodes_door_black_edge.png",
		"scifi_nodes_door_black_edge.png",
		"scifi_nodes_door_black_rtop.png",
		"scifi_nodes_door_black_top.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {cracky = 1},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.0625, 0.5, 0.5, 0.0625}
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{0, 0, 0, 0, 0, 0},
		}
	},
	can_dig = function(pos, player)
		return false
	end,
})

minetest.register_node("ufowreck:alien_door_opened", {
	tiles = {
		"scifi_nodes_door_black_edge.png",
		"scifi_nodes_door_black_edge.png",
		"scifi_nodes_door_black_edge.png",
		"scifi_nodes_door_black_edge.png",
		"scifi_nodes_door_black_rbottom0.png",
		"scifi_nodes_door_black_bottom0.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	drop = closed,
	groups = {cracky = 1},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.0625, -0.25, 0.5, 0.0625},
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.0625, -0.25, 1.5, 0.0625},
		}
	},
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		local node = minetest.get_node(pos)
		minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z},{name="ufowreck:alien_door_opened_top",param2=node.param2})
	end,
	after_destruct = function(pos, oldnode)
		minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z},{name="air"})
	end,
	on_timer = function(pos, elapsed)
		-- play sound
		minetest.sound_play("scifi_nodes_door_mechanic",{
			max_hear_distance = 16,
			pos = pos,
			gain = 1.0
		})

		local node = minetest.get_node(pos)
		local a = minetest.get_node({x=pos.x, y=pos.y, z=pos.z-1})
		local b = minetest.get_node({x=pos.x, y=pos.y, z=pos.z+1})
		local c = minetest.get_node({x=pos.x+1, y=pos.y, z=pos.z})
		local d = minetest.get_node({x=pos.x-1, y=pos.y, z=pos.z})
		local e = minetest.get_node({x=pos.x+1, y=pos.y, z=pos.z-1})
		local f = minetest.get_node({x=pos.x-1, y=pos.y, z=pos.z-1})
		local g = minetest.get_node({x=pos.x+1, y=pos.y, z=pos.z+1})
		local h = minetest.get_node({x=pos.x-1, y=pos.y, z=pos.z+1})

		minetest.set_node(pos, {name="ufowreck:alien_door_closed", param2=node.param2})
		minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z}, {name="ufowreck:alien_door_closed_top", param2=node.param2})

		if a.name == "ufowreck:alien_door_opened" then
			minetest.set_node({x=pos.x, y=pos.y, z=pos.z-1}, {name="ufowreck:alien_door_closed", param2=a.param2})
			minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z-1}, {name="ufowreck:alien_door_closed_top", param2=a.param2})
		end
		if b.name == "ufowreck:alien_door_opened" then
			minetest.set_node({x=pos.x, y=pos.y, z=pos.z+1}, {name="ufowreck:alien_door_closed", param2=b.param2})
			minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z+1}, {name="ufowreck:alien_door_closed_top", param2=b.param2})
		end
		if c.name == "ufowreck:alien_door_opened" then
			minetest.set_node({x=pos.x+1, y=pos.y, z=pos.z}, {name="ufowreck:alien_door_closed", param2=c.param2})
			minetest.set_node({x=pos.x+1,y=pos.y+1,z=pos.z}, {name="ufowreck:alien_door_closed_top", param2=c.param2})
		end
		if d.name == "ufowreck:alien_door_opened" then
			minetest.set_node({x=pos.x-1, y=pos.y, z=pos.z}, {name="ufowreck:alien_door_closed", param2=d.param2})
			minetest.set_node({x=pos.x-1,y=pos.y+1,z=pos.z}, {name="ufowreck:alien_door_closed_top", param2=d.param2})
		end
		if e.name == "ufowreck:alien_door_opened" then
			minetest.set_node({x=pos.x+1, y=pos.y, z=pos.z-1}, {name="ufowreck:alien_door_closed", param2=e.param2})
			minetest.set_node({x=pos.x+1, y=pos.y+1, z=pos.z-1}, {name="ufowreck:alien_door_closed_top", param2=e.param2})
		end
		if f.name == "ufowreck:alien_door_opened" then
			minetest.set_node({x=pos.x-1, y=pos.y, z=pos.z-1}, {name="ufowreck:alien_door_closed", param2=f.param2})
			minetest.set_node({x=pos.x-1, y=pos.y+1, z=pos.z-1}, {name="ufowreck:alien_door_closed_top", param2=f.param2})
		end
		if g.name == "ufowreck:alien_door_opened" then
		minetest.set_node({x=pos.x+1, y=pos.y, z=pos.z+1}, {name="ufowreck:alien_door_closed", param2=g.param2})
		minetest.set_node({x=pos.x+1, y=pos.y+1, z=pos.z+1}, {name="ufowreck:alien_door_closed_top", param2=g.param2})
			end
		if h.name == "ufowreck:alien_door_opened" then
			minetest.set_node({x=pos.x-1, y=pos.y, z=pos.z+1}, {name="ufowreck:alien_door_closed", param2=h.param2})
			minetest.set_node({x=pos.x-1, y=pos.y+1, z=pos.z+1}, {name="ufowreck:alien_door_closed_top", param2=h.param2})
		end
	end,
	can_dig = function(pos, player)
		return false
	end,
})

minetest.register_node("ufowreck:alien_door_opened_top", {
	tiles = {
		"scifi_nodes_door_black_edge.png",
		"scifi_nodes_door_black_edge.png",
		"scifi_nodes_door_black_edge.png",
		"scifi_nodes_door_black_edge.png",
		"scifi_nodes_door_black_rtopo.png",
		"scifi_nodes_door_black_topo.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {cracky = 1},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.0625, -0.25, 0.5, 0.0625},
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{0, 0, 0, 0, 0, 0},
		}
	},
	can_dig = function(pos, player)
		return false
	end,
})

minetest.register_node("ufowreck:bar_light", {
	description = "Alien Lightbars",
	tiles = {
		"scifi_nodes_orange2.png",
	},
	drawtype = "nodebox",
	paramtype = "light",
	use_texture_alpha = true,
	light_source = 9,
	node_box = {
		type = "fixed",
		fixed = {
			{0.125, -0.5, 0.125, 0.375, 0.5, 0.375}, -- NodeBox1
			{-0.375, -0.5, 0.125, -0.125, 0.5, 0.375}, -- NodeBox2
			{-0.375, -0.5, -0.375, -0.125, 0.5, -0.125}, -- NodeBox3
			{0.125, -0.5, -0.375, 0.375, 0.5, -0.125}, -- NodeBox4
		}
	},
	groups = {cracky=1},
	sounds = default.node_sound_glass_defaults()
})

minetest.register_node("ufowreck:alien_egg", {
	description = "Alien Egg",
	tiles = {
		"scifi_nodes_egg_top.png",
		"scifi_nodes_egg_top.png",
		"scifi_nodes_egg_side.png",
		"scifi_nodes_egg_side.png",
		"scifi_nodes_egg_side.png",
		"scifi_nodes_egg_side.png"
	},
	sunlight_propagates = false,
	drawtype = "nodebox",
	paramtype = "light",
	groups = {cracky=1, oddly_breakable_by_hand=1, dig_immediate=2, falling_node=1},
	light_source = 5,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.25, -0.5, -0.25, 0.25, -0.4375, 0.25}, -- NodeBox1
			{-0.375, -0.4375, -0.375, 0.375, -0.3125, 0.375}, -- NodeBox2
			{-0.4375, -0.3125, -0.375, 0.4375, 0.3125, 0.375}, -- NodeBox3
			{-0.375, 0.3125, -0.375, 0.375, 0.4375, 0.375}, -- NodeBox4
			{-0.3125, 0.4375, -0.3125, 0.3125, 0.5625, 0.3125}, -- NodeBox5
			{-0.25, 0.5625, -0.25, 0.25, 0.6875, 0.25}, -- NodeBox6
			{-0.1875, 0.6875, -0.1875, 0.1875, 0.75, 0.1875}, -- NodeBox7
			{-0.125, 0.75, -0.125, 0.125, 0.8125, 0.125}, -- NodeBox8
			{-0.375, -0.3125, -0.4375, 0.375, 0.3125, 0.4375}, -- NodeBox9
		},
	sounds = default.node_sound_wood_defaults()
	}
})

minetest.register_node("ufowreck:eye_tree", {
	description = "Alien Eye Tree",
	tiles = {{
		name="scifi_nodes_eyetree.png",
		animation={type="vertical_frames", aspect_w=48, aspect_h=48, length=10}, --length=0.50
	}},
	drawtype = "plantlike",
	groups = {snappy=1, choppy=1, oddly_breakable_by_hand=1, flora=1},
	paramtype = "light",
	visual_scale = 2.5,
	buildable_to = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.3, -0.5, -0.3, 0.3, 0.5, 0.3},
		}
	},
	drop = {
		items = {
			{items = {'ufowreck:eye 4'}},
		}
	},
	after_destruct = function(pos, oldnode)
		minetest.set_node(pos, {name = "ufowreck:eye_tree_empty"})
	end,
	is_ground_content = false,
})

minetest.register_node("ufowreck:eye_tree_empty", {
	description = "Alien Eye Tree",
	tiles = {"scifi_nodes_eyetree_2.png"},
	drawtype = "plantlike",
	inventory_image = {"scifi_nodes_eyetree_2.png"},
	groups = {snappy=1, choppy=1, oddly_breakable_by_hand=1, flora=1},
	paramtype = "light",
	visual_scale = 2.5,
	buildable_to = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.3, -0.5, -0.3, 0.3, 0.5, 0.3},
		}
	},
	drop = {
		items = {
			{items = {'ufowreck:eye'}},
		}
	},
	on_construct = function(pos)
		minetest.get_node_timer(pos):start(math.random(300, 1500))
	end,
	on_timer = function(pos)
		minetest.set_node(pos, {name = "ufowreck:eye_tree"})		
	end,
	is_ground_content = false,
})

minetest.register_node("ufowreck:eye", {
	description = "Alien Eye",
	tiles = {"eye.png"},
	drawtype = "plantlike",
	inventory_image = "eye.png",
	wield_image = "eye.png",
	groups = { food = 2, eatable = 4 },
	on_use = minetest.item_eat(4),
	buildable_to = true,
	walkable = false,
	on_construct = function(pos)
		minetest.get_node_timer(pos):start(math.random(300, 1500))
	end,
	on_timer = function(pos)
		minetest.set_node(pos, {name = "ufowreck:eye_tree"})		
	end,
})

minetest.register_node("ufowreck:predatory_plant", {
	description = "Alien Predatory Plant",
	tiles = {"scifi_nodes_flower3.png"},
	drawtype = "plantlike",
	inventory_image = {"scifi_nodes_flower3.png"},
	groups = {snappy=1, choppy=1, oddly_breakable_by_hand=1, dig_immediate=3, flora=1},
	paramtype = "light",
	visual_scale = 2.5,
	buildable_to = true,
	walkable = false,
	damage_per_second = 0.5,
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.3, -0.5, -0.3, 0.3, 0.5, 0.3},
		}
	},
	is_ground_content = false,
})

minetest.register_node("ufowreck:glow_plant", {
	description = "Alien Glow Plant",
	tiles = {"scifi_nodes_plant2.png"},
	drawtype = "plantlike",
	inventory_image = {"scifi_nodes_plant2.png"},
	groups = {snappy=1, choppy=1, oddly_breakable_by_hand=1, dig_immediate=3, flora=1},
	paramtype = "light",
	visual_scale = 1.5,
	buildable_to = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.3, -0.5, -0.3, 0.3, 0.5, 0.3},
		}
	},
	is_ground_content = false,
	light_source = 15,
})

minetest.register_node("ufowreck:floob_spawner", {
    description = "Alien Metal Block",
    tiles = {"scifi_nodes_lighttop.png"},
	drawtype = "nodebox",
	paramtype2 = "facedir",
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {cracky = 2},
	drop = {
		items = {
			{items = {'ufowreck:alien_metal'}},
		}
	},
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_node("ufowreck:pad", {
	description = "Alien Teleport",
	tiles = {
		"scifi_nodes_pad.png",
		"scifi_nodes_pad.png",
		"scifi_nodes_pad.png",
		"scifi_nodes_pad.png",
		"scifi_nodes_pad.png",
		"scifi_nodes_pad.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	groups = {cracky=1, oddly_breakable_by_hand=1},
	light_source = 5,
	on_construct = function(pos, node, placer)
		local meta = minetest.get_meta(pos)
		if position1 == nil then
			position1 = pos
			meta:set_int("type", 1)
		elseif position2 == nil then
			position2 = pos
			meta:set_int("type", 2)
--		else
--			minetest.chat_send_player(placer:get_player_name(), "There can only be two teleportation pads at a time!") 
-- placer:get_player_name() get nil all time
		end
	end,
	on_rightclick = function(pos, node, clicker)
		local meta = minetest.get_meta(pos)
		if meta:get_int("type") == 1 and position2 ~= nil and position1 ~= nil then
		minetest.add_particlespawner(
			25, --amount
			1.5, --time
			{x=pos.x-0.9, y=pos.y-0.3, z=pos.z-0.9}, --minpos
			{x=pos.x+0.9, y=pos.y-0.3, z=pos.z+0.9}, --maxpos
			{x=0, y=0, z=0}, --minvel
			{x=0, y=0, z=0}, --maxvel
			{x=-0,y=1,z=-0}, --minacc
			{x=0,y=2,z=0}, --maxacc
			0.5, --minexptime
			1, --maxexptime
			2, --minsize
			5, --maxsize
			false, --collisiondetection
			"scifi_nodes_tp_part.png" --texture
		)
		minetest.after(1, function()
		local ppos = clicker:getpos()
		if minetest.get_node({x=ppos.x, y=ppos.y, z=ppos.z}).name == "ufowreck:pad" then
			clicker:setpos(position2)
		end
		local objs = minetest.env:get_objects_inside_radius(pos, 3)
                for _, obj in pairs(objs) do
				if obj:get_luaentity() and not obj:is_player() then
				if obj:get_luaentity().name == "__builtin:item" then
				local item1 = obj:get_luaentity().itemstring
				local obj2 = minetest.env:add_entity(position2, "__builtin:item")
				obj2:get_luaentity():set_item(item1)
				obj:remove()
				end
				end
				end
		end)
		elseif meta:get_int("type") == 2 and position1 ~= nil and position2 ~= nil then
		minetest.add_particlespawner(
			25, --amount
			1.5, --time
			{x=pos.x-0.9, y=pos.y-0.3, z=pos.z-0.9}, --minpos
			{x=pos.x+0.9, y=pos.y-0.3, z=pos.z+0.9}, --maxpos
			{x=0, y=0, z=0}, --minvel
			{x=0, y=0, z=0}, --maxvel
			{x=-0,y=1,z=-0}, --minacc
			{x=0,y=2,z=0}, --maxacc
			0.5, --minexptime
			1, --maxexptime
			2, --minsize
			5, --maxsize
			false, --collisiondetection
			"scifi_nodes_tp_part.png" --texture
		)
		minetest.after(1, function()
		local ppos = clicker:getpos()
		if minetest.get_node({x=ppos.x, y=ppos.y, z=ppos.z}).name == "ufowreck:pad" then
			clicker:setpos(position1)
		end
		local objs = minetest.env:get_objects_inside_radius(pos, 3)
                for _, obj in pairs(objs) do
				if obj:get_luaentity() and not obj:is_player() then
				if obj:get_luaentity().name == "__builtin:item" then
				local item1 = obj:get_luaentity().itemstring
				local obj2 = minetest.env:add_entity(position1, "__builtin:item")
				obj2:get_luaentity():set_item(item1)
				obj:remove()
				end
				end
				end
		end)
		elseif position1 == nil and meta:get_int("type") ~= 2 then
		position1 = pos
		meta:set_int("type", 1)
		minetest.chat_send_player(clicker:get_player_name(), "Teleporter 1 connected at "..minetest.pos_to_string(pos))
		elseif position2 == nil and meta:get_int("type") ~= 1 then
		position2 = pos
		meta:set_int("type", 2)
		minetest.chat_send_player(clicker:get_player_name(), "Teleporter 2 connected at "..minetest.pos_to_string(pos))
		else
			minetest.chat_send_player(clicker:get_player_name(), "Teleporter error!")
		end
	end,
	on_destruct = function(pos, oldnode, placer)
		local meta = minetest.get_meta(pos)
		if meta:get_int("type") == 1 then
		position1 = nil
		meta:set_int("type", 0)
		elseif meta:get_int("type") == 2 then
		position2 = nil
		meta:set_int("type", 0)
		end
	end,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.9375, -0.5, -0.75, 0.875, -0.375, 0.75}, -- NodeBox1
			{-0.8125, -0.5, -0.875, 0.75, -0.375, 0.875}, -- NodeBox2
			{-0.875, -0.5, -0.8125, 0.8125, -0.375, 0.8125}, -- NodeBox3
			{-0.8125, -0.5, -0.75, 0.75, -0.3125, 0.75}, -- NodeBox4
		},
	sounds = default.node_sound_metal_defaults(),
	}
})

minetest.register_craft({
	output = "ufowreck:pad",
	recipe = {
	{"ufowreck:alien_metal", "ufowreck:alien_metal", "ufowreck:alien_metal"},
	{"ufowreck:alien_metal", "ufowreck:alien_control", "ufowreck:alien_metal"},
	{"ufowreck:alien_metal", "ufowreck:alien_metal", "ufowreck:alien_metal"}
  }
})

minetest.register_node("ufowreck:powered_stand", {
	description = "Powered Stand",
	tiles = {
		"scifi_nodes_pwrstnd_top.png",
		"scifi_nodes_pwrstnd_top.png",
		"scifi_nodes_pwrstnd_side.png",
		"scifi_nodes_pwrstnd_side.png",
		"scifi_nodes_pwrstnd_side.png",
		"scifi_nodes_pwrstnd_side.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, 0.25, -0.3125, 0.375, 0.4375, 0.3125}, -- NodeBox1
			{-0.3125, 0.25, -0.375, 0.3125, 0.4375, 0.375}, -- NodeBox2
			{-0.3125, 0.4375, -0.3125, 0.3125, 0.5, 0.3125}, -- NodeBox3
			{-0.5, -0.5, -0.125, 0.5, 0.125, 0.125}, -- NodeBox4
			{-0.125, -0.5, -0.5, 0.125, 0.125, 0.5}, -- NodeBox5
			{-0.4375, 0.125, -0.125, 0.4375, 0.25, 0.125}, -- NodeBox6
			{-0.125, 0.125, -0.4375, 0.125, 0.25, 0.4375}, -- NodeBox7
			{-0.3125, -0.5, -0.375, 0.3125, 0.0625, 0.3125}, -- NodeBox8
			{-0.25, 0.0625, -0.3125, 0.25, 0.125, 0.3125}, -- NodeBox9
		}
	},
	groups = {cracky=1, oddly_breakable_by_hand=1},
	on_rightclick = function(pos, node, clicker, item, _)
		local wield_item_stack = clicker:get_wielded_item()
		local wield_item = wield_item_stack:get_name()
		local taken = item:take_item()
		if taken and not taken:is_empty() then

			if wield_item_stack:get_count() == 1 then
				-- only 1 item in "hands" copy over entire stack with metadata
				wield_item = wield_item_stack
			end

			minetest.add_item({x=pos.x, y=pos.y+1, z=pos.z}, wield_item)
			return item
		end
	end,
})

minetest.register_node("ufowreck:ladder", {
	description = "Metal Ladder",
	tiles = {
		"scifi_nodes_ladder.png",
	},
	drawtype = "nodebox",
	paramtype = "light",
	selection_box = {
		type = "wallmounted",
		fixed = {-0.5, -0.5, -0.5, -0.45, 0.5, 0.5}
	},
	node_box = {
		type = "fixed",
		fixed = {
			{0.3125, -0.5, -0.4375, 0.4375, -0.375, -0.3125}, -- NodeBox12
			{-0.4375, -0.5, -0.4375, -0.3125, -0.375, -0.3125}, -- NodeBox13
			{-0.375, -0.375, -0.4375, 0.375, -0.3125, -0.3125}, -- NodeBox14
			{-0.375, -0.375, 0.3125, 0.375, -0.3125, 0.4375}, -- NodeBox18
			{-0.375, -0.375, 0.0625, 0.375, -0.3125, 0.1875}, -- NodeBox19
			{-0.375, -0.375, -0.1875, 0.375, -0.3125, -0.0625}, -- NodeBox20
			{-0.4375, -0.5, -0.1875, -0.3125, -0.375, -0.0625}, -- NodeBox21
			{-0.4375, -0.5, 0.0625, -0.3125, -0.375, 0.1875}, -- NodeBox22
			{-0.4375, -0.5, 0.3125, -0.3125, -0.375, 0.4375}, -- NodeBox23
			{0.3125, -0.5, 0.3125, 0.4375, -0.375, 0.4375}, -- NodeBox24
			{0.3125, -0.5, 0.0625, 0.4375, -0.375, 0.1875}, -- NodeBox25
			{0.3125, -0.5, -0.1875, 0.4375, -0.375, -0.0625}, -- NodeBox26
		},
	sounds = default.node_sound_metal_defaults()
	},
	paramtype2 = "wallmounted",
	walkable = false,
	climbable = true,
	groups = {cracky=1, oddly_breakable_by_hand=1},
})
