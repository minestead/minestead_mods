minetest.register_node('flint:flint_block', {
	description = 'Flint Block',
	tiles = {'flint_block.png'},
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node('flint:flint_block_compressed', {
	description = 'Compressed Flint Block',
	tiles = {'flint_block_compressed.png'},
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node('flint:flint_block_condensed', {
	description = 'Condensed Flint Block',
	tiles = {'flint_block_condensed.png'},
    groups = {cracky=3},
    stack_max = 999,
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node('flint:flint_bricks', {
	description = 'Flint Bricks',
	tiles = {'flint_bricks.png'},
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node('flint:flint_smooth', {
	description = 'Smooth Flint Block',
	tiles = {'flint_smooth.png'},
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
})


if fire == nil then
    minetest.register_node('flint:flint_steel_block', {
        description = 'Flint And Steel Block',
        tiles = {'flint_steel_block.png'},
        groups = {cracky=3},
        sounds = default.node_sound_stone_defaults(),
    })
else
    minetest.register_node('flint:flint_steel_block', {
        description = 'Flint And Steel Block',
        tiles = {'flint_steel_block.png'},
        groups = {cracky=3},
        sounds = default.node_sound_stone_defaults(),
        on_punch = function(pos, node, player, pointed_thing)
            if minetest.get_node(pointed_thing.above).name ==  "air" then
                minetest.set_node(pointed_thing.above,{name='fire:basic_flame'})
            end
        end,
        on_rightclick = function(pos, node, player, itemstack, pointed_thing)
            if minetest.get_node(pointed_thing.above).name ==  "air" then
                minetest.set_node(pointed_thing.above,{name='fire:basic_flame'})
            end
        end
    })
end
