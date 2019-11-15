local buildPlatform = function(node, pos, itemstack)
	-- code for the building platforms
		posZ = {'1', '0', '-1', '-1', '0', '0', '1', '1' };
		posX = {'0', '-1',  '0', '0', '1', '1', '0', '0' };

		for nameCount = 1, 8 do
			pos.z = pos.z + posZ[nameCount];
			pos.x = pos.x + posX[nameCount];
			local current_node = minetest.get_node(pos);
			if current_node.name == "air" then
				minetest.set_node(pos, {name = node} )
				itemstack:take_item(1); --//and remove one if its the correct one
				break;
			end
		end
	-- end of function
end

local buildScaffolding = function(node, pos, itemstack, player)
	-- many thanks to addi for improveing (rewriteing) my crappy code --

	-- code for the building scaffolding
	height = 0;
	depth = 0;		-- !!Note!! depth is not needed at the moment


	--[[ debug stuff ]]


	-- set pos at bottom of scafolding tower.
	repeat
		pos.y = pos.y - 1; --every run get one node up
		depth = depth - 1
		local current_node = minetest.get_node(pos); --get the node of the new position
		

		until current_node.name ~= node -- will repeat untill it dose not find a scaffolding node


	-- check height of scaffolding tower --

	repeat
		pos.y = pos.y + 1; --every run get one node up
		height = height + 1
		local current_node = minetest.get_node(pos); --get the node of the new position


		if current_node.name == "air" then
			minetest.set_node(pos, {name = node } )
			itemstack:take_item(1); --//and remove one if its the correct one
			player:set_wielded_item(itemstack);--//update inventory of the player
		end
	until current_node.name ~= node or height >= 32 --we repeat until we find something else then "scaffolding:scaffolding"
			--maybe there should be also another limit, because its currently possible to build infinite towers

end

print("scaffolding: Loading 'functions.lua'")
dofile(minetest.get_modpath("scaffolding").."/functions.lua")

minetest.register_craftitem("scaffolding:scaffolding_wrench", {
	description = "Scaffolding Wrench",
	inventory_image = "scaffolding_wrench.png",
})

minetest.register_node("scaffolding:scaffolding", {
		description = "Wooden Scaffolding",
		drawtype = "nodebox",
		tiles = {"scaffolding_wooden_scaffolding_top.png", "scaffolding_wooden_scaffolding_top.png", "scaffolding_wooden_scaffolding.png",
		"scaffolding_wooden_scaffolding.png", "scaffolding_wooden_scaffolding.png", "scaffolding_wooden_scaffolding.png"},
		paramtype = "light",
		paramtype2 = "facedir",
		climbable = true,
		walkable = false,
		is_ground_content = true,
		groups = {snappy=2,cracky=3,oddly_breakable_by_hand=3},
		sounds = default.node_sound_wood_defaults(),
		on_punch = function(pos, node, puncher)
		local tool = puncher:get_wielded_item():get_name()
			if tool and tool == "scaffolding:scaffolding_wrench" then
				node.name = "scaffolding:reinforced_scaffolding"
				minetest.env:set_node(pos, node)
				puncher:get_inventory():add_item("main", ItemStack("scaffolding:scaffolding"))
			end
		end,
		on_rightclick = function(pos, node, player, itemstack, pointed_thing)
			-- if user hits scaffolding with platform Wooden scaffolding then --
			if itemstack:get_name() == "scaffolding:platform" then
				node = "scaffolding:platform";
				buildPlatform(node, pos, itemstack)
			end
			-- if user hits scaffolding with platform Iron scaffolding then --
			if itemstack:get_name() == "scaffolding:iron_platform" then
				node = "scaffolding:iron_platform";
				buildPlatform(node, pos, itemstack)
			end
			-- if user hits scaffolding with scaffolding then --
			if itemstack:get_name() == "scaffolding:scaffolding" then
				node = "scaffolding:scaffolding";
				local name = minetest.get_node(pos).name 									-- get loacation of node
				buildScaffolding(node, pos, itemstack, player)
			end
		end,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
			},
		},
		after_dig_node = function(pos, node, metadata, digger)
		default.dig_up(pos, node, digger)
	end,
	})

