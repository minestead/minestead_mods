dofile(minetest.get_modpath("checkpoints") .. DIR_DELIM .. "checkpoints_common.lua")
dofile(minetest.get_modpath("checkpoints") .. DIR_DELIM .. "checkpoint.lua")
dofile(minetest.get_modpath("checkpoints") .. DIR_DELIM .. "start_point.lua")

checkpoints.refuel_radius = 5 -- radius

-- race restarter
minetest.register_craftitem("checkpoints:status_restarter",{
	description = "Race status restarter",
	inventory_image = "status_restarter_inv.png",
})

minetest.register_craft({
	output = "checkpoints:status_restarter",
	recipe = {
		{"", "default:obsidian", ""},
		{"", "default:steel_ingot", ""},
		{"", "default:obsidian", ""},
	},
})

-- refuel zone craft
minetest.register_craft({
	output = "checkpoints:refuel",
	recipe = {
		{"", "default:steel_ingot", ""},
		{"", "biofuel:biofuel", ""},
		{"", "default:steel_ingot", ""},
	},
})

-- refuel zone
minetest.register_node("checkpoints:refuel", {
	description = "Refuel Logo" .. " (" .. "USE for kart refueling" .. ")",
	tiles = {"refuel_logo.png"},
	wield_image = "refuel_logo.png",
	inventory_image = "refuel_logo.png",
	sounds = default.node_sound_stone_defaults(),
	groups = {dig_immediate = 2, unbreakable = 1},
	paramtype = "light",
	paramtype2 = "wallmounted",
	legacy_wallmounted = true,
	light_source = 4,
	drawtype = "nodebox",
	sunlight_propagates = true,
	walkable = true,
	node_box = {
		type = "wallmounted",
		wall_top    = {-0.5, 0.4375, -0.5, 0.5, 0.5, 0.5},
		wall_bottom = {-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5},
		wall_side   = {-0.5, -0.5, -0.5, -0.4375, 0.5, 0.5},
	},
	selection_box = {type = "wallmounted"},

	on_construct = function(pos)
        
	end,

	after_place_node = function(pos, placer)

	end,

	on_punch = function(pos, node, puncher)
		minetest.add_entity(pos, "checkpoints:display_refuel_zone")
	end,
})

-- display entity shown when refuel node is punched
minetest.register_entity("checkpoints:display_refuel_zone", {
	physical = false,
	collisionbox = {0, 0, 0, 0, 0, 0},
	visual = "wielditem",
	-- wielditem seems to be scaled to 1.5 times original node size
	visual_size = {x = 0.67, y = 0.67},
	textures = {"checkpoints:display_refuel_zone_node"},
	timer = 0,
	glow = 10,

	on_step = function(self, dtime)

		self.timer = self.timer + dtime

		-- remove after set number of seconds
		if self.timer > 3 then
			self.object:remove()
		end
	end,
})

minetest.register_node("checkpoints:display_refuel_zone_node", {
	tiles = {"checkpoint_target.png"},
	use_texture_alpha = true,
	walkable = false,
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			-- sides
			{-(checkpoints.refuel_radius+.55), -(checkpoints.refuel_radius+.55), -(checkpoints.refuel_radius+.55), -(checkpoints.refuel_radius+.45), (checkpoints.refuel_radius+.55), (checkpoints.refuel_radius+.55)},
			{-(checkpoints.refuel_radius+.55), -(checkpoints.refuel_radius+.55), (checkpoints.refuel_radius+.45), (checkpoints.refuel_radius+.55), (checkpoints.refuel_radius+.55), (checkpoints.refuel_radius+.55)},
			{(checkpoints.refuel_radius+.45), -(checkpoints.refuel_radius+.55), -(checkpoints.refuel_radius+.55), (checkpoints.refuel_radius+.55), (checkpoints.refuel_radius+.55), (checkpoints.refuel_radius+.55)},
			{-(checkpoints.refuel_radius+.55), -(checkpoints.refuel_radius+.55), -(checkpoints.refuel_radius+.55), (checkpoints.refuel_radius+.55), (checkpoints.refuel_radius+.55), -(checkpoints.refuel_radius+.45)},
			-- top
			{-(checkpoints.refuel_radius+.55), (checkpoints.refuel_radius+.45), -(checkpoints.refuel_radius+.55), (checkpoints.refuel_radius+.55), (checkpoints.refuel_radius+.55), (checkpoints.refuel_radius+.55)},
			-- bottom
			{-(checkpoints.refuel_radius+.55), -(checkpoints.refuel_radius+.55), -(checkpoints.refuel_radius+.55), (checkpoints.refuel_radius+.55), -(checkpoints.refuel_radius+.45), (checkpoints.refuel_radius+.55)},
			-- middle (surround protector)
			{-.55,-.55,-.55, .55,.55,.55},
		},
	},
	selection_box = {
		type = "regular",
	},
	paramtype = "light",
	groups = {dig_immediate = 3, not_in_creative_inventory = 1},
	drop = "",
})

