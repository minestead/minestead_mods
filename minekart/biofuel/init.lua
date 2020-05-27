----------
--biofuel
----------

minetest.register_craftitem("biofuel:biofuel",{
        description = "Bio Fuel Canister",
        inventory_image = "biofuel_inv.png",
})

minetest.register_craft({
	output = "biofuel:biofuel",
	recipe = {
		{"tubelib_addons1:biofuel", "tubelib_addons1:biofuel", "tubelib_addons1:biofuel"},
		{"tubelib_addons1:biofuel", "tubelib_addons1:biofuel", "tubelib_addons1:biofuel"},
		{"tubelib_addons1:biofuel", "tubelib_addons1:biofuel", "tubelib_addons1:biofuel"}
	}
})

