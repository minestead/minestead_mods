dofile(minetest.get_modpath("checkpoints") .. DIR_DELIM .. "checkpoints_common.lua")

---------------------------------------------------
-- this section creates a floating lap indicator
---------------------------------------------------

minetest.register_node("checkpoints:lap_end", {
    tiles = {"lap_end.png"},
    use_texture_alpha = true,
    walkable = false,
    drawtype = "nodebox",
    node_box = {
        type = "fixed",
        fixed = {
	        {-.55,-.45,-.55, .55,.45,.55},
        },
    },
    selection_box = {
        type = "regular",
    },
    paramtype = "light",
    groups = {dig_immediate = 3, not_in_creative_inventory = 1},
    drop = "",
})

minetest.register_entity("checkpoints:lap_end_ent", {
    physical = false,
    collisionbox = {0, 0, 0, 0, 0, 0},
    visual = "wielditem",
    -- wielditem seems to be scaled to 1.5 times original node size
    visual_size = {x = 0.67, y = 0.67},
    textures = {"checkpoints:lap_end"},
    timer = 0,
    glow = 10,

    on_step = function(self, dtime)

        self.timer = self.timer + dtime

        -- remove after set number of seconds
        if self.timer > 15 then
	        self.object:remove()
        end
    end,
})

minetest.register_node("checkpoints:lap_go", {
    tiles = {"lap_go.png"},
    use_texture_alpha = true,
    walkable = false,
    drawtype = "nodebox",
    node_box = {
        type = "fixed",
        fixed = {
	        {-.55,-.45,-.55, .55,.45,.55},
        },
    },
    selection_box = {
        type = "regular",
    },
    paramtype = "light",
    groups = {dig_immediate = 3, not_in_creative_inventory = 1},
    drop = "",
})

minetest.register_entity("checkpoints:lap_go_ent", {
    physical = false,
    collisionbox = {0, 0, 0, 0, 0, 0},
    visual = "wielditem",
    -- wielditem seems to be scaled to 1.5 times original node size
    visual_size = {x = 0.67, y = 0.67},
    textures = {"checkpoints:lap_go"},
    timer = 0,
    glow = 10,

    on_step = function(self, dtime)

        self.timer = self.timer + dtime

        -- remove after set number of seconds
        if self.timer > 15 then
	        self.object:remove()
        end
    end,
})

minetest.register_node("checkpoints:count_1", {
    tiles = {"count_1.png"},
    use_texture_alpha = true,
    walkable = false,
    drawtype = "nodebox",
    node_box = {
        type = "fixed",
        fixed = {
	        {-.55,-.45,-.55, .55,.45,.55},
        },
    },
    selection_box = {
        type = "regular",
    },
    paramtype = "light",
    groups = {dig_immediate = 3, not_in_creative_inventory = 1},
    drop = "",
})

minetest.register_entity("checkpoints:count_1_ent", {
    physical = false,
    collisionbox = {0, 0, 0, 0, 0, 0},
    visual = "wielditem",
    -- wielditem seems to be scaled to 1.5 times original node size
    visual_size = {x = 0.67, y = 0.67},
    textures = {"checkpoints:count_1"},
    timer = 0,
    glow = 10,

    on_step = function(self, dtime)

        self.timer = self.timer + dtime

        -- remove after set number of seconds
        if self.timer > 2 then
            --start the RACE now!!!!!
            minetest.add_entity(checkpoints.count_ent_pos, "checkpoints:lap_go_ent")
            
            checkpoints.running_race = true
            
            minetest.sound_play("03_start4", {
                --to_player = player,
                pos = pos,
                max_hear_distance = 200,
                gain = 10.0,
                fade = 0.0,
                pitch = 1.0,
            })
	        self.object:remove()
        end
    end,
})

minetest.register_node("checkpoints:count_2", {
    tiles = {"count_2.png"},
    use_texture_alpha = true,
    walkable = false,
    drawtype = "nodebox",
    node_box = {
        type = "fixed",
        fixed = {
	        {-.55,-.45,-.55, .55,.45,.55},
        },
    },
    selection_box = {
        type = "regular",
    },
    paramtype = "light",
    groups = {dig_immediate = 3, not_in_creative_inventory = 1},
    drop = "",
})

minetest.register_entity("checkpoints:count_2_ent", {
    physical = false,
    collisionbox = {0, 0, 0, 0, 0, 0},
    visual = "wielditem",
    -- wielditem seems to be scaled to 1.5 times original node size
    visual_size = {x = 0.67, y = 0.67},
    textures = {"checkpoints:count_2"},
    timer = 0,
    glow = 10,

    on_step = function(self, dtime)

        self.timer = self.timer + dtime

        -- remove after set number of seconds
        if self.timer > 2 then
            minetest.add_entity(checkpoints.count_ent_pos, "checkpoints:count_1_ent")
	        self.object:remove()
        end
    end,
})

minetest.register_node("checkpoints:count_3", {
    tiles = {"count_3.png"},
    use_texture_alpha = true,
    walkable = false,
    drawtype = "nodebox",
    node_box = {
        type = "fixed",
        fixed = {
	        {-.55,-.45,-.55, .55,.45,.55},
        },
    },
    selection_box = {
        type = "regular",
    },
    paramtype = "light",
    groups = {dig_immediate = 3, not_in_creative_inventory = 1},
    drop = "",
})

minetest.register_entity("checkpoints:count_3_ent", {
    physical = false,
    collisionbox = {0, 0, 0, 0, 0, 0},
    visual = "wielditem",
    -- wielditem seems to be scaled to 1.5 times original node size
    visual_size = {x = 0.67, y = 0.67},
    textures = {"checkpoints:count_3"},
    timer = 0,
    glow = 10,

    on_step = function(self, dtime)

        self.timer = self.timer + dtime

        -- remove after set number of seconds
        if self.timer > 2 then
            minetest.add_entity(checkpoints.count_ent_pos, "checkpoints:count_2_ent")
	        self.object:remove()
        end
    end,
})

checkpoints.count_ent_pos = vector.new()
function checkpoints.call_start_indicator(pos)
    checkpoints.count_ent_pos = pos
    minetest.add_entity(pos, "checkpoints:count_3_ent")
end

