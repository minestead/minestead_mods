--[[

	=======================================================================
	SmartLine Modules Mod
	by Micu (c) 2018, 2019

	Smartline Digilines Message Relay

	Chip that forwards communication between Digilines and Tubelib
	networks. It must be connected to Digilines network like any other
	compatible device; Tubelib side communicates wirelessly.
	Relay is a simple low level device - it forwards messages as soon as
	they appear. It has no queue or flow control - it is up to sending
	and receiving systems to limit rate of communication.
	Message Relay accepts only Tubelib messages of type "msg", so its
	main role is to talk to SaferLua Controllers or Terminals. It does
	not forward any other Tubelib commands, like "on" or "off", so it
	cannot be used to control machinery directly.
	Chip must be configured before use. Configuration can be changed at
	any time.
	Event-based node - it does not use node timer.

	Mandatory parameters:
	* Tubelib number(s) - space-separated list of Tubelib IDs
	* Digiline channel - name of Digiline channel device connects to

	Operational info:
	* Forwarding is disabled until relay chip is configured
	* Configuration can be altered at any time with immediate effect
	* Device connects to only one Digiline channel
	* Device accepts only "msg" type of Tubelib communication; other
	  packets are silently dropped
	* Data sent on Digiline channel is converted to Tubelib "msg" type
	* Digiline messages forwarded to Tubelib targets have their source
	  number set to relay device ID
	* Device rejects Tubelib messages originating from devices not
	  present on number list (security measure)
	* Relay rejects Tubelib messages that appear to come from device
	  itself (anti-spoofing)
	* Chip rejects configuration if its number appear on number list
	  (loop prevention)
	* Digilines message sent to configured channel is forwarded to all
	  Tubelib nodes on number list
	* Relay does not queue messages
	* Relay does not provide flow rate control
	* Only messages of type "string" are forwarded; Tubelib allows text
	  messages only so no conversion is necessary; Digiline numbers and
	  booleans are automatically converted to strings before being
	  dispatched to Tubelib receivers; all other data types (arrays,
	  functions etc) are silently dropped
	* Relay does not respond to any commands and status queries

	Supported SaferLua functions:
	- $send_msg(num, msg)
	- $get_msg()

	Supported Digilines functions:
	- digiline_send(channel, msg)

	License: LGPLv2.1+
	=======================================================================

]]--

if not minetest.global_exists("digilines") then
	return
end

--[[
	---------------
	Local variables
	---------------
]]--

local LABEL = "Digilines Message Relay"

--[[
	--------
	Formspec
	--------
]]--

-- configuration formspec
local function formspec(meta)
        local number = meta:get_string("own_num")
        return "size[6.9,3.6]" ..
        "label[1.9,0;" .. minetest.colorize("#FFFF00", LABEL .. " ") ..
                minetest.colorize("#00FFFF", number) .. "]" ..
        "label[0,1;Tubelib number(s)]" ..
        "field[2.5,1.1;4.5,1;numbers;;${numbers}]" ..
        "field_close_on_enter[numbers;false]" ..
        "label[0,2;Digiline channel]" ..
        "field[2.5,2.1;4.5,1;channel;;${channel}]" ..
        "field_close_on_enter[channel;false]" ..
        "button_exit[3.6,2.8;1.5,1;ok;OK]" ..
        "button_exit[5.2,2.8;1.5,1;cancel;Cancel]"
end

--[[
	-----------------
	Node registration
	-----------------
]]--

