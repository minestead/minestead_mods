checkpoints = {}
checkpoints.radius = 10 -- radius
checkpoints.running_race = false

-- formspec
checkpoints.checkpoint_formspec = {
        "formspec_version[3]",
        "size[6,5]",
        "label[0.375,0.5;", minetest.formspec_escape('Put here the checkpoint identification'), "]",
        "field[0.375,1.25;5.25,0.8;curr_checkpoint_name;Current Checkpoint Identification;AAAA]",
        "field[0.375,2.5;5.25,0.8;last_checkpoint_name;Previous Checkpoint Identification;BBBB]",
        "button[1.5,3.7;3,0.8;update;Update]",
    }

checkpoints.updateCheckpointFormSpec = function (pos, curr_checkpoint, prev_checkpoint)
    local formspec = table.concat(checkpoints.checkpoint_formspec, "")
    formspec = formspec:gsub( "AAAA", curr_checkpoint)
    formspec = formspec:gsub( "BBBB", prev_checkpoint)
    local meta = minetest.get_meta(pos)
    meta:set_string("formspec", formspec)
end

checkpoints.start_formspec = {
        "formspec_version[3]",
        "size[6,10]",
        "label[0.375,0.5;", minetest.formspec_escape('Put here the previous checkpont identification'), "]",
        "field[0.375,1.3;5.25,0.8;last_checkpoint_name;Previous Checkpoint Name;AAAA]",
        "field[0.375,2.5;5.25,0.8;race_laps;Race laps;BBBB]",
        "button[1.5,3.5;3,0.8;update;Update]",
        "field[0.375,4.9;1.5,0.8;targetx;Target msg X;XXXX]",
        "field[2.075,4.9;1.5,0.8;targety;Y;YYYY]",
        "field[3.775,4.9;1.5,0.8;targetz;Z;ZZZZ]",
        "button[1.5,6.1;3,0.8;settarget;Set Message Target]",
        "field[0.375,7.4;1.5,0.8;counttargetx;Start Display X;XX11]",
        "field[2.075,7.4;1.5,0.8;counttargety;Y;YY11]",
        "field[3.775,7.4;1.5,0.8;counttargetz;Z;ZZ11]",
        "button[1.5,8.6;3,0.8;setcounter;Set Start Display Position]",
        '["key_enter"]="false"',
    }

function checkpoints.updateStartFormSpecDefaults (pos, prev_checkpoint, laps, x_msg, y_msg, z_msg, x_count, y_count, z_count)
    local meta = minetest.get_meta(pos)
    local formspec = table.concat(checkpoints.start_formspec, "")
    formspec = formspec:gsub( "AAAA", prev_checkpoint)
    formspec = formspec:gsub( "BBBB", laps)
    formspec = formspec:gsub( "XXXX", x_msg)
    formspec = formspec:gsub( "YYYY", y_msg)
    formspec = formspec:gsub( "ZZZZ", z_msg)
    formspec = formspec:gsub( "XX11", x_count)
    formspec = formspec:gsub( "YY11", y_count)
    formspec = formspec:gsub( "ZZ11", z_count)
    meta:set_string("formspec", formspec)
end

function checkpoints.getAbsoluteTargetPos(node_pos, target_relative_pos)
    local target = vector.new()
    if target_relative_pos then
        local x0, y0, z0
        x0=node_pos.x+target_relative_pos.x;
        y0=node_pos.y+target_relative_pos.y;
        z0=node_pos.z+target_relative_pos.z;
        target.x = x0
        target.y = y0
        target.z = z0
    end
    return target
end

-- display entity shown when checkpoint node is punched
minetest.register_entity("checkpoints:display", {
	physical = false,
	collisionbox = {0, 0, 0, 0, 0, 0},
	visual = "wielditem",
	-- wielditem seems to be scaled to 1.5 times original node size
	visual_size = {x = 0.67, y = 0.67},
	textures = {"checkpoints:display_node"},
	timer = 0,
	glow = 10,

	on_step = function(self, dtime)

		self.timer = self.timer + dtime

		-- remove after set number of seconds
		if self.timer > 10 then
			self.object:remove()
		end
	end,
})

minetest.register_entity("checkpoints:target", {
	physical = false,
	collisionbox = {0, 0, 0, 0, 0, 0},
	visual = "wielditem",
	-- wielditem seems to be scaled to 1.5 times original node size
	visual_size = {x = 0.67, y = 0.67},
	textures = {"checkpoints:display_target"},
	timer = 0,
	glow = 10,

	on_step = function(self, dtime)

		self.timer = self.timer + dtime

		-- remove after set number of seconds
		if self.timer > 10 then
			self.object:remove()
		end
	end,
})


-- Display-zone node, Do NOT place the display as a node,
-- it is made to be used as an entity (see above)

minetest.register_node("checkpoints:display_node", {
	tiles = {"checkpoint_display.png"},
	use_texture_alpha = true,
	walkable = false,
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			-- sides
			{-(checkpoints.radius+.55), -(checkpoints.radius+.55), -(checkpoints.radius+.55), -(checkpoints.radius+.45), (checkpoints.radius+.55), (checkpoints.radius+.55)},
			{-(checkpoints.radius+.55), -(checkpoints.radius+.55), (checkpoints.radius+.45), (checkpoints.radius+.55), (checkpoints.radius+.55), (checkpoints.radius+.55)},
			{(checkpoints.radius+.45), -(checkpoints.radius+.55), -(checkpoints.radius+.55), (checkpoints.radius+.55), (checkpoints.radius+.55), (checkpoints.radius+.55)},
			{-(checkpoints.radius+.55), -(checkpoints.radius+.55), -(checkpoints.radius+.55), (checkpoints.radius+.55), (checkpoints.radius+.55), -(checkpoints.radius+.45)},
			-- top
			{-(checkpoints.radius+.55), (checkpoints.radius+.45), -(checkpoints.radius+.55), (checkpoints.radius+.55), (checkpoints.radius+.55), (checkpoints.radius+.55)},
			-- bottom
			{-(checkpoints.radius+.55), -(checkpoints.radius+.55), -(checkpoints.radius+.55), (checkpoints.radius+.55), -(checkpoints.radius+.45), (checkpoints.radius+.55)},
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

minetest.register_node("checkpoints:display_target", {
	tiles = {"checkpoint_target.png"},
	use_texture_alpha = true,
	walkable = false,
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
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

