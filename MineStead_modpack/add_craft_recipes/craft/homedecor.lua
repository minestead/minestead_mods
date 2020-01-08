minetest.clear_craft({output = "homedecor:tatami_mat"})

minetest.register_craft( {
        output = "homedecor:tatami_mat",
        recipe = {
             {"farming:wheat", "", ""},
             {"", "farming:wheat", ""},
             {"", "", "farming:wheat"}
        },
})
