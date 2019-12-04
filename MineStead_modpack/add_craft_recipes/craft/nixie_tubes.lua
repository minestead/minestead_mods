minetest.register_craft({
        output = "nixie_tubes:decatron_off 4",
        recipe = {
                { "", "default:glass", "" },
                { "default:glass", "default:mese_crystal_fragment", "default:glass" },
                { "default:glass", "default:mese_crystal_fragment", "default:glass" }
        },
})
