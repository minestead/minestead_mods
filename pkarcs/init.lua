-- [Mod] Simple Arcs [pkarcs]
-- by PEAK
-- 06-05-2017


--[[

	This mod adds arc-nodes to Minetest as well as arcs for inner and outer
	corners, based on the default stone and wood materials.
	
	To make arcs from nodes of your mod, put "pkarcs?" into your depends.txt,
	and call this function in your init.lua:

if minetest.get_modpath("pkarcs") then
	pkarcs.register_node("your_mod:your_nodename")
end

	works with Minetest 0.4.16

--]]


pkarcs = {}

-- convert integer coordinates to nodebox coordinates

function nb(n)
	return n/16-1/2
end

-- define nodes

function pkarcs.register_all(nodename, desc, tile, sound, group, craftmaterial)
	local tile_collection
	if type(tile) == "string" then
		tile_collection[1] = tile
	else
		tile_collection = table.copy(tile)
	end

	minetest.register_node(":pkarcs:"..nodename.."_arc", {
		description = desc.." Arc",
		paramtype = "light",
		paramtype2 = "facedir",
		tiles = tile_collection,
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{ nb(0),  nb(0),  nb(0),     nb(1),  nb(16), nb(16) },
				{ nb(1),  nb(4),  nb(0),     nb(2),  nb(16), nb(16) },
				{ nb(2),  nb(7),  nb(0),     nb(3),  nb(16), nb(16) },
				{ nb(3),  nb(8),  nb(0),     nb(4),  nb(16), nb(16) },
				{ nb(4),  nb(10), nb(0),     nb(5),  nb(16), nb(16) },
				{ nb(5),  nb(11), nb(0),     nb(6),  nb(16), nb(16) },
				{ nb(6),  nb(12), nb(0),     nb(8),  nb(16), nb(16) },
				{ nb(8),  nb(13), nb(0),     nb(9),  nb(16), nb(16) },
				{ nb(9),  nb(14), nb(0),     nb(12), nb(16), nb(16) },
				{ nb(12), nb(15), nb(0),     nb(16), nb(16), nb(16) },
			}
		},
		groups = group,
		sounds = sound,

		on_place = function(itemstack, placer, pointed_thing)
			if pointed_thing.type ~= "node" then
				return itemstack
			end

			local p1 = pointed_thing.under
			local p0 = pointed_thing.above
			local param2 = 0

			local placer_pos = placer:getpos()
			if placer_pos then
				local dir = {
					x = p1.x - placer_pos.x,
					y = p1.y - placer_pos.y,
					z = p1.z - placer_pos.z
				}
				param2 = minetest.dir_to_facedir(dir)
			end

			if p0.y-1 == p1.y then
				param2 = param2 + 20
				if param2 == 21 then
					param2 = 23
				elseif param2 == 23 then
					param2 = 21
				end
			end

			local NROT = 4 -- Number of possible "rotations" (4 Up down left right)
			local rot = param2 % NROT
			local wall = math.floor(param2/NROT)
			if rot >=3 then
				rot = 0
			else 
				rot = rot +1
			end
			param2 = wall*NROT+rot

			return minetest.item_place(itemstack, placer, pointed_thing, param2)
		end,
	})

	minetest.register_craft({
		output = "pkarcs:"..nodename.."_arc".." 5",
		recipe = {
			{ craftmaterial, craftmaterial, craftmaterial },
			{ craftmaterial, "",            ""            },
			{ craftmaterial, "",            ""            }
		}
	})

	minetest.register_node(":pkarcs:"..nodename.."_outer_arc", {
		description = desc.." Outer Arc",
		paramtype = "light",
		paramtype2 = "facedir",
		tiles = tile_collection,
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{ nb(0),  nb(0),  nb(16),     nb(1),  nb(16), nb(16-1)  },
				{ nb(0),  nb(4),  nb(16),     nb(2),  nb(16), nb(16-2)  },
				{ nb(0),  nb(7),  nb(16),     nb(3),  nb(16), nb(16-3)  },
				{ nb(0),  nb(8),  nb(16),     nb(4),  nb(16), nb(16-4)  },
				{ nb(0),  nb(10), nb(16),     nb(5),  nb(16), nb(16-5)  },
				{ nb(0),  nb(11), nb(16),     nb(6),  nb(16), nb(16-6)  },
				{ nb(0),  nb(12), nb(16),     nb(8),  nb(16), nb(16-8)  },
				{ nb(0),  nb(13), nb(16),     nb(9),  nb(16), nb(16-9)  },
				{ nb(0),  nb(14), nb(16),     nb(12), nb(16), nb(16-12) },
				{ nb(0),  nb(15), nb(16),     nb(16), nb(16), nb(16-16) },
			}
		},
		groups = group,
		sounds = sound,

		on_place = function(itemstack, placer, pointed_thing)
			if pointed_thing.type ~= "node" then
				return itemstack
			end

			local p1 = pointed_thing.under
			local p0 = pointed_thing.above
			local param2 = 0

			local placer_pos = placer:getpos()
			if placer_pos then
				local dir = {
					x = p1.x - placer_pos.x,
					y = p1.y - placer_pos.y,
					z = p1.z - placer_pos.z
				}
				param2 = minetest.dir_to_facedir(dir)
			end

			if p0.y-1 == p1.y then
				param2 = param2 + 20
				if param2 == 21 then
					param2 = 23
				elseif param2 == 23 then
					param2 = 21
				end
			end

			local NROT = 4 -- Number of possible "rotations" (4 Up down left right)
			local rot = param2 % NROT
			local wall = math.floor(param2/NROT)
			if rot >=3 then
				rot = 0
			else 
				rot = rot +1
			end
			param2 = wall*NROT+rot

			return minetest.item_place(itemstack, placer, pointed_thing, param2)
		end,

	})

	minetest.register_craft({
		output = "pkarcs:"..nodename.."_outer_arc".." 5",
		recipe = {
			{ "default:torch", craftmaterial, craftmaterial },
			{ craftmaterial,   "",            ""            },
			{ craftmaterial,   "",            ""            }
		}
	})

	minetest.register_node(":pkarcs:"..nodename.."_inner_arc", {
		description = desc.." Inner Arc",
		paramtype = "light",
		paramtype2 = "facedir",
		tiles = tile_collection,
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{ nb(0),  nb(0),  nb(16),     nb(1),  nb(16), nb(0)    },
				{ nb(0),  nb(0),  nb(16),     nb(16), nb(16), nb(16-1) },

				{ nb(0),  nb(4),  nb(16),     nb(2),  nb(16), nb(0)    },
				{ nb(0),  nb(4),  nb(16),     nb(16), nb(16), nb(16-2) },

				{ nb(0),  nb(7),  nb(16),     nb(3),  nb(16), nb(0)    },
				{ nb(0),  nb(7),  nb(16),     nb(16), nb(16), nb(16-3) },

				{ nb(0),  nb(8),  nb(16),     nb(4),  nb(16), nb(0)    },
				{ nb(0),  nb(8),  nb(16),     nb(16), nb(16), nb(16-4) },

				{ nb(0),  nb(10), nb(16),     nb(5),  nb(16), nb(0)    },
				{ nb(0),  nb(10), nb(16),     nb(16), nb(16), nb(16-5) },

				{ nb(0),  nb(11), nb(16),     nb(6),  nb(16), nb(0)    },
				{ nb(0),  nb(11), nb(16),     nb(16), nb(16), nb(16-6) },

				{ nb(0),  nb(12), nb(16),     nb(8),  nb(16), nb(0)    },
				{ nb(0),  nb(12), nb(16),     nb(16), nb(16), nb(16-8) },

				{ nb(0),  nb(13), nb(16),     nb(9),  nb(16), nb(0)    },
				{ nb(0),  nb(13), nb(16),     nb(16), nb(16), nb(16-9) },

				{ nb(0),  nb(14), nb(16),     nb(12), nb(16), nb(0)     },
				{ nb(0),  nb(14), nb(16),     nb(16), nb(16), nb(16-12) },

				{ nb(0),  nb(15), nb(16),     nb(16), nb(16), nb(16-16) },
			}
		},
		groups = group,
		sounds = sound,

		on_place = function(itemstack, placer, pointed_thing)
			if pointed_thing.type ~= "node" then
				return itemstack
			end

			local p1 = pointed_thing.under
			local p0 = pointed_thing.above
			local param2 = 0

			local placer_pos = placer:getpos()
			if placer_pos then
				local dir = {
					x = p1.x - placer_pos.x,
					y = p1.y - placer_pos.y,
					z = p1.z - placer_pos.z
				}
				param2 = minetest.dir_to_facedir(dir)
			end

			if p0.y-1 == p1.y then
				param2 = param2 + 20
				if param2 == 21 then
					param2 = 23
				elseif param2 == 23 then
					param2 = 21
				end
			end

			local NROT = 4 -- Number of possible "rotations" (4 Up down left right)
			local rot = param2 % NROT
			local wall = math.floor(param2/NROT)
			if rot >=3 then
				rot = 0
			else 
				rot = rot +1
			end
			param2 = wall*NROT+rot

			return minetest.item_place(itemstack, placer, pointed_thing, param2)
		end,

	})

	minetest.register_craft({
		output = "pkarcs:"..nodename.."_inner_arc".." 5",
		recipe = {
			{ "",            craftmaterial,   craftmaterial },
			{ craftmaterial, "default:torch", ""            },
			{ craftmaterial, "",              ""            }
		}
	})

