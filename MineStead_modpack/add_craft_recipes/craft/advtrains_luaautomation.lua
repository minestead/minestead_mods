local plastic = "basic_materials:plastic_sheet"
local wire = "digilines:wire_std_00000000"

local glass = "default:glass"

minetest.register_craft({
        type="shapeless",
        output = 'advtrains_luaautomation:dtrack_placer',
        recipe = {
                "advtrains:dtrack_placer",
                "technic:control_logic_unit",
                wire,
        },
})


minetest.register_craft({
        output = 'advtrains_luaautomation:oppanel',
        recipe = {
                {plastic, plastic, plastic},
                {glass, "mesecons_luacontroller:luacontroller0000", glass},
                {wire, wire, wire},
        },
})

minetest.register_craft({
        output = 'advtrains_luaautomation:pcnaming',
        recipe = {
                {"default:diamond"},
                {"screwdriver:screwdriver"},
                {"default:gold_ingot"},
        },
})

