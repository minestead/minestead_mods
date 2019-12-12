local wire = 'digilines:wire_std_00000000'

-- digilines light sensor
minetest.register_craft({
        type = "shapeless",
        output = "digilines:lightsensor",
        recipe = {
                "mesecons_solarpanel:solar_panel_off", wire
        }
})

-- digilines RTC
minetest.register_craft({
        type = "shapeless",
        output = "digilines:rtc",
        recipe = {
                "basic_materials:ic", wire
        }
})
