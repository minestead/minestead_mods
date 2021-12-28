--[[

	Tube Library
	============

	Copyright (C) 2017-2020 Joachim Stolberg

	AGPL v3
	See LICENSE.txt for more information

	button.lua:
	
	Example of a simple communication node, only sending messages to other nodes.

]]--

-- Load support for I18n
local S = tubelib.S

local function switch_on(pos, node)
	if tubelib.data_not_corrupted(pos, true) then
		node.name = "tubelib:button_active"
		minetest.swap_node(pos, node)
		minetest.sound_play("button", {
				pos = pos,
				gain = 0.5,
				max_hear_distance = 5,
			})
		local meta = minetest.get_meta(pos)
		local own_num = meta:get_string("own_num")
		local numbers = meta:get_string("numbers")
		local cycle_time = meta:get_int("cycle_time")
		if cycle_time > 0 then 	-- button mode?
			minetest.get_node_timer(pos):start(cycle_time)
		end
		local placer_name = meta:get_string("placer_name")
		local clicker_name = nil
		if meta:get_string("public") == "false" then
			clicker_name = meta:get_string("clicker_name")
		end
		tubelib.send_message(numbers, placer_name, clicker_name, "on", own_num)  -- <<=== tubelib
	end
end

local function switch_off(pos)
	if tubelib.data_not_corrupted(pos, true) then
		local node = minetest.get_node(pos)
		node.name = "tubelib:button"
		minetest.swap_node(pos, node)
		minetest.get_node_timer(pos):stop()
		minetest.sound_play("button", {
				pos = pos,
				gain = 0.5,
				max_hear_distance = 5,
			})
		local meta = minetest.get_meta(pos)
		local own_num = meta:get_string("own_num")
		local numbers = meta:get_string("numbers")
		local placer_name = meta:get_string("placer_name")
		local clicker_name = nil
		if meta:get_string("public") == "false" then
			clicker_name = meta:get_string("clicker_name")
		end
		tubelib.send_message(numbers, placer_name, clicker_name, "off", own_num)  -- <<=== tubelib
	end
end


minetest.register_node("tubelib:button", {
	description = S("Tubelib Button/Switch"),
	tiles = {
		-- up, down, right, left, back, front
		'tubelib_front.png',
		'tubelib_button.png',
		'tubelib_button.png',
		'tubelib_button.png',
		'tubelib_button.png',
		"tubelib_button_off.png",
	},

	after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos)
		local own_num = tubelib.add_node(pos, "tubelib:button")
		meta:set_string("own_num", own_num)
		meta:set_string("formspec", "size[7.5,6]"..
		"dropdown[0.2,0;3;type;"..S("switch,button 2s,button 4s,button 8s,button 16s")..";1]".. 
		"field[0.5,2;7,1;numbers;"..S("Insert destination node number(s)")..";]" ..
		"checkbox[1,3;public;"..S("public")..";false]"..
		"button_exit[2,4;3,1;exit;"..S("Save").."]")
		meta:set_string("placer_name", placer:get_player_name())
		meta:set_string("public", "false")
		meta:set_int("cycle_time", 0)
		meta:set_string("infotext", S("Tubelib Button").." "..own_num)
	end,

	on_receive_fields = function(pos, formname, fields, player)
		local meta = minetest.get_meta(pos)
		if tubelib.check_numbers(fields.numbers) then  -- <<=== tubelib
			meta:set_string("numbers", fields.numbers)
			local own_num = meta:get_string("own_num")
			meta:set_string("infotext", S("Tubelib Button").." "..own_num..", "..S("connected with block").." "..fields.numbers)
		else
			return
		end
		if fields.public then
			meta:set_string("public", fields.public)
		end
		local cycle_time = nil
		if fields.type == "switch" then
			cycle_time = 0
		elseif fields.type == "button 2s" then
			cycle_time = 2
		elseif fields.type == "button 4s" then
			cycle_time = 4
		elseif fields.type == "button 8s" then
			cycle_time = 8
		elseif fields.type == "button 16s" then
			cycle_time = 16
		end
		if cycle_time ~= nil then
			meta:set_int("cycle_time", cycle_time)
		end
		if fields.exit then
			meta:set_string("formspec", nil)
		end
	end,
	
	on_rightclick = function(pos, node, clicker)
		local meta = minetest.get_meta(pos)
		if meta:get_string("numbers") ~= "" and meta:get_string("numbers") ~= nil then
			meta:set_string("clicker_name", clicker:get_player_name())
			switch_on(pos, node)
		end
	end,

	on_rotate = screwdriver.disallow,
	paramtype = "light",
	sunlight_propagates = true,
	paramtype2 = "facedir",
	groups = {choppy=2, cracky=2, crumbly=2},
	is_ground_content = false,
	sounds = default.node_sound_wood_defaults(),
})


minetest.register_node("tubelib:button_active", {
	description = S("Tubelib Button/Switch"),
	tiles = {
		-- up, down, right, left, back, front
		'tubelib_front.png',
		'tubelib_button.png',
		'tubelib_button.png',
		'tubelib_button.png',
		'tubelib_button.png',
		"tubelib_button_on.png",
	},

	on_rightclick = function(pos, node, clicker)
		local meta = minetest.get_meta(pos)
		meta:set_string("clicker_name", clicker:get_player_name())
		if meta:get_int("cycle_time") == nil or meta:get_int("cycle_time") == 0 then
			switch_off(pos, node)
		end
	end,

	on_timer = switch_off,
	on_rotate = screwdriver.disallow,

	paramtype = "light",
	sunlight_propagates = true,
	paramtype2 = "facedir",
	groups = {choppy=2, cracky=2, crumbly=2, not_in_creative_inventory=1},
	is_ground_content = false,
	sounds = default.node_sound_wood_defaults(),
	drop = "tubelib:button",
})

minetest.register_craft({
	output = "tubelib:button",
	recipe = {
		{"",              "group:wood",  	    ""},
		{"default:glass", "tubelib:wlanchip",	""},
		{"",              "group:wood",  	    ""},
	},
})

