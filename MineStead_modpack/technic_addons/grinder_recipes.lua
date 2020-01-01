local recipes = {
        {"default:desert_cobble",           "default:gravel"},
        {"default:mossycobble",             "default:gravel"},
        {"gravelsieve:sieved_gravel",       "default:sand"},
        {"default:coral_skeleton",          "default:silver_sand"},
        {"default:desert_sand",             "default:clay"},
        {"default:silver_sand",             "default:clay"},
}

if minetest.get_modpath("caverealms") then
    table.insert(recipes, {"caverealms:salt_crystal", "farming:salt 4"})
    table.insert(recipes, {"caverealms:stone_with_salt", "farming:salt 2"})
    table.insert(recipes, {"caverealms:salt_gem", "farming:salt 1"})
    table.insert(recipes, {"caverealms:glow_mese", "default:mese_crystal_fragment 5"})
end

for _, data in pairs(recipes) do
        technic.register_grinder_recipe({input = {data[1]}, output = data[2]})
end
