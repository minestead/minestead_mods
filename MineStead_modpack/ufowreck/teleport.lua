minetest.register_node("ufowreck:pad", {
	description = "Alien Teleport",
	tiles = {
		"scifi_nodes_pad.png",
		"scifi_nodes_pad.png",
		"scifi_nodes_pad.png",
		"scifi_nodes_pad.png",
		"scifi_nodes_pad.png",
		"scifi_nodes_pad.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	groups = {cracky=1, oddly_breakable_by_hand=1},
	light_source = 5,
	on_rightclick = function(pos, node, clicker)
		minetest.add_particlespawner(
			25, --amount
			1.5, --time
			{x=pos.x-0.9, y=pos.y-0.3, z=pos.z-0.9}, --minpos
			{x=pos.x+0.9, y=pos.y-0.3, z=pos.z+0.9}, --maxpos
			{x=0, y=0, z=0}, --minvel
			{x=0, y=0, z=0}, --maxvel
			{x=-0,y=1,z=-0}, --minacc
			{x=0,y=2,z=0}, --maxacc
			0.5, --minexptime
			1, --maxexptime
			2, --minsize
			5, --maxsize
			false, --collisiondetection
			"scifi_nodes_tp_part.png" --texture
		)
		minetest.after(1, function()
			minetest.sound_play("travelnet_travel", {pos = pos, gain = 0.75, max_hear_distance = 10,});
			clicker:setpos({ x = pos.x + math.random(-1,1)*1000, y = pos.y, z = pos.z + math.random(-1,1)*1000})
		end)
	end,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.9375, -0.5, -0.75, 0.875, -0.375, 0.75}, -- NodeBox1
			{-0.8125, -0.5, -0.875, 0.75, -0.375, 0.875}, -- NodeBox2
			{-0.875, -0.5, -0.8125, 0.8125, -0.375, 0.8125}, -- NodeBox3
			{-0.8125, -0.5, -0.75, 0.75, -0.3125, 0.75}, -- NodeBox4
		},
	sounds = default.node_sound_metal_defaults(),
	}
})

minetest.register_craft({
	output = "ufowreck:pad",
	recipe = {
	{"ufowreck:alien_metal", "ufowreck:alien_metal", "ufowreck:alien_metal"},
	{"ufowreck:alien_metal", "ufowreck:alien_control", "ufowreck:alien_metal"},
	{"ufowreck:alien_metal", "ufowreck:alien_metal", "ufowreck:alien_metal"}
  }
})
