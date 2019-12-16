minetest.register_craft({
       type="shapeless",
       output = 'advtrains:dtrack_atc_placer',
       recipe = {
               "advtrains:dtrack_placer",
               "technic:control_logic_unit",
               "dye:blue"
       },
})

minetest.register_craft({
       type="shapeless",
       output = 'advtrains:dtrack_load_placer',
       recipe = {
               "advtrains:dtrack_placer",
               "technic:control_logic_unit",
               "dye:red"
       },
})

minetest.register_craft({
       type="shapeless",
       output = 'advtrains:dtrack_unload_placer',
       recipe = {
               "advtrains:dtrack_placer",
               "technic:control_logic_unit",
               "dye:green"
       },
})
