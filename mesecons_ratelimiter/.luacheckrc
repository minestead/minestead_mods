allow_defined_top = true

globals = {
	"mesecon",
	"minetest"
}

read_globals = {
	-- Stdlib
	string = {fields = {"split"}},
	table = {fields = {"copy", "getn"}},

	-- Minetest
	"vector", "ItemStack",
	"dump",

	-- optional deps
	"monitoring"
}
