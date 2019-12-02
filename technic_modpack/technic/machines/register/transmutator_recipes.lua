
local S = technic.getter

technic.register_recipe_type("transmutating", {
	description = S("transmutating"),
	input_size = 1,
})

function technic.register_transmutator_recipe(data)
	data.time = data.time or 4
	technic.register_recipe("transmutating", data)
end

local recipes = {
	{"moreores:mithril_block 2", "technic:lead_block"},
	{"technic:lead_block 2", "default:goldblock"},
	{"default:goldblock 2", "default:tinblock"},
	{"default:tinblock 2", "moreores:silver_block"},
	{"moreores:silver_block 2", "technic:zinc_block"},
	{"technic:zinc_block 2", "default:copperblock"},
	{"default:copperblock 2", "default:steelblock"},
	{"default:steelblock 2", "technic:chromium_block"},
}

for _, data in pairs(recipes) do
	technic.register_transmutator_recipe({input = { data[1] }, output = { data[2] } })
end