minetest.register_node("scaffolding:reinforced_scaffolding", {
		description = "Wooden Scaffolding",
		drawtype = "nodebox",
		tiles = {"scaffolding_wooden_scaffolding.png^scaffolding_reinforced.png", "scaffolding_wooden_scaffolding.png^scaffolding_reinforced.png",
		"scaffolding_wooden_scaffolding.png^scaffolding_reinforced.png"},
		drop = "scaffolding:scaffolding",
		paramtype = "light",
		light_source = 14,
		paramtype2 = "facedir",
		climbable = true,
		walkable = false,
		is_ground_content = true,
		groups = {snappy=2,cracky=3,oddly_breakable_by_hand=3},
		sounds = default.node_sound_wood_defaults(),
		on_punch = function(pos, node, puncher)
		local tool = puncher:get_wielded_item():get_name()
			if tool and tool == "scaffolding:scaffolding_wrench" then
				node.name = "scaffolding:scaffolding"
				minetest.env:set_node(pos, node)
				puncher:get_inventory():add_item("main", ItemStack("scaffolding:scaffolding"))
			end
		end,
		on_rightclick = function(pos, node, player, itemstack, pointed_thing)
			-- if user hits scaffolding with platform Wooden scaffolding then --
			if itemstack:get_name() == "scaffolding:platform" then
				node = "scaffolding:platform";
				buildPlatform(node, pos, itemstack)
			end
			-- if user hits scaffolding with platform Iron scaffolding then --
			if itemstack:get_name() == "scaffolding:iron_platform" then
				node = "scaffolding:iron_platform";
				buildPlatform(node, pos, itemstack)
			end
		end,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
			},
		},
	})

	minetest.register_node("scaffolding:platform", {
		description = "Wooden Platform",
		drawtype = "nodebox",
		tiles = {"scaffolding_wooden_scaffolding_top.png", "scaffolding_wooden_scaffolding_top.png", "scaffolding_wooden_scaffolding.png^scaffolding_platform.png"},
		paramtype = "light",
		paramtype2 = "facedir",
		climbable = false,
		walkable = true,
		is_ground_content = true,
		groups = {snappy=2,cracky=3,oddly_breakable_by_hand=3},
		sounds = default.node_sound_wood_defaults(),
		on_punch = function(pos, node, puncher)
		local tool = puncher:get_wielded_item():get_name()
			if tool and tool == "scaffolding:scaffolding_wrench" then
				node.name = "scaffolding:reinforced_platform"
				minetest.env:set_node(pos, node)
			end
		end,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.3, -0.5, 0.5, 0.1, 0.5},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.3, -0.5, 0.5, 0.1, 0.5},
			},
		},
		after_dig_node = function(pos, node, metadata, digger)
		default.dig_horx(pos, node, digger)
		default.dig_horx2(pos, node, digger)
		default.dig_horz(pos, node, digger)
		default.dig_horz2(pos, node, digger)
	end,
	})

	minetest.register_node("scaffolding:reinforced_platform", {
		description = "Wooden Platform",
		drawtype = "nodebox",
		light_source = 14,
		tiles = {"scaffolding_wooden_scaffolding.png^scaffolding_reinforced.png", "scaffolding_wooden_scaffolding.png^scaffolding_reinforced.png", "scaffolding_wooden_scaffolding.png^scaffolding_platform.png"},
		drop = "scaffolding:platform",
		paramtype = "light",
		paramtype2 = "facedir",
		climbable = false,
		walkable = true,
		is_ground_content = true,
		groups = {snappy=2,cracky=3,oddly_breakable_by_hand=3},
		sounds = default.node_sound_wood_defaults(),
		on_punch = function(pos, node, puncher)
		local tool = puncher:get_wielded_item():get_name()
			if tool and tool == "scaffolding:scaffolding_wrench" then
				node.name = "scaffolding:platform"
				minetest.env:set_node(pos, node)
			end
		end,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.3, -0.5, 0.5, 0.1, 0.5},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.3, -0.5, 0.5, 0.1, 0.5},
			},
		},
	})

	minetest.register_node("scaffolding:iron_scaffolding", {
		description = "Iron Scaffolding",
		drawtype = "nodebox",
		tiles = {"scaffolding_iron_scaffolding_top.png", "scaffolding_iron_scaffolding_top.png", "scaffolding_iron_scaffolding.png",
		"scaffolding_iron_scaffolding.png", "scaffolding_iron_scaffolding.png", "scaffolding_iron_scaffolding.png"},
		paramtype = "light",
		paramtype2 = "facedir",
		climbable = true,
		walkable = false,
		is_ground_content = true,
		groups = {snappy=2,cracky=3},
		sounds = default.node_sound_wood_defaults(),
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
			},
		},
		on_punch = function(pos, node, puncher)
		local tool = puncher:get_wielded_item():get_name()
			if tool and tool == "scaffolding:scaffolding_wrench" then
				node.name = "scaffolding:reinforced_iron_scaffolding"
				minetest.env:set_node(pos, node)
				puncher:get_inventory():add_item("main", ItemStack("scaffolding:scaffolding"))
			end
		end,
		on_rightclick = function(pos, node, player, itemstack, pointed_thing)
			-- if user hits scaffolding with platform Iron scaffolding then --
			if itemstack:get_name() == "scaffolding:iron_platform" then
				node = "scaffolding:iron_platform";
				buildPlatform(node, pos, itemstack)
			end
			-- if user hits scaffolding with platform Wooden scaffolding then --
			if itemstack:get_name() == "scaffolding:platform" then
				node = "scaffolding:platform";
				buildPlatform(node, pos, itemstack)
			end
			-- if user hits scaffolding with scaffolding then --
			if itemstack:get_name() == "scaffolding:iron_scaffolding" then
				node = "scaffolding:iron_scaffolding";
				local name = minetest.get_node(pos).name 									-- get loacation of node
				buildScaffolding(node, pos, itemstack, player)
			end

		end,
	after_dig_node = function(pos, node, metadata, digger)
		default.dig_up(pos, node, digger)
	end,
	})

	minetest.register_node("scaffolding:reinforced_iron_scaffolding", {
		description = "Iron Scaffolding",
		drawtype = "nodebox",
		tiles = {"scaffolding_iron_scaffolding.png^scaffolding_reinforced.png", "scaffolding_iron_scaffolding.png^scaffolding_reinforced.png",
		"scaffolding_iron_scaffolding.png^scaffolding_reinforced.png"},
		drop = "scaffolding:iron_scaffolding",
		paramtype = "light",
		paramtype2 = "facedir",
		climbable = true,
		walkable = false,
		light_source = 14,
		is_ground_content = true,
		groups = {snappy=2,cracky=3},
		sounds = default.node_sound_wood_defaults(),
		on_punch = function(pos, node, puncher)
		local tool = puncher:get_wielded_item():get_name()
			if tool and tool == "scaffolding:scaffolding_wrench" then
				node.name = "scaffolding:iron_scaffolding"
				minetest.env:set_node(pos, node)
				puncher:get_inventory():add_item("main", ItemStack("scaffolding:scaffolding"))
			end
		end,
		on_rightclick = function(pos, node, player, itemstack, pointed_thing)
			-- if user hits scaffolding with platform Iron scaffolding then --
			if itemstack:get_name() == "scaffolding:iron_platform" then
				node = "scaffolding:iron_platform";
				buildPlatform(node, pos, itemstack)
			end
			-- if user hits scaffolding with platform Wooden scaffolding then --
			if itemstack:get_name() == "scaffolding:platform" then
				node = "scaffolding:platform";
				buildPlatform(node, pos, itemstack)
			end
		end,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
			},
		},
	})

	minetest.register_node("scaffolding:iron_platform", {
		description = "Iron Platform",
		drawtype = "nodebox",
		tiles = {"scaffolding_iron_scaffolding_top.png", "scaffolding_iron_scaffolding_top.png", "scaffolding_iron_scaffolding.png^scaffolding_platform.png"},
		paramtype = "light",
		paramtype2 = "facedir",
		climbable = false,
		walkable = true,
		is_ground_content = true,
		groups = {snappy=2,cracky=3},
		sounds = default.node_sound_wood_defaults(),
		on_punch = function(pos, node, puncher)
		local tool = puncher:get_wielded_item():get_name()
			if tool and tool == "scaffolding:scaffolding_wrench" then
				node.name = "scaffolding:reinforced_iron_platform"
				minetest.env:set_node(pos, node)
			end
		end,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.3, -0.5, 0.5, 0.1, 0.5},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.3, -0.5, 0.5, 0.1, 0.5},
			},
		},
		after_dig_node = function(pos, node, metadata, digger)
			default.dig_horx(pos, node, digger)
			default.dig_horx2(pos, node, digger)
			default.dig_horz(pos, node, digger)
			default.dig_horz2(pos, node, digger)
		end,
	})

	minetest.register_node("scaffolding:reinforced_iron_platform", {
		description = "Iron Platform",
		drawtype = "nodebox",
		tiles = {"scaffolding_iron_scaffolding.png^scaffolding_reinforced.png", "scaffolding_iron_scaffolding.png^scaffolding_reinforced.png", "scaffolding_iron_scaffolding.png^scaffolding_platform.png"},
		drop = "scaffolding:iron_platform",
		paramtype = "light",
		paramtype2 = "facedir",
		climbable = false,
		walkable = true,
		light_source = 14,
		is_ground_content = true,
		groups = {snappy=2,cracky=3},
		sounds = default.node_sound_wood_defaults(),
		on_punch = function(pos, node, puncher)
		local tool = puncher:get_wielded_item():get_name()
			if tool and tool == "scaffolding:scaffolding_wrench" then
				node.name = "scaffolding:iron_platform"
				minetest.env:set_node(pos, node)
			end
		end,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.3, -0.5, 0.5, 0.1, 0.5},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.3, -0.5, 0.5, 0.1, 0.5},
			},
		},
	})