minetest.register_node("slmodules:digilinesrelay", {
	description = "SmartLine " .. LABEL,
	inventory_image = "slmodules_digilinesrelay_top.png",
	tiles = {
		-- up, down, right, left, back, front
		"slmodules_digilinesrelay_top.png",
		"slmodules_digilinesrelay_bottom.png",
		"slmodules_digilinesrelay_side.png",
		"slmodules_digilinesrelay_side.png",
		"slmodules_digilinesrelay_side.png",
		"slmodules_digilinesrelay_side.png",
	},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{ -0.5, -0.5, -0.5, 0.5, -0.4375, 0.5 },
			{ -0.375, -0.4375, -0.375, 0.375, -0.3125, 0.375 },
		}
	},
	selection_box = {
		type = "fixed",
		fixed = { -0.5, -0.5, -0.5, 0.5, -0.3125, 0.5 },
	},

	after_place_node = function(pos, placer, itemstack, pointed_thing)
		local meta = minetest.get_meta(pos)
		local number = tubelib.add_node(pos, "slmodules:digilinesrelay")
		meta:set_string("own_num", number)
		meta:set_string("infotext", LABEL .. " " ..
			number .. " (unconfigured)")
		meta:set_string("owner", placer:get_player_name())
		meta:set_string("channel", "")
		meta:set_string("numbers", "")
		meta:set_string("formspec", formspec(meta))
	end,

	can_dig = function(pos, player)
		if minetest.is_protected(pos, player:get_player_name()) then
			return false
		end
		return true
	end,

	after_dig_node = function(pos, oldnode, oldmetadata, digger)
		tubelib.remove_node(pos)
	end,

	on_receive_fields = function(pos, formname, fields, sender)
		if minetest.is_protected(pos, sender:get_player_name()) then
			return
		end
		if fields.ok then
			local meta = minetest.get_meta(pos)
			local number = meta:get_string("own_num")
			local numbers = fields.numbers and fields.numbers:trim() or ""
			local channel = fields.channel and fields.channel:trim() or ""
			if numbers == "" or channel == "" or
			   string.find(numbers, number) then
				return
			end
			numbers = string.gsub(numbers, "%s+", " ")
			meta:set_string("numbers", numbers)
			meta:set_string("channel", channel)
			meta:set_string("infotext", LABEL .. " " .. number ..
				" (channel \"" .. channel .. "\", peers: "
				.. numbers .. ")")
		end
	end,

	digiline = {
		receptor = {},
		effector = {
			action = function(pos, node, channel, msg)
				local meta = minetest.get_meta(pos)
				local owner = meta:get_string("owner")
				local number = meta:get_string("own_num")
				local numbers = meta:get_string("numbers") or ""
				local setchan = meta:get_string("channel") or ""
				if numbers == "" or setchan == "" or
				   channel ~= setchan or not msg or
				   (type(msg) ~= "boolean" and
				    type(msg) ~= "number" and
				    type(msg) ~= "string") then
					return
				end
				tubelib.send_message(numbers, owner, nil, "msg",
					{ src = number, text = tostring(msg) })
			end
		},
	},

	on_rotate = screwdriver.disallow,
	paramtype = "light",
	sunlight_propagates = true,
	paramtype2 = "facedir",
	groups = { choppy = 2, cracky = 2, crumbly = 2 },
	is_ground_content = false,
	sounds = default.node_sound_metal_defaults(),
})

tubelib.register_node("slmodules:digilinesrelay", {}, {
	on_recv_message = function(pos, topic, payload)
		if topic == "msg" then
			-- pass message to Digilines: payload = { src, text }
			local meta = minetest.get_meta(pos)
			local number = meta:get_string("own_num")
			local numbers = meta:get_string("numbers") or ""
			local channel = meta:get_string("channel") or ""
			if numbers == "" or channel == "" or
			   not payload or payload.src == number or
			   not string.find(numbers, payload.src) then
				return false
			end
			digilines.receptor_send(pos, digilines.rules.default,
				channel, payload.text)
			return true
		else
			return "unsupported"
		end
	end,
})

--[[
	--------
	Crafting
	--------
]]--

minetest.register_craft({
	output = "slmodules:digilinesrelay",
	type = "shaped",
	recipe = {
		{ "dye:blue", "default:gold_ingot", "default:copper_ingot" },
		{ "tubelib:wlanchip", "default:mese_crystal", "digilines:wire_std_00000000" },
		{ "default:steel_ingot", "group:sand", "default:steel_ingot" },
	},
})