end

-- register nodes

function pkarcs.register_node(name)
	local node_def = minetest.registered_nodes[name]
	if not node_def then
		minetest.log("warning", "[pkarcs] Skipping unknown node: ".. name)
		return
	end
	local node_name = name:split(':')[2]

	if not node_def.tiles then
		node_def.tiles = table.copy(node_def.tile_images)
		node_def.tile_images = nil
	end

	pkarcs.register_all(node_name, node_def.description, node_def.tiles, node_def.sound, node_def.groups, name)
end


-- make arcs for all default stone and wood nodes

pkarcs.register_node("default:cobble")
pkarcs.register_node("default:mossycobble")
pkarcs.register_node("default:desert_cobble")

pkarcs.register_node("default:stone")
pkarcs.register_node("default:stonebrick")
pkarcs.register_node("default:stone_block")

pkarcs.register_node("default:desert_stone")
pkarcs.register_node("default:desert_stonebrick")
pkarcs.register_node("default:desert_stone_block")

pkarcs.register_node("default:desert_sandstone")
pkarcs.register_node("default:desert_sandstone_block")
pkarcs.register_node("default:desert_sandstone_brick")

pkarcs.register_node("default:silver_sandstone")
pkarcs.register_node("default:silver_sandstone_block")
pkarcs.register_node("default:silver_sandstone_brick")

pkarcs.register_node("default:sandstone")
pkarcs.register_node("default:sandstonebrick")
pkarcs.register_node("default:sandstone_block")

pkarcs.register_node("default:brick")

pkarcs.register_node("default:obsidian")
pkarcs.register_node("default:obsidianbrick")
pkarcs.register_node("default:obsidian_block")

pkarcs.register_node("default:wood")
pkarcs.register_node("default:junglewood")
pkarcs.register_node("default:pine_wood")
pkarcs.register_node("default:acacia_wood")
pkarcs.register_node("default:aspen_wood")

