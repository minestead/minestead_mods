unused_args = false
allow_defined_top = true

globals = {
	"missions",
	"minetest"
}

read_globals = {
	-- Stdlib
	string = {fields = {"split"}},
	table = {fields = {"copy", "getn"}},
	"call",

	-- Minetest
	"vector", "ItemStack",
	"dump", "VoxelArea",

	-- Deps
	"unified_inventory", "default", "xp_redo",
	"mesecon"
}
