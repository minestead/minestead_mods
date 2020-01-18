minetest.register_craft({
       output = 'linetrack:watertrack_placer 49',
       recipe = {
               {'group:stick', '', 'group:stick'},
               {'group:stick','basic_materials:plastic_sheet', 'group:stick'},
               {'group:stick','','group:stick'},
       },
})


minetest.register_craft({
       output = 'linetrack:watertrack_slopeplacer',
       recipe = {
               {'linetrack:watertrack_placer', 'linetrack:watertrack_placer', 'linetrack:watertrack_placer'},
       },
})

minetest.register_craft({
       type="shapeless",
       output = 'linetrack:watertrack_stn_placer',
       recipe = {
               "linetrack:watertrack_placer",
               "technic:control_logic_unit"
       },
})

minetest.register_craft({
	output = 'linetrack:tcb_node',
	recipe = {
		{'technic:control_logic_unit'},
		{'mesecons:wire_00000000_off'},
		{'basic_materials:plastic_sheet'},
	},
})

minetest.register_craft({
	output = 'linetrack:boat',
	recipe = {
		{'dye:blue', 'advtrains:chimney', 'advtrains:chimney'},
		{'technic:stainless_steel_ingot', 'advtrains:boiler', 'technic:stainless_steel_ingot'},
		{'technic:stainless_steel_ingot', 'technic:stainless_steel_ingot', 'technic:stainless_steel_ingot'}
	},
})
