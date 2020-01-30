local modpath = minetest.get_modpath("technic_addons")

dofile(modpath.."/grinder_recipes.lua")

if minetest.get_modpath("technic_cnc") then
    dofile(modpath.."/cnc.lua")
end


-- register leaf decay for rubber trees
default.register_leafdecay({
        trunks = {"moretrees:rubber_tree_trunk"},
        leaves = {"moretrees:rubber_tree_leaves"},
        radius = 3,
})
