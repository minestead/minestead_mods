--advtrains by orwell96, see readme.txt and license.txt
--crafting.lua
--registers crafting recipes



if minetest.get_modpath("technic") then
	minetest.register_craft({
		output = 'advtrains:dtrack_placer 49',
		recipe = {
			{'technic:zinc_ingot', 'group:stick', 'technic:zinc_ingot'},
			{'technic:zinc_ingot', 'group:stick', 'technic:zinc_ingot'},
			{'technic:zinc_ingot', 'group:stick', 'technic:zinc_ingot'},
		},
	})

	minetest.register_craft({
		output = 'advtrains:dtrack_placer 49',
		recipe = {
			{'technic:lead_ingot', 'group:stick', 'technic:lead_ingot'},
			{'technic:lead_ingot', 'group:stick', 'technic:lead_ingot'},
			{'technic:lead_ingot', 'group:stick', 'technic:lead_ingot'},
		},
	})
end


--tracks
minetest.register_craft({
	output = 'advtrains:dtrack_placer 49',
	recipe = {
		{'default:steel_ingot', 'group:stick', 'default:steel_ingot'},
		{'default:steel_ingot', 'group:stick', 'default:steel_ingot'},
		{'default:steel_ingot', 'group:stick', 'default:steel_ingot'},
	},
})


minetest.register_craft({
	type = "shapeless",
	output = 'advtrains:dtrack_slopeplacer 2',
	recipe = {
		"advtrains:dtrack_placer",
		"advtrains:dtrack_placer",
		"default:gravel",
	},
})

minetest.register_craft({
	output = 'advtrains:dtrack_bumper_placer 2',
	recipe = {
		{'default:wood', 'dye:red'},
		{'default:steel_ingot', 'default:steel_ingot'},
		{'advtrains:dtrack_placer', 'advtrains:dtrack_placer'},
	},
})
minetest.register_craft({
	type="shapeless",
	output = 'advtrains:dtrack_detector_off_placer',
	recipe = {
		"advtrains:dtrack_placer",
		"mesecons:wire_00000000_off"
	},
})
--signals
minetest.register_craft({
	output = 'advtrains:retrosignal_off 2',
	recipe = {
		{'dye:red', 'default:steel_ingot', 'default:steel_ingot'},
		{'', '', 'default:steel_ingot'},
		{'', '', 'default:steel_ingot'},
	},
})
minetest.register_craft({
	output = 'advtrains:signal_off 2',
	recipe = {
		{'', 'dye:red', 'default:steel_ingot'},
		{'', 'dye:dark_green', 'default:steel_ingot'},
		{'', '', 'default:steel_ingot'},
	},
})

--trackworker
minetest.register_craft({
	output = 'advtrains:trackworker',
	recipe = {
		{'default:diamond'},
		{'screwdriver:screwdriver'},
		{'default:steel_ingot'},
	},
})

--boiler
minetest.register_craft({
	output = 'advtrains:boiler',
	recipe = {
		{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot'},
		{'doors:trapdoor_steel', '', 'default:steel_ingot'},
		{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot'},
	},
})

--drivers'cab
minetest.register_craft({
	output = 'advtrains:driver_cab',
	recipe = {
		{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot'},
		{'', '', 'default:glass'},
		{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot'},
	},
})

--drivers'cab
minetest.register_craft({
	output = 'advtrains:wheel',
	recipe = {
		{'', 'default:steel_ingot', ''},
		{'default:steel_ingot', 'group:stick', 'default:steel_ingot'},
		{'', 'default:steel_ingot', ''},
	},
})

--chimney
minetest.register_craft({
	output = 'advtrains:chimney',
	recipe = {
		{'', 'default:steel_ingot', ''},
		{'', 'default:steel_ingot', 'default:torch'},
		{'', 'default:steel_ingot', ''},
	},
})


minetest.register_craft({
	output = 'advtrains:across_off',
	recipe = {
		{'dye:red', 'default:steel_ingot', 'dye:red'},
		{'', 'default:steel_ingot', ''},
		{'', 'default:steel_ingot', ''},
	},
})



minetest.register_craft({
	output = 'advtrains:signal_wall_l_off',
	recipe = {
		{'default:steel_ingot', '', ''},
		{'default:torch', 'dye:red', 'dye:green'},
		{'default:steel_ingot', '', ''},
	},
})


minetest.register_craft({
	output = 'advtrains:signal_wall_r_off',
	recipe = {
		{'', '', 'default:steel_ingot'},
		{'dye:green', 'dye:red', 'default:torch'},
		{'', '', 'default:steel_ingot'},
	},
})


minetest.register_craft({
	output = 'advtrains:signal_wall_t_off',
	recipe = {
		{'default:steel_ingot', 'default:torch', 'default:steel_ingot'},
		{'', 'dye:red', ''},
		{'', 'dye:green', ''},
	},
})
--misc_nodes
--crafts for platforms see misc_nodes.lua
