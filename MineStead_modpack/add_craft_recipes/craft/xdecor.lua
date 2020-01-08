minetest.clear_craft({output = "xdecor:itemframe"})
minetest.register_craft( {
        output = "xdecor:itemframe",
        recipe = {
                {"group:wood", "default:paper", "group:wood"},
        },
})


minetest.clear_craft({output = "xdecor:pressure_stone_off"})
minetest.register_craft({
    output = "xdecor:pressure_stone_off",
    type = "shapeless",
    recipe = {"group:stone", "group:stick", "group:stone"}
})


minetest.clear_craft({output = "xdecor:pressure_wood_off"})
minetest.register_craft({
    output = "xdecor:pressure_wood_off",
    type = "shapeless",
    recipe = {"group:wood", "group:stick", "group:wood"}
})


minetest.clear_craft({output = "xdecor:bowl"})
minetest.register_craft({
    output = "xdecor:bowl 3",
    recipe = {
        {"group:wood", "group:wood", "group:wood"},
        {"", "group:wood", ""}
    }
})
