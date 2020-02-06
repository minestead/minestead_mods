local modpath = minetest.get_modpath("technic_addons")

dofile(modpath.."/grinder_recipes.lua")

if minetest.get_modpath("technic_chests") then
  dofile(modpath.."/lead_chest.lua")
  dofile(modpath.."/zinc_chest.lua")
end

if minetest.get_modpath("technic_cnc") then
    dofile(modpath.."/cnc.lua")
end


-- register leaf decay for rubber trees
default.register_leafdecay({
        trunks = {"moretrees:rubber_tree_trunk"},
        leaves = {"moretrees:rubber_tree_leaves"},
        radius = 3,
})

-- alternative recipe for batteries: lead, zinc, salt
minetest.register_craft({
        output = "technic:battery",
        recipe = {
                {"group:wood", "technic:lead_ingot", "group:wood"},
                {"technic:zinc_ingot", "farming:salt", "technic:zinc_ingot"},
                {"group:wood", "technic:lead_ingot", "group:wood"},
        },
})
