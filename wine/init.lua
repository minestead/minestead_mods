wine = {}

local def = minetest.get_modpath("default")

local snd_d = def and default.node_sound_defaults()
local snd_g = def and default.node_sound_glass_defaults()
local snd_l = def and default.node_sound_leaves_defaults()
local sand = "default:desert_sand"

-- check for MineClone2
local mcl = minetest.get_modpath("mcl_core")

if mcl then
	snd_d = mcl_sounds.node_sound_glass_defaults()
	snd_g = mcl_sounds.node_sound_defaults()
	snd_l = mcl_sounds.node_sound_leaves_defaults()
	sand = "mcl_core:sand"
end

-- check for Unified Inventory
local is_uninv = minetest.global_exists("unified_inventory") or false

-- is thirsty mod active
local thirsty_mod = minetest.get_modpath("thirsty")

-- Intllib
local S
if minetest.get_modpath("intllib") then
	S = intllib.Getter()
else
	S = function(s, a, ...)
		if a == nil then
			return s
		end
		a = {a, ...}
		return s:gsub("(@?)@(%(?)(%d+)(%)?)",
			function(e, o, n, c)
				if e == ""then
					return a[tonumber(n)] .. (o == "" and c or "")
				else
					return "@" .. o .. n .. c
				end
			end)
	end
end


-- Unified Inventory hints
if is_uninv then

	unified_inventory.register_craft_type("barrel", {
		description = "Barrel",
		icon = 'wine_barrel.png',
		width = 1,
		height = 1,
	})
end


local ferment = {
	{"farming:grapes", "wine:glass_wine"},
	{"farming:barley", "wine:glass_beer"},
	{"mobs:honey", "wine:glass_mead"},
	{"default:apple", "wine:glass_cider"},
	{"default:papyrus", "wine:glass_rum"},
	{"wine:blue_agave", "wine:glass_tequila"},
	{"farming:wheat", "wine:glass_wheat_beer"},
	{"farming:rice", "wine:glass_sake"},
	{"farming:corn", "wine:glass_bourbon"},
	{"farming:baked_potato", "wine:glass_vodka"}
}

if mcl then
	ferment[4] = {"mcl_core:apple", "wine:glass_cider"}
	ferment[5] = {"mcl_core:paper", "wine:glass_rum"}
end


if is_uninv then

	for _, f in pairs(ferment) do

		unified_inventory.register_craft({
			type = "barrel",
			items = {f[1]},
			output = f[2],
		})
	end
end


-- add item and resulting beverage to list
function wine:add_item(list)

	for n = 1, #list do

		table.insert(ferment, list[n])

		if is_uninv then

			unified_inventory.register_craft({
				type = "barrel",
				items = {list[n][1]},
				output = list[n][2],
			})
		end
	end
end


-- list of beverages (name, desc, has bottle, hunger, thirst)
local beverages = {
	{"wine", "Wine", true, 2, 5},
	{"beer", "Beer", true, 2, 8},
	{"rum", "Rum", true, 2, 5},
	{"tequila", "Tequila", true, 2, 3},
	{"wheat_beer", "Wheat Beer", true, 2, 8},
	{"sake", "Sake", true, 2, 3},
	{"bourbon", "Bourbon", true, 2, 3},
	{"vodka", "Vodka", true, 2, 3},
	{"cider", "Cider", true, 2, 6},
	{"mead", "Honey-Mead", true, 4, 5}
}

-- create glasses and bottles
for n = 1, #beverages do

	local name = beverages[n][1]
	local desc = beverages[n][2]
	local has_bottle = beverages[n][3]
	local num_hunger = beverages[n][4]
	local num_thirst = beverages[n][5]

	-- glass
	minetest.register_node("wine:glass_" .. name, {
		description = S("Glass of " .. desc),
		drawtype = "plantlike",
		visual_scale = 0.5,
		tiles = {"wine_" .. name .. "_glass.png"},
		inventory_image = "wine_" .. name .. "_glass.png",
		wield_image = "wine_" .. name .. "_glass.png",
		paramtype = "light",
		is_ground_content = false,
		sunlight_propagates = true,
		walkable = false,
		selection_box = {
			type = "fixed",
			fixed = {-0.15, -0.5, -0.15, 0.15, 0, 0.15}
		},
		groups = {
			vessel = 1, dig_immediate = 3,
			attached_node = 1, alcohol = 1
		},
		sounds = snd_g,
		on_use = function(itemstack, user, pointed_thing)

			if user then

				if thirsty_mod then
					thirsty.drink(user, num_thirst)
				end

				return minetest.do_item_eat(num_hunger, nil,
						itemstack, user, pointed_thing)
			end
		end
	})

	-- bottle
	if has_bottle then

		minetest.register_node("wine:bottle_" .. name, {
			description = S("Bottle of " .. desc),
			drawtype = "plantlike",
			visual_scale = 0.7,
			tiles = {"wine_" .. name .. "_bottle.png"},
			inventory_image = "wine_" .. name .. "_bottle.png",
			paramtype = "light",
			sunlight_propagates = true,
			walkable = false,
			selection_box = {
				type = "fixed",
				fixed = {-0.15, -0.5, -0.15, 0.15, 0.25, 0.15}
			},
			groups = {dig_immediate = 3, attached_node = 1, vessel = 1},
			sounds = snd_d,
		})

		local glass = "wine:glass_" .. name

		minetest.register_craft({
			output = "wine:bottle_" .. name,
			recipe = {
				{glass, glass, glass},
				{glass, glass, glass},
				{glass, glass, glass},
			},
		})

		minetest.register_craft({
			type = "shapeless",
			output = glass .. " 9",
			recipe = {"wine:bottle_" .. name},
		})
	end
