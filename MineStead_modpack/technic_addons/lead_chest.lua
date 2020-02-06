local ingot = "technic:lead_ingot"

minetest.register_craft({
	output = 'technic:lead_chest 1',
	recipe = {
		{ingot,ingot,ingot},
		{ingot,'default:chest',ingot},
		{ingot,ingot,ingot},
	}
})

minetest.register_craft({
	output = 'technic:lead_locked_chest 1',
	recipe = {
		{ingot,ingot,ingot},
		{ingot,'default:chest_locked',ingot},
		{ingot,ingot,ingot},
	}
})

minetest.register_craft({
	output = 'technic:lead_locked_chest 1',
	recipe = {
		{'basic_materials:padlock'},
		{'technic:lead_chest'},
	}
})

technic.chests:register("Lead", {
	width = 9,
	height = 5,
	sort = true,
	autosort = false,
	infotext = false,
	color = false,
	locked = false,
})

technic.chests:register("Lead", {
	width = 9,
	height = 5,
	sort = true,
	autosort = false,
	infotext = false,
	color = false,
	locked = true,
})

minetest.register_craft({
        output = 'technic:copper_chest 1',
        recipe = {
                {'default:copper_ingot','default:copper_ingot','default:copper_ingot'},
                {'default:copper_ingot','technic:lead_chest','default:copper_ingot'},
                {'default:copper_ingot','default:copper_ingot','default:copper_ingot'},
        }
})

minetest.register_craft({
        output = 'technic:copper_locked_chest 1',
        recipe = {
                {'default:copper_ingot','default:copper_ingot','default:copper_ingot'},
                {'default:copper_ingot','technic:lead_locked_chest','default:copper_ingot'},
                {'default:copper_ingot','default:copper_ingot','default:copper_ingot'},
        }
})
