local modpath = minetest.get_modpath("technic_addons")

dofile(modpath.."/grinder_recipes.lua")

if minetest.get_modpath("technic_cnc") then
    dofile(modpath.."/cnc.lua")
end
