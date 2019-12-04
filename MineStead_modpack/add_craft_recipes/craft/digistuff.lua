local wire = 'digilines:wire_std_00000000'

if minetest.get_modpath("mesecons_noteblock") then
    -- digistuff noteblock
    minetest.register_craft({
        type = "shapeless",
        output = "digistuff:noteblock",
        recipe = {
                "mesecons_noteblock:noteblock", wire
        }
    })
end

if minetest.get_modpath("homedecor_electronics") then
    -- digistuff piezo
    minetest.register_craft({
        type = "shapeless",
        output = "digistuff:piezo",
        recipe = {
                "homedecor:speaker_driver", wire
        }
    })
end

if minetest.get_modpath("mesecons_mvps") then
    -- digistuff piston
    minetest.register_craft({
        type = "shapeless",
        output = "digistuff:piston",
        recipe = {
                "mesecons_pistons:piston_normal_off", wire
        }
    })
end

minetest.register_craft({
        type = "shapeless",
        output = "digistuff:wall_knob",
        recipe = {
                "digistuff:button", wire
        }
})
