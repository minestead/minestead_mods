minetest.register_craft({
	output = 'flint:flint_block',
	recipe = {
		{'default:flint', 'default:flint', 'default:flint'},
		{'default:flint', 'default:flint', 'default:flint'},
		{'default:flint', 'default:flint', 'default:flint'},
	}
})

minetest.register_craft({
	output = 'flint:flint_block_compressed',
	recipe = {
		{'flint:flint_block', 'flint:flint_block', 'flint:flint_block'},
		{'flint:flint_block', 'flint:flint_block', 'flint:flint_block'},
		{'flint:flint_block', 'flint:flint_block', 'flint:flint_block'},
	}
})

minetest.register_craft({
	output = 'flint:flint_block_condensed',
	recipe = {
		{'flint:flint_block_compressed', 'flint:flint_block_compressed', 'flint:flint_block_compressed'},
		{'flint:flint_block_compressed', 'flint:flint_block_compressed', 'flint:flint_block_compressed'},
		{'flint:flint_block_compressed', 'flint:flint_block_compressed', 'flint:flint_block_compressed'},
	}
})

minetest.register_craft({
	output = 'default:flint 9',
	recipe = {
		{'flint:flint_block'},
	}
})

minetest.register_craft({
	output = 'flint:flint_block 9',
	recipe = {
		{'flint:flint_block_compressed'},
	}
})

minetest.register_craft({
	output = 'flint:flint_block_compressed 9',
	recipe = {
		{'flint:flint_block_condensed'},
	}
})

minetest.register_craft({
    output = 'flint:flint_smooth 4',
    recipe = {
        {'flint:flint_block', 'flint:flint_block'},
        {'flint:flint_block', 'flint:flint_block'}
    }
})

minetest.register_craft({
    output = 'flint:flint_bricks 4',
    recipe = {
        {'flint:flint_smooth', 'flint:flint_smooth'},
        {'flint:flint_smooth', 'flint:flint_smooth'}
    }
})

minetest.register_craft({
    output = 'flint:flint_block 4',
    recipe = {
        {'flint:flint_bricks', 'flint:flint_bricks'},
        {'flint:flint_bricks', 'flint:flint_bricks'}
    }
})

minetest.register_craft({
    output = 'flint:flint_steel_block 4',
    recipe = {
        {'default:steelblock','flint:flint_block' },
        {'flint:flint_block', 'default:steelblock'}
    }
})

if fire ~= nil then
    minetest.register_craft({
        output = 'flint:flint_steel_block',
        recipe = {
            {'fire:flint_and_steel', 'fire:flint_and_steel', 'fire:flint_and_steel'},
            {'fire:flint_and_steel', 'fire:flint_and_steel', 'fire:flint_and_steel'},
            {'fire:flint_and_steel', 'fire:flint_and_steel', 'fire:flint_and_steel'},

        }
    })

    minetest.register_craft({
        output = 'fire:flint_and_steel 9',
        recipe = {
            {'flint:flint_steel_block'}

        }
    })
end