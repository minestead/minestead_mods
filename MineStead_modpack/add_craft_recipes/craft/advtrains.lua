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
