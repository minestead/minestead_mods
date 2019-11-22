local recipes = {
        {"default:desert_cobble",           "default:gravel"},
        {"default:mossycobble",             "default:gravel"},
        {"gravelsieve:sieved_gravel",       "default:sand"},
        {"default:coral_skeleton",          "default:silver_sand"},
        {"default:desert_sand",             "default:clay"},
        {"default:silver_sand",             "default:clay"},
}

for _, data in pairs(recipes) do
        technic.register_grinder_recipe({input = {data[1]}, output = data[2]})
end
