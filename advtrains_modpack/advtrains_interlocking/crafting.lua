minetest.register_craft({
	type="shapeless",
	output = 'advtrains_interlocking:dtrack_npr_placer',
	recipe = {
		"advtrains:dtrack_placer",
		"technic:control_logic_unit",
		"dye:black"
	},
})

minetest.register_craft({
	output = 'advtrains_interlocking:tcb_node',
	recipe = {
		{'technic:control_logic_unit', '', ''},
		{'mesecons:wire_00000000_off', '', ''},
		{'default:steel_ingot', '', ''},
	},
})


--trackworker
minetest.register_craft({
	output = 'advtrains_interlocking:tool',
	recipe = {
		{'default:diamond'},
		{'screwdriver:screwdriver'},
		{'default:copper_ingot'},
	},
})

--signals

minetest.register_craft({
	output = 'advtrains_interlocking:ds_danger',
	recipe = {
		{'group:wood', 'dye:red', 'group:wood'},
		{'group:wood', 'technic:control_logic_unit', 'group:wood'},
		{'group:wood', 'mesecons:wire_00000000_off', 'group:wood'},
	},
})

minetest.register_craft({
	output = 'advtrains_interlocking:ds_free',
	recipe = {
		{'group:wood', 'dye:green', 'group:wood'},
		{'group:wood', 'technic:control_logic_unit', 'group:wood'},
		{'group:wood', 'mesecons:wire_00000000_off', 'group:wood'},
	},
})

minetest.register_craft({
	output = 'advtrains_interlocking:ds_slow',
	recipe = {
		{'group:wood', 'dye:yellow', 'group:wood'},
		{'group:wood', 'technic:control_logic_unit', 'group:wood'},
		{'group:wood', 'mesecons:wire_00000000_off', 'group:wood'},
	},
})
