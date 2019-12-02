-- HV accelerator

minetest.register_craft({
	output = 'technic:hv_transmutator',
	recipe = {
		{'technic:stainless_steel_block', 'technic:power_monitor',   'technic:stainless_steel_block'},
		{'technic:hv_transformer', 'technic:mv_centrifuge', 'technic:hv_transformer'},
		{'technic:lead_block', 'technic:hv_cable', 'technic:lead_block'},
	}
})

technic.register_transmutator({tier = "HV", demand = {60000, 50000, 40000}, speed = 0.5, upgrade = 1, tube = 1})