----------------------
-- wood scaffolding --
----------------------

minetest.register_craft({
	output = 'scaffolding:scaffolding 12',
	recipe = {
		{'group:wood', 'group:wood', 'group:wood'},
		{'default:stick', '', 'default:stick'},
		{'group:wood', 'group:wood', 'group:wood'},
	}
})

minetest.register_craft({
	output = 'scaffolding:scaffolding 4',
	recipe = {
		{'group:wood'},
		{'default:stick'},
		{'group:wood'},
	}
})

-- back to scaffolding --

minetest.register_craft({
	output = 'scaffolding:scaffolding',
	recipe = {
		{'scaffolding:platform'},
		{'scaffolding:platform'},
	}
})

-- wood platforms --

minetest.register_craft({
	output = 'scaffolding:platform 2',
	recipe = {
		{'scaffolding:scaffolding'},
	}
})

minetest.register_craft({
	output = 'scaffolding:platform 6',
	recipe = {
		{'scaffolding:scaffolding', 'scaffolding:scaffolding', 'scaffolding:scaffolding'},
	}
})

-- get wood back --

minetest.register_craft({
	output = 'default:wood',
	recipe = {
		{'scaffolding:scaffolding', 'scaffolding:scaffolding'},
	}
})

----------------------
-- iron scaffolding --
----------------------

