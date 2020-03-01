local max_charge = 500000
local power_per_use = max_charge / 50
local power_restore = power_per_use * 0.5

technic.register_power_tool("ufowreck:freezer", max_charge)
technic.register_power_tool("ufowreck:heater", max_charge)

minetest.register_tool("ufowreck:freezer", {
	description = "Freezer",
	inventory_image = "freezer.png",
	paramtype = "light",
	light_source = 12,
	stack_max = 1,
	liquids_pointable = true,
	wear_represents = "technic_RE_charge",
	on_refil = technic.refill_RE_charge,
	on_use = function(itemstack, user, pointed_thing)
	local meta = minetest.deserialize(itemstack:get_metadata())
		if not meta or not meta.charge then
			return
		end

	if pointed_thing.type ~= "node" then
		return
	end

	local pos = pointed_thing.under

	if minetest.is_protected(pos, user:get_player_name()) then
		minetest.record_protection_violation(pos, user:get_player_name())
		return
	end

	local charge_to_take = power_per_use

	local node = minetest.get_node(pos)
	
	if meta.charge >= charge_to_take and (not (pos == nil)) then
	if node.name == "default:dirt" or node.name == "default:dirt_with_coniferous_litter"
		or node.name == "default:dirt_with_dry_grass"
		or node.name == "default:dirt_with_grass"
		or node.name == "default:dirt_with_rainforest_litter"
	then
		node.name = "default:dirt_with_snow"
		minetest.swap_node(pos, node)
		minetest.sound_play({
			name="blaster_long"},{
			gain=1,
			pos=pos,
			max_hear_distance=20,
			loop=false})
	elseif node.name == "default:snowblock" or node.name == "default:dirt_with_snow" or minetest.get_item_group(node.name, "tree") == 1 then
		node.name = "default:ice"
		minetest.swap_node(pos, node)
		minetest.sound_play({
			name="blaster_long"},{
			gain=1,
			pos=pos,
			max_hear_distance=20,
			loop=false})
	elseif node.name == "default:water_source" or node.name == "default:water_flowing"
		or node.name == "default:river_water_source" or node.name == "default:river_water_flowing" then
			minetest.add_node(pos, {name="default:ice"})
			minetest.sound_play({
			name="blaster_long"},{
			gain=1,
			pos=pos,
			max_hear_distance=20,
			loop=false})
	elseif node.name == "default:lava_source" then
		node.name = "default:obsidian"
		minetest.swap_node(pos, node)
		minetest.sound_play({
			name="blaster_long"},{
			gain=1,
			pos=pos,
			max_hear_distance=20,
			loop=false})
	elseif node.name == "default:lava_flowing" then
		node.name = "tubelib:basalt_stone"
		minetest.swap_node(pos, node)
		minetest.sound_play({
			name="blaster_long"},{
			gain=1,
			pos=pos,
			max_hear_distance=20,
			loop=false})
	end
		meta.charge = meta.charge - charge_to_take
		itemstack:set_metadata(minetest.serialize(meta))
		technic.set_RE_wear(itemstack, meta.charge, max_charge)
		return itemstack
	end
	end,
})

minetest.register_tool("ufowreck:heater", {
	description = "Heater",
	inventory_image = "heater.png",
	paramtype = "light",
	light_source = 12,
	stack_max = 1,
	liquids_pointable = true,
	wear_represents = "technic_RE_charge",
	on_refil = technic.refill_RE_charge,
	on_use = function(itemstack, user, pointed_thing)
	local meta = minetest.deserialize(itemstack:get_metadata())
		if not meta or not meta.charge then
			return
		end

	if pointed_thing.type ~= "node" then
		return
	end

	local pos = pointed_thing.under

	if minetest.is_protected(pos, user:get_player_name()) then
		minetest.record_protection_violation(pos, user:get_player_name())
		return
	end

	local charge_to_take = power_per_use

	local node = minetest.get_node(pos)
	
	if meta.charge >= charge_to_take and (not (pos == nil)) then

	if node.name == "default:dirt" then
		node.name = "default:sand"
		minetest.swap_node(pos, node)
		minetest.sound_play({
			name="blaster_long"},{
			gain=1,
			pos=pos,
			max_hear_distance=20,
			loop=false})
	elseif node.name == "default:dirt_with_snow" 
		or node.name == "default:dirt_with_coniferous_litter"
		or node.name == "default:dirt_with_dry_grass"
		or node.name == "default:dirt_with_grass"
		or node.name == "default:dirt_with_rainforest_litter"
	then
		node.name = "default:dirt"
		minetest.swap_node(pos, node)
		minetest.sound_play({
			name="blaster_long"},{
			gain=1,
			pos=pos,
			max_hear_distance=20,
			loop=false})
	elseif minetest.get_item_group(node.name, "tree") == 1 then
		node.name = "fake_fire:embers"
		minetest.swap_node(pos, node)
		minetest.sound_play({
			name="blaster_long"},{
			gain=1,
			pos=pos,
			max_hear_distance=20,
			loop=false})
	elseif node.name == "default:snowblock" or node.name == "default:ice" then
		node.name = "default:river_water_source"
		minetest.swap_node(pos, node)
		minetest.sound_play({
			name="blaster_long"},{
			gain=1,
			pos=pos,
			max_hear_distance=20,
			loop=false})
	elseif node.name == "default:water_source" or node.name == "default:water_flowing"
		or node.name == "default:river_water_source" or node.name == "default:river_water_flowing" then
			node.name = "air"
			minetest.swap_node(pos, node)
			minetest.sound_play({
			name="blaster_long"},{
			gain=1,
			pos=pos,
			max_hear_distance=20,
			loop=false})
	elseif node.name == "default:obsidian" then
		node.name = "default:lava_source"
		minetest.swap_node(pos, node)
		minetest.sound_play({
			name="blaster_long"},{
			gain=1,
			pos=pos,
			max_hear_distance=20,
			loop=false})
	end
		meta.charge = meta.charge - charge_to_take
		itemstack:set_metadata(minetest.serialize(meta))
		technic.set_RE_wear(itemstack, meta.charge, max_charge)
		return itemstack
	end
	end,
})

minetest.register_tool("ufowreck:broken_raygun", {
    description = "Broken Raygun",
    inventory_image = "amcaw_raygun.png",
	paramtype = "light",
	light_source = 12,
	stack_max = 1,
	on_use = function(itemstack, user, pointed_thing)
		minetest.chat_send_player(user:get_player_name(), "This raygun is broken.")
	end,
})
	
minetest.register_craft({
	output = "ufowreck:freezer",
	recipe = {
	{"ufowreck:broken_raygun", "default:ice", "ufowreck:broken_raygun"},
	{"default:bronze_ingot", "technic:blue_energy_crystal", ""},
	{"ufowreck:broken_raygun", "", ""}
  }
})

minetest.register_craft({
	output = "ufowreck:heater",
	recipe = {
	{"ufowreck:broken_raygun", "bucket:bucket_lava", "ufowreck:broken_raygun"},
	{"default:bronze_ingot", "technic:red_energy_crystal", ""},
	{"ufowreck:broken_raygun", "", ""}
  }
})