end


-- override to add food group to wine glass
minetest.override_item("wine:glass_wine", {
	groups = {
		food_wine = 1, vessel = 1, dig_immediate = 3,
		attached_node = 1, alcohol = 1
	}
})


-- blue agave
minetest.register_node("wine:blue_agave", {
	description = S("Blue Agave"),
	drawtype = "plantlike",
	visual_scale = 0.8,
	tiles = {"wine_blue_agave.png"},
	inventory_image = "wine_blue_agave.png",
	wield_image = "wine_blue_agave.png",
	paramtype = "light",
	is_ground_content = false,
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.2, -0.5, -0.2, 0.2, 0.3, 0.2}
	},
	groups = {snappy = 3, attached_node = 1, plant = 1},
	sounds = snd_l,

	on_construct = function(pos)

		local timer = minetest.get_node_timer(pos)

		timer:start(17)
	end,

	on_timer = function(pos)

		local light = minetest.get_node_light(pos)

		if not light or light < 13 or math.random() > 1/76 then
			return true -- go to next iteration
		end

		local n = minetest.find_nodes_in_area_under_air(
			{x = pos.x + 2, y = pos.y + 1, z = pos.z + 2},
			{x = pos.x - 2, y = pos.y - 1, z = pos.z - 2},
			{"wine:blue_agave"})

		-- too crowded, we'll wait for another iteration
		if #n > 2 then
			return true
		end

		-- find desert sand with air above (grow across and down only)
		n = minetest.find_nodes_in_area_under_air(
			{x = pos.x + 1, y = pos.y - 1, z = pos.z + 1},
			{x = pos.x - 1, y = pos.y - 2, z = pos.z - 1},
			{sand})

		-- place blue agave
		if n and #n > 0 then

			local new_pos = n[math.random(#n)]

			new_pos.y = new_pos.y + 1

			minetest.set_node(new_pos, {name = "wine:blue_agave"})
		end

		return true
	end
})

minetest.register_craft( {
	type = "shapeless",
	output = "dye:cyan 4",
	recipe = {"wine:blue_agave"}
})

minetest.register_decoration({
	deco_type = "simple",
	place_on = {sand},
	sidelen = 16,
	fill_ratio = 0.001,
	biomes = {"desert"},
	decoration = {"wine:blue_agave"},
	y_min = 15,
	y_max = 50,
	spawn_by = sand,
	num_spawn_by = 6,
})

if minetest.get_modpath("bonemeal") then

	bonemeal:add_deco({
		{sand, {}, {"default:dry_shrub", "wine:blue_agave", "", ""} }
	})
end


-- Wine barrel
winebarrel_formspec = "size[8,9]"
	.. "list[current_name;src;2,1;1,1;]"
	.. "list[current_name;dst;5,1;1,1;]"
	.. "list[current_player;main;0,5;8,4;]"
	.. "listring[current_name;dst]"
	.. "listring[current_player;main]"
	.. "listring[current_name;src]"
	.. "listring[current_player;main]"
	.. "image[3.5,1;1,1;gui_furnace_arrow_bg.png^[transformR270]"

