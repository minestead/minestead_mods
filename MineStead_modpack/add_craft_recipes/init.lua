-- MineSTEAD craft recipes
local MP = minetest.get_modpath("add_craft_recipes")

if minetest.get_modpath("digilines") then
  dofile(MP.."/craft/digilines.lua")
end

if minetest.get_modpath("digistuff") then
  dofile(MP.."/craft/digistuff.lua")
end

if minetest.get_modpath("nixie_tubes") then
  dofile(MP.."/craft/nixie_tubes.lua")
end

if minetest.get_modpath("advtrains") then
  dofile(MP.."/craft/advtrains.lua")
end

if minetest.get_modpath("advtrains_interlocking") then
  dofile(MP.."/craft/advtrains_interlocking.lua")
end

if minetest.get_modpath("advtrains_luaautomation") then
  dofile(MP.."/craft/advtrains_luaautomation.lua")
end