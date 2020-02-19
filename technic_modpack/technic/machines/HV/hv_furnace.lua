
local S = technic.getter

-- HV furnace

minetest.register_craft({
	output = 'technic:hv_furnace',
	recipe = {
		{'technic:mv_grinder', 'technic:mv_electric_furnace', 'pipeworks:autocrafter'},
		{'technic:control_logic_unit', 'technic:hv_transformer', 'pipeworks:tube_1'},
		{'technic:stainless_steel_block', 'technic:hv_cable', 'technic:stainless_steel_block'},
	}
})

local S = technic.getter

technic.register_recipe_type("melting", {
	description = S("Melting"),
	input_size = 1,
})

function technic.register_furnace_recipe(data)
	data.time = data.time or 9
	technic.register_recipe("melting", data)
end

local recipes = {
	{"technic:uranium_lump 9", "technic:uranium_block 2"},
	{"technic:uranium0_dust 9", "technic:uranium0_block"},
	{"technic:uranium35_dust 9", "technic:uranium35_block"},
	{"moreores:mithril_lump 9", "moreores:mithril_block 2"},
	{"technic:mithril_dust 9", "moreores:mithril_block"},
	{"technic:lead_lump 9", "technic:lead_block 2"},
	{"technic:lead_dust 9", "technic:lead_block"},
	{"default:gold_lump 9", "default:goldblock 2"},
	{"technic:gold_dust 9", "default:goldblock"},
	{"default:tin_lump 9", "default:tinblock 2"},
	{"technic:tin_dust 9", "default:tinblock"},
	{"moreores:silver_lump 9", "moreores:silver_block 2"},
	{"technic:silver_dust 9", "moreores:silver_block"},
	{"technic:zinc_lump 9", "technic:zinc_block 2"},
	{"technic:zinc_dust 9", "technic:zinc_block"},
	{"default:copper_lump 9", "default:copperblock 2"},
	{"technic:copper_dust 9", "default:copperblock"},
	{"default:iron_lump 9", "default:steelblock 2"},
	{"technic:wrought_iron_dust 9", "default:steelblock"},
	{"technic:chromium_lump 9", "technic:chromium_block 2"},
	{"technic:chromium_dust 9", "technic:chromium_block"},
	{"technic:brass_dust 9", "basic_materials:brass_block"},
	{"technic:carbon_steel_dust 9", "technic:carbon_steel_block"},
	{"technic:cast_iron_dust 9", "technic:cast_iron_block"},
	{"technic:stainless_steel_dust 9", "technic:stainless_steel_block"},
}

for _, data in pairs(recipes) do
	technic.register_furnace_recipe({input = { data[1] }, output = { data[2] } })
end

function technic.register_furnace(data)
	data.typename = "melting"
	data.machine_name = "furnace"
	data.machine_desc = S("%s Furnace")
	technic.register_base_machine(data)
end

technic.register_furnace({tier = "HV", demand = {30000, 20000, 10000}, speed = 1, upgrade = 1, tube = 1})