minetest.register_node("wine:wine_barrel", {
	description = S("Fermenting Barrel"),
	tiles = {"wine_barrel.png" },
	drawtype = "mesh",
	mesh = "wine_barrel.obj",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {
		choppy = 2, oddly_breakable_by_hand = 1, flammable = 2,
		tubedevice = 1, tubedevice_receiver = 1
	},
	legacy_facedir_simple = true,

	on_place = minetest.rotate_node,

	on_construct = function(pos)

		local meta = minetest.get_meta(pos)

		meta:set_string("formspec", winebarrel_formspec)
		meta:set_string("infotext", S("Fermenting Barrel"))
		meta:set_float("status", 0.0)

		local inv = meta:get_inventory()

		inv:set_size("src", 1)
		inv:set_size("dst", 1)
	end,

	can_dig = function(pos,player)

		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()

		if not inv:is_empty("dst")
		or not inv:is_empty("src") then
			return false
		end

		return true
	end,

	allow_metadata_inventory_take = function(
			pos, listname, index, stack, player)

		if minetest.is_protected(pos, player:get_player_name()) then
			return 0
		end

		return stack:get_count()
	end,

	allow_metadata_inventory_put = function(
			pos, listname, index, stack, player)

		if minetest.is_protected(pos, player:get_player_name()) then
			return 0
		end

		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()

		if listname == "src" then
			return stack:get_count()
		elseif listname == "dst" then
			return 0
		end
	end,

	allow_metadata_inventory_move = function(
			pos, from_list, from_index, to_list, to_index, count, player)

		if minetest.is_protected(pos, player:get_player_name()) then
			return 0
		end

		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		local stack = inv:get_stack(from_list, from_index)

		if to_list == "src" then
			return count
		elseif to_list == "dst" then
			return 0
		end
	end,

	on_metadata_inventory_put = function(pos)

		local timer = minetest.get_node_timer(pos)

		timer:start(5)
	end,

	tube = (function() if minetest.get_modpath("pipeworks") then return {

		-- using a different stack from defaut when inserting
		insert_object = function(pos, node, stack, direction)

			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			local timer = minetest.get_node_timer(pos)

			if not timer:is_started() then
				timer:start(5)
			end

			return inv:add_item("src", stack)
		end,

		can_insert = function(pos,node,stack,direction)

			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()

			return inv:room_for_item("src", stack)
		end,

		-- the default stack, from which objects will be taken
		input_inventory = "dst",
		connect_sides = {
			left = 1, right = 1, back = 1,
			front = 1, bottom = 1, top = 1}	} end end)(),

	on_timer = function(pos)

		local meta = minetest.get_meta(pos) ; if not meta then return end
		local inv = meta:get_inventory()

		-- is barrel empty?
		if not inv or inv:is_empty("src") then

			meta:set_float("status", 0.0)
			meta:set_string("infotext", S("Fermenting Barrel"))

			return false
		end

		-- does it contain any of the source items on the list?
		local has_item

		for n = 1, #ferment do

			if inv:contains_item("src", ItemStack(ferment[n][1])) then

				has_item = n

				break
			end
		end

		if not has_item then
			return false
		end

		-- is there room for additional fermentation?
		if not inv:room_for_item("dst", ferment[has_item][2]) then

			meta:set_string("infotext", S("Fermenting Barrel (FULL)"))

			return true
		end

		local status = meta:get_float("status")

		-- fermenting (change status)
		if status < 100 then
			meta:set_string("infotext", S("Fermenting Barrel (@1% Done)", status))
			meta:set_float("status", status + 5)
		else
			inv:remove_item("src", ferment[has_item][1])
			inv:add_item("dst", ferment[has_item][2])

			meta:set_float("status", 0,0)
		end

		if inv:is_empty("src") then
			meta:set_float("status", 0.0)
			meta:set_string("infotext", S("Fermenting Barrel"))
		end

		return true
	end,
})

local ingot = "default:steel_ingot"

if mcl then
	ingot = "mcl_core:iron_ingot"
end

minetest.register_craft({
	output = "wine:wine_barrel",
	recipe = {
		{"group:wood", "group:wood", "group:wood"},
		{ingot, "", ingot},
		{"group:wood", "group:wood", "group:wood"},
	},
})


-- LBMs to start timers on existing, ABM-driven nodes
minetest.register_lbm({
	name = "wine:barrel_timer_init",
	nodenames = {"wine:wine_barrel"},
	run_at_every_load = false,
	action = function(pos)

		local t = minetest.get_node_timer(pos)

		t:start(5)
	end,
})

minetest.register_lbm({
	name = "wine:agave_timer_init",
	nodenames = {"wine:blue_agave"},
	run_at_every_load = false,
	action = function(pos)

		local t = minetest.get_node_timer(pos)

		t:start(17)
	end,
})


-- add lucky blocks
if minetest.get_modpath("lucky_block") then

	lucky_block:add_blocks({
		{"fal", {"default:water_source"}, 1, true, 4},
		{"dro", {"wine:glass_wine"}, 5},
		{"dro", {"wine:glass_beer"}, 5},
		{"dro", {"wine:glass_wheat_beer"}, 5},
		{"dro", {"wine:glass_mead"}, 5},
		{"dro", {"wine:glass_cider"}, 5},
		{"dro", {"wine:glass_rum"}, 5},
		{"dro", {"wine:glass_sake"}, 5},
		{"dro", {"wine:glass_tequila"}, 5},
		{"dro", {"wine:glass_bourbon"}, 5},
		{"dro", {"wine:glass_vodka"}, 5},
		{"dro", {"wine:wine_barrel"}, 1},
		{"tel", 5, 1},
		{"nod", "default:chest", 0, {
			{name = "wine:bottle_wine", max = 1},
			{name = "wine:bottle_tequila", max = 1},
			{name = "wine:bottle_rum", max = 1},
			{name = "wine:bottle_cider", max = 1},
			{name = "wine:bottle_bourbon", max = 1},
			{name = "wine:bottle_vodka", max = 1},
			{name = "wine:wine_barrel", max = 1},
			{name = "wine:bottle_sake", max = 1},
			{name = "wine:bottle_mead", max = 1},
			{name = "wine:bottle_beer", max = 1},
			{name = "wine:bottle_wheat_beer", max = 1},
			{name = "wine:blue_agave", max = 4}}},
	})
end

print (S("[MOD] Wine loaded"))
