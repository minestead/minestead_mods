

minetest.register_node("jumpdrive:backbone", {
	description = "Jumpdrive Backbone",

	tiles = {"jumpdrive_backbone.png"},
	groups = {cracky=3,oddly_breakable_by_hand=3},
	sounds = default.node_sound_glass_defaults(),
	light_source = 13
})

minetest.register_craft({
	output = 'jumpdrive:backbone',
	recipe = {
		{'technic:composite_plate', 'default:mese_block', 'technic:composite_plate'},
		{'technic:stainless_steel_block', 'default:obsidian', 'technic:stainless_steel_block'},
		{'technic:composite_plate', 'default:mese_block', 'technic:composite_plate'}
	}
})