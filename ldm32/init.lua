laser_range = 32

local laser_on = function(pos, facedir_param2, range)
    local meta = minetest.get_meta(pos)
    local block_pos = vector.new(pos)
    local beam_pos = vector.new(pos)
    local beam_direction = minetest.facedir_to_dir(facedir_param2)

    for i = 1, range + 1, 1 do
        beam_pos = vector.add(block_pos, vector.multiply(beam_direction, i))
        if minetest.get_node(beam_pos).name == "air" or minetest.get_node(beam_pos).name == "ldm32:laser_beam" then
            if i <= range then
                minetest.set_node(beam_pos, {name = "ldm32:laser_beam", param2 = facedir_param2})
                meta:set_string("infotext", "Distance: " .. tostring(i) .. "m")
                meta:set_int("range", i)
            else
                meta:set_string("infotext", "Distance: out of range")
                meta:set_int("range", laser_range)
            end
        else
            break
        end
    end
end

local laser_off = function(pos, facedir_param2, range)
    local meta = minetest.get_meta(pos)
    local block_pos = vector.new(pos)
    local beam_pos = vector.new(pos)
    local beam_direction = minetest.facedir_to_dir(facedir_param2)

    for i = range, 0, -1 do
        beam_pos = vector.add(block_pos, vector.multiply(beam_direction, i))
        if minetest.get_node(beam_pos).name == "ldm32:laser_beam" and minetest.get_node(beam_pos).param2 == facedir_param2 then
            minetest.set_node(beam_pos, {name="air"})
        end
    end
end

local laser_check = function(pos, facedir_param2, range)
    local block_pos = vector.new(pos)
    local beam_pos = vector.new(pos)
    local beam_direction = minetest.facedir_to_dir(facedir_param2)
    local is_not_beam = false
    
    for i = 1, range + 1, 1 do
        beam_pos = vector.add(block_pos, vector.multiply(beam_direction, i))
        if minetest.get_node(beam_pos).name ~= "ldm32:laser_beam" and i <= range then
            is_not_beam = true
        elseif minetest.get_node(beam_pos).name == "air" and i <= laser_range then
            is_not_beam = true
        end
    end
    return is_not_beam
end

minetest.register_node("ldm32:casing", {
    description = "Laser Distance Meter",
    inventory_image = "ldm32_inventory.png",
    drawtype = "mesh",
    mesh = "ldm32_casing.obj",
    tiles = {"ldm32_casing2.png",
             "ldm32_casing.png",},
    selection_box = {
        type = "fixed",
        fixed = {{-0.07, -0.5, -0.5, 0.07, -0.25, 0.5},}
    },
    collision_box = {
        type = "fixed",
        fixed = {{-0.07, -0.5, -0.5, 0.07, -0.25, 0.5},}
    },
    stack_max = 1,
    is_ground_content = true,
    paramtype2 = "facedir",
    groups = {snappy = 3, dig_immediate = 3},
    on_place = minetest.rotate_node,

    on_timer = function(pos)
        local meta = minetest.get_meta(pos)
        local node = minetest.get_node(pos)
        local timer = minetest.get_node_timer(pos)
        local is_not_beam = false
        local is_air = false

        if meta:get_string("is_on") == "true" then
            if laser_check(pos, node.param2, meta:get_int("range")) then
                laser_off(pos, node.param2, meta:get_int("range"))
                laser_on(pos, node.param2, laser_range)
            end
            if meta:get_int("facedir") ~= node.param2 and meta:get_string("is_on") then
                laser_off(pos, meta:get_int("facedir"), laser_range)
                laser_on(pos, node.param2, laser_range)
                meta:set_int("facedir", node.param2)
            end
        end
        timer:start(1)
    end,

    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        local node = minetest.get_node(pos)
        meta:set_string("infotext","Off")
        meta:set_string("is_on", "false")
        meta:set_int("facedir", node.param2)
    end,

    after_destruct = function(pos, oldnode, oldmetadata)
        local meta = minetest.get_meta(pos)
        laser_off(pos, oldnode.param2, laser_range)
        meta:set_string("infotext", "Off")
        meta:set_string("is_on", "false")
    end,

    after_dig_node = function(pos, oldnode)
        local meta = minetest.get_meta(pos)
        laser_off(pos, oldnode.param2, laser_range)
        meta:set_string("infotext", "Off")
        meta:set_string("is_on", "false")
    end,

    on_rightclick = function(pos, node, player, itemstack, pointed_thing)
        local meta = minetest.get_meta(pos)
        local node = minetest.get_node(pos)
        local timer = minetest.get_node_timer(pos)

        if meta:get_string("is_on") == "false" then
            laser_on(pos, node.param2, laser_range)
            meta:set_string("is_on", "true")
            timer:start(1)
        else
            laser_off(pos, node.param2, meta:get_int("range"))
            meta:set_string("infotext", "Off")
            meta:set_string("is_on", "false")
            timer:stop()
        end
    end,
})

minetest.register_node("ldm32:laser_beam", {
    description = "Laser Beam",
    drawtype = "mesh",
    mesh = "ldm32_laser_beam.obj",
    tiles = {"ldm32_beam.png"},
    paramtype = "light",
    paramtype2 = "facedir",
    use_texture_alpha = true,
    --alpha = 0,
    light_source = 4,
    post_effect_color = {r=128,g=64,b=64, a=128},
    sunlight_propagates = true,
    walkable = false,
    pointable = false,
    diggable = false,
    buildable_to = true,
})

minetest.register_craft({
    --type = "sharpless",
    output = "ldm32:casing",
    recipe = {
              {"group:wood","dye:grey","default:mese_crystal"},
              {"default:steel_ingot","default:steel_ingot","default:steel_ingot"}
             }
})
