minetest.register_craft({
    output = "farming:muffin_blueberry 2",
    recipe = {
	{"default:blueberries", "group:food_bread", "default:blueberries"},
    }
})

minetest.register_craft({
    output = "farming:blueberry_pie",
    type = "shapeless",
    recipe = {
	"group:food_flour", "group:food_sugar",
	"default:blueberries", "group:food_baking_tray"
    },
    replacements = {{"group:food_baking_tray", "farming:baking_tray"}}
})
