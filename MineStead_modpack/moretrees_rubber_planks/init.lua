minetest.register_node(":moretrees:rubber_tree_planks", {
    description = "Rubber Tree Planks",
    tiles = {"moretrees_rubber_tree_wood.png"},
    is_ground_content = false,
    groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3,wood=1},
    sounds = default.node_sound_wood_defaults(),
})

minetest.register_craft({
        type = "shapeless",
        output = "moretrees:rubber_tree_planks 4",
        recipe = {
                "moretrees:rubber_tree_trunk"
        }
})