minetest.register_craft({
	output = 'scaffolding:iron_scaffolding 12',
	recipe = {
		{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot'},
		{'default:stick', '', 'default:stick'},
		{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot'},
	}
})

minetest.register_craft({
	output = 'scaffolding:iron_scaffolding 4',
	recipe = {
		{'default:steel_ingot'},
		{'default:stick'},
		{'default:steel_ingot'},
	}
})
-- back to scaffolding --

minetest.register_craft({
	output = 'scaffolding:iron_scaffolding',
	recipe = {
		{'scaffolding:iron_platform'},
		{'scaffolding:iron_platform'},
	}
})

-- iron platforms --

minetest.register_craft({
	output = 'scaffolding:iron_platform 2',
	recipe = {
		{'scaffolding:iron_scaffolding'},
	}
})

minetest.register_craft({
	output = 'scaffolding:iron_platform 6',
	recipe = {
		{'scaffolding:iron_scaffolding', 'scaffolding:iron_scaffolding', 'scaffolding:iron_scaffolding'},
	}
})

-- get iron back --

minetest.register_craft({
	output = 'default:steel_ingot',
	recipe = {
		{'scaffolding:iron_scaffolding', 'scaffolding:iron_scaffolding'},
	}
})



------------
-- wrench --
------------

minetest.register_craft({
	output = 'scaffolding:scaffolding_wrench',
	recipe = {
		{'', 'default:steel_ingot', ''},
		{'', 'default:steel_ingot', 'default:steel_ingot'},
		{'default:steel_ingot', '', ''},
	}
})
