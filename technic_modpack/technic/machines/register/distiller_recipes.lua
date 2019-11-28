
local S = technic.getter

technic.register_recipe_type("distilling", {
	description = S("Distilling"),
	input_size = 2,
})

function technic.register_distiller_recipe(data)
	data.time = data.time or 4
	technic.register_recipe("distilling", data)
end

local recipes = {
	{"farming:sugar 3", "vessels:glass_bottle", "farming:bottle_ethanol"},
	{"mobs:honey", "vessels:glass_bottle", "farming:bottle_ethanol"},
}

for _, data in pairs(recipes) do
	technic.register_distiller_recipe({input = {data[1], data[2]}, output = data[3]})
end
