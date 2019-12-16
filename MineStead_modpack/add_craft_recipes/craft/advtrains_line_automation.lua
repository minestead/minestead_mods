minetest.register_craft({
       type="shapeless",
       output = 'advtrains_line_automation:dtrack_stop_placer',
       recipe = {
               "advtrains:dtrack_placer",
               "technic:control_logic_unit",
               "dye:black",
               "dye:yellow",
       },
})

