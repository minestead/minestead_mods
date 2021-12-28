--[[

	sl_controller
	=============

	Copyright (C) 2017-2020 Joachim Stolberg

	AGPL v3
	See LICENSE.txt for more information

	controller.lua:

]]--

-- for lazy programmers
local S = function(pos) if pos then return minetest.pos_to_string(pos) end end
local M = minetest.get_meta

local sHELP = [[SaferLua Controller

 This controller is used to control and monitor 
 Tubelib/TechPack machines.
 This controller can be programmed in Lua.
 
 See on GitHub for more help: goo.gl/Et8D6n

 The controller only runs, if a battery is 
 placed nearby.
 
]]

local Cache = {}

local tCommands = {}
local tFunctions = {" Overview", " Data structures"}
local tHelpTexts = {[" Overview"] = sHELP, [" Data structures"] = safer_lua.DataStructHelp}
local sFunctionList = ""
local tFunctionIndex = {}

minetest.after(2, function() 
	sFunctionList = table.concat(tFunctions, ",") 
	for idx,key in ipairs(tFunctions) do
		tFunctionIndex[key] = idx
	end
end)

local function output(pos, text)
	local meta = minetest.get_meta(pos)
	text = meta:get_string("output") .. "\n" .. (text or "")
	text = text:sub(-500,-1)
	meta:set_string("output", text)
end

--
-- API functions for function/action registrations
--
function sl_controller.register_function(key, attr)
	tCommands[key] = attr.cmnd
	table.insert(tFunctions, " $"..key)
	tHelpTexts[" $"..key] = attr.help
end

function sl_controller.register_action(key, attr)
	tCommands[key] = attr.cmnd
	table.insert(tFunctions, " $"..key)
	tHelpTexts[" $"..key] = attr.help
end

local function merge(dest, keys, values)
  for idx,key in ipairs(keys) do
    dest.env[key] = values[idx]
  end
  return dest
end

sl_controller.register_action("print", {
	cmnd = function(self, text1, text2, text3)
		local pos = self.meta.pos
		text1 = tostring(text1 or "")
		text2 = tostring(text2 or "")
		text3 = tostring(text3 or "")
		output(pos, text1..text2..text3)
	end,
	help = " $print(text,...)\n"..
		" Send a text line to the output window.\n"..
		" The function accepts up to 3 text strings\n"..
		' e.g. $print("Hello ", name, " !")'
})

sl_controller.register_action("loopcycle", {
	cmnd = function(self, cycletime)
		cycletime = math.floor(tonumber(cycletime) or 0)
		local meta = minetest.get_meta(self.meta.pos)
		meta:set_int("cycletime", cycletime)
		meta:set_int("cyclecount", 0)
	end,
	help = "$loopcycle(seconds)\n"..
		" This function allows to change the\n"..
		" call frequency of the loop() function.\n"..
		" value is in seconds, 0 = disable\n"..
		' e.g. $loopcycle(10)'
})

sl_controller.register_action("events", {
	cmnd = function(self, event)
		self.meta.events = event or false
	end,
	help = "$events(true/false)\n"..
		" Enable/disable event handling.\n"..
		' e.g. $events(true) -- enable events'
})

sl_controller.register_function("get_ms_time", {
	cmnd = function(self)
		return math.floor(minetest.get_us_time() / 1000)
	end,
	help = "$get_ms_time()\n"..
		" returns time with millisecond precision."
})

sl_controller.register_function("position", {
	cmnd = function(self, number)
		local info = tubelib.get_node_info(number)
		if info then
			return S(info.pos)
		end
		return "(-,-,-)"
	end,
	help = "$position(number)\n"..
		" returns the position '(x,y,z)' of the device\n with given number."
})

sl_controller.register_action("battery", {
	cmnd = function(self)
		local meta = minetest.get_meta(self.meta.pos)
		local batpos = minetest.string_to_pos(meta:get_string("battery"))
		local batmeta = minetest.get_meta(batpos)
		local val = (sl_controller.battery_capacity -
			math.min(batmeta:get_int("content") or 0,
				sl_controller.battery_capacity))
		return 100 - math.floor((val * 100.0 / sl_controller.battery_capacity))
	end,
	help =  " $battery()\n"..
		" Get charge level of battery connected to Controller.\n"..
		" Function returns percent number (0-100) where 100 means full.\n"..
		" example: battery_percent = $battery()"
})


local function formspec0(meta)
	local state = meta:get_int("state") == tubelib.RUNNING
	local cmnd = state and "stop;Stop" or "start;Start"
	local init = meta:get_string("init")
	init = minetest.formspec_escape(init)
	return "size[4,3]"..
	default.gui_bg..
	default.gui_bg_img..
	default.gui_slots..
	"label[0,0;No Battery?]"..
	"button[1,2;1.8,1;start;Start]"
end

local function formspec1(meta)
	local state = meta:get_int("state") == tubelib.RUNNING
	local cmnd = state and "stop;Stop" or "start;Start"
	local init = meta:get_string("init")
	init = minetest.formspec_escape(init)
	return "size[10,8]"..
	default.gui_bg..
	default.gui_bg_img..
	default.gui_slots..
	"tabheader[0,0;tab;init,func,loop,outp,notes,help;1;;true]"..
	"textarea[0.3,0.2;10,8.3;init;function init();"..init.."]"..
	"label[0,7.3;end]"..
	"button_exit[4.4,7.5;1.8,1;cancel;Cancel]"..
	"button[6.3,7.5;1.8,1;save;Save]"..
	"button[8.2,7.5;1.8,1;"..cmnd.."]"
end

local function formspec2(meta)
	local state = meta:get_int("state") == tubelib.RUNNING
	local cmnd = state and "stop;Stop" or "start;Start"
	local func = meta:get_string("func")
	func = minetest.formspec_escape(func)
	return "size[10,8]"..
	default.gui_bg..
	default.gui_bg_img..
	default.gui_slots..
	"tabheader[0,0;tab;init,func,loop,outp,notes,help;2;;true]"..
	"textarea[0.3,0.2;10,8.3;func;functions:;"..func.."]"..
	"button_exit[4.4,7.5;1.8,1;cancel;Cancel]"..
	"button[6.3,7.5;1.8,1;save;Save]"..
	"button[8.2,7.5;1.8,1;"..cmnd.."]"
end

local function formspec3(meta)
	local state = meta:get_int("state") == tubelib.RUNNING
	local cmnd = state and "stop;Stop" or "start;Start"
	local loop = meta:get_string("loop")
	loop = minetest.formspec_escape(loop)
	return "size[10,8]"..
	default.gui_bg..
	default.gui_bg_img..
	default.gui_slots..
	"tabheader[0,0;tab;init,func,loop,outp,notes,help;3;;true]"..
	"textarea[0.3,0.2;10,8.3;loop;function loop(ticks, elapsed);"..loop.."]"..
	"label[0,7.3;end]"..
	"button_exit[4.4,7.5;1.8,1;cancel;Cancel]"..
	"button[6.3,7.5;1.8,1;save;Save]"..
	"button[8.2,7.5;1.8,1;"..cmnd.."]"
end

local function formspec4(meta)
	local state = meta:get_int("state") == tubelib.RUNNING
	local cmnd = state and "stop;Stop" or "start;Start"
	local output = meta:get_string("output")
	output = minetest.formspec_escape(output)
	output = output:gsub("\n", ",")
	return "size[10,8]"..
	default.gui_bg..
	default.gui_bg_img..
	default.gui_slots..
	"tabheader[0,0;tab;init,func,loop,outp,notes,help;4;;true]"..
	"table[0.2,0.2;9.5,7;output;"..output..";200]"..
	"button[4.4,7.5;1.8,1;clear;Clear]"..
	"button[6.3,7.5;1.8,1;update;Update]"..
	"button[8.2,7.5;1.8,1;"..cmnd.."]"
end

local function formspec5(meta)
	local notes = meta:get_string("notes")
	notes = minetest.formspec_escape(notes)
	return "size[10,8]"..
	default.gui_bg..
	default.gui_bg_img..
	default.gui_slots..
	"tabheader[0,0;tab;init,func,loop,outp,notes,help;5;;true]"..
	"textarea[0.3,0.2;10,8.3;notes;Notepad:;"..notes.."]"..
	"button_exit[6.3,7.5;1.8,1;cancel;Cancel]"..
	"button[8.2,7.5;1.8,1;save;Save]"
end

local function formspec6(items, pos, text)
	text = minetest.formspec_escape(text)
	return "size[10,8]"..
	default.gui_bg..
	default.gui_bg_img..
	default.gui_slots..
	"tabheader[0,0;tab;init,func,loop,outp,notes,help;6;;true]"..
	"label[0,-0.2;Functions:]"..
	"dropdown[0.3,0.2;10,8.3;functions;"..items..";"..pos.."]"..
	"textarea[0.3,1.3;10,8;help;Help:;"..text.."]"
end

local function patch_error_string(err, line_offs)
	local tbl = {}
	for s in err:gmatch("[^\r\n]+") do
		if s:find("loop:(%d+):") then
			local prefix, line, err = s:match("(.-)loop:(%d+):(.+)")
			if prefix and line and err then
				if tonumber(line) < line_offs then
					table.insert(tbl, prefix.."func:"..line..":"..err)
				else
					line = tonumber(line) - line_offs
					table.insert(tbl, prefix.."loop:"..line..":"..err)
				end
			end
		else
			table.insert(tbl, s)
		end
	end    
	return table.concat(tbl, "\n")
end

local function error(pos, err)
	local meta = minetest.get_meta(pos)
	local func = meta:get_string("func")
	local _,line_offs = string.gsub(func, "\n", "\n")
	line_offs = line_offs + 1
	err = patch_error_string(err, line_offs)
	output(pos, err)
	local number = meta:get_string("number")
	meta:set_string("infotext", "Controller "..number..": error")
	meta:set_int("state", tubelib.STOPPED)
	meta:set_int("running", tubelib.STATE_STOPPED)
	meta:set_string("formspec", formspec4(meta))
	minetest.get_node_timer(pos):stop()
	return false
end

local function compile(pos, meta, number)
	local init = meta:get_string("init")
	local func = meta:get_string("func")
	local loop = meta:get_string("loop")
	local owner = meta:get_string("owner")
	local env = table.copy(tCommands)
	env.meta = {pos=pos, owner=owner, number=number, error=error}
	local code = safer_lua.init(pos, init, func.."\n"..loop, env, error)
	
	if code then
		Cache[number] = {code=code, inputs={}, events=env.meta.events}
		Cache[number].inputs.term = nil  -- terminal inputs
		Cache[number].inputs.msg = {}  -- message queue
		return true
	end
	return false
end

local function battery(pos)
	local battery_pos = minetest.find_node_near(pos, 1, {"sl_controller:battery", "smartline:battery"})
	if battery_pos then
		local meta = minetest.get_meta(pos)
		meta:set_string("battery", minetest.pos_to_string(battery_pos))
		return true
	end
	return false
end	

local function start_controller(pos)
	local meta = minetest.get_meta(pos)
	local number = meta:get_string("number")
	if not battery(pos) then
		meta:set_string("formspec", formspec0(meta))
		return false
	end
	
	meta:set_string("output", "<press update>")
	meta:set_int("cycletime", 1)
	meta:set_int("cyclecount", 0)
	meta:set_int("cpu", 0)
	
	if compile(pos, meta, number) then
		meta:set_int("state", tubelib.RUNNING)
		meta:set_int("running", tubelib.STATE_RUNNING)
		minetest.get_node_timer(pos):start(1)
		meta:set_string("formspec", formspec4(meta))
		meta:set_string("infotext", "Controller "..number..": running")
		return true
	end
	return false
end

local function stop_controller(pos)
	local meta = minetest.get_meta(pos)
	local number = meta:get_string("number")
	meta:set_int("state", tubelib.STOPPED)
	meta:set_int("running", tubelib.STATE_STOPPED)
	minetest.get_node_timer(pos):stop()
	meta:set_string("infotext", "Controller "..number..": stopped")
	meta:set_string("formspec", formspec3(meta))
end

local function no_battery(pos)
	local meta = minetest.get_meta(pos)
	local number = meta:get_string("number")
	meta:set_int("state", tubelib.STOPPED)
	meta:set_int("running", tubelib.STATE_STOPPED)
	minetest.get_node_timer(pos):stop()
	meta:set_string("infotext", "Controller "..number..": No battery")
	meta:set_string("formspec", formspec0(meta))
end

local function update_battery(meta, cpu)
	local pos = minetest.string_to_pos(meta:get_string("battery"))
	if pos then
		meta = minetest.get_meta(pos)
		local content = meta:get_int("content") - cpu
		if content <= 0 then
			meta:set_int("content", 0)
			return false
		end
		meta:set_int("content", content)
		return true
	end
end

local function call_loop(pos, meta, elapsed)
	local t = minetest.get_us_time()
	local number = meta:get_string("number")
	if Cache[number] or compile(pos, meta, number) then
		local cpu = meta:get_int("cpu") or 0
		local code = Cache[number].code
		local res = safer_lua.run_loop(pos, elapsed, code, error)
		if res then 
			t = minetest.get_us_time() - t
			cpu = math.floor(((cpu * 20) + t) / 21)
			meta:set_int("cpu", cpu)
			meta:set_string("infotext", "Controller "..number..": running ("..cpu.."us)")
			if not update_battery(meta, cpu) then
				no_battery(pos)
				return false
			end
		end
		-- further messages available?
		if next(Cache[number].inputs["msg"]) then
			minetest.after(1, call_loop, pos, meta, -1)
		end
		return res
	end
	return false
end

local function on_timer(pos, elapsed)
	local meta = minetest.get_meta(pos)
	-- considering cycle frequency
	local cycletime = meta:get_int("cycletime") or 1
	local cyclecount = (meta:get_int("cyclecount") or 0) + 1
	if cycletime == 0 or cyclecount < cycletime then
		meta:set_int("cyclecount", cyclecount)
		return true
	end
	meta:set_int("cyclecount", 0)

	return call_loop(pos, meta, elapsed)
end

local function on_receive_fields(pos, formname, fields, player)
	if minetest.is_protected(pos, player:get_player_name()) then
		return
	end
	local meta = minetest.get_meta(pos)
	
	--print(dump(fields))
	if fields.cancel == nil then
		if fields.init then
			meta:set_string("init", fields.init)
			meta:set_string("formspec", formspec1(meta))
		elseif fields.func then
			meta:set_string("func", fields.func)
			meta:set_string("formspec", formspec2(meta))
		elseif fields.loop then
			meta:set_string("loop", fields.loop)
			meta:set_string("formspec", formspec3(meta))
		elseif fields.notes then
			meta:set_string("notes", fields.notes)
			meta:set_string("formspec", formspec5(meta))
		end	
	end
	
	if fields.update then
		meta:set_string("formspec", formspec4(meta))
	elseif fields.clear then
		meta:set_string("output", "<press update>")
		meta:set_string("formspec", formspec4(meta))
	elseif fields.tab == "1" then
		meta:set_string("formspec", formspec1(meta))
	elseif fields.tab == "2" then
		meta:set_string("formspec", formspec2(meta))
	elseif fields.tab == "3" then
		meta:set_string("formspec", formspec3(meta))
	elseif fields.tab == "4" then
		meta:set_string("formspec", formspec4(meta))
	elseif fields.tab == "5" then
		meta:set_string("formspec", formspec5(meta))
	elseif fields.tab == "6" then
		meta:set_string("formspec", formspec6(sFunctionList, 1, sHELP))
	elseif fields.start == "Start" then
		start_controller(pos)
		minetest.log("action", player:get_player_name() ..
			" starts the sl_controller at ".. minetest.pos_to_string(pos))
	elseif fields.stop == "Stop" then
		stop_controller(pos)
	elseif fields.functions then
		local key = fields.functions
		local text = tHelpTexts[key] or ""
		local pos = tFunctionIndex[key] or 1
		meta:set_string("formspec", formspec6(sFunctionList, pos, text))
	end
end

minetest.register_node("sl_controller:controller", {
	description = "SaferLua Controller",
	inventory_image = "sl_controller_inventory.png",
	wield_image = "sl_controller_inventory.png",
	stack_max = 1,
	tiles = {
		-- up, down, right, left, back, front
		"smartline.png",
		"smartline.png",
		"smartline.png",
		"smartline.png",
		"smartline.png",
		"smartline.png^sl_controller.png",
	},

	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{ -6/32, -6/32, 14/32,  6/32,  6/32, 16/32},
		},
	},
	
	after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos)
		local number = tubelib.add_node(pos, "sl_controller:controller")
		meta:set_string("owner", placer:get_player_name())
		meta:set_string("number", number)
		meta:set_int("state", tubelib.STOPPED)
		meta:set_int("running", tubelib.STATE_STOPPED)
		meta:set_string("init", "-- called only once")
		meta:set_string("func", "-- for your functions")
		meta:set_string("loop", "-- called every second")
		meta:set_string("notes", "For your notes / snippets")
		meta:mark_as_private("init")
		meta:mark_as_private("func")
		meta:mark_as_private("loop")
		meta:mark_as_private("notes")
		meta:set_string("formspec", formspec1(meta))
		meta:set_string("infotext", "Controller "..number..": stopped")
	end,

	on_receive_fields = on_receive_fields,
	
	on_dig = function(pos, node, puncher, pointed_thing)
		if minetest.is_protected(pos, puncher:get_player_name()) then
			return
		end
		
		minetest.node_dig(pos, node, puncher, pointed_thing)
		tubelib.remove_node(pos)
	end,
	
	on_timer = on_timer,
	
	paramtype = "light",
	sunlight_propagates = true,
	paramtype2 = "facedir",
	groups = {choppy=1, cracky=1, crumbly=1},
	is_ground_content = false,
	sounds = default.node_sound_stone_defaults(),
})


minetest.register_craft({
	type = "shapeless",
	output = "sl_controller:controller",
	recipe = {"smartline:controller2"}
})

-- write inputs from remote nodes
local function set_input(pos, number, input, val)
	if input and M(pos):get_int("state") == tubelib.RUNNING then 
		if (Cache[number] or compile(pos, M(pos), number)) and Cache[number].inputs then
			if input == "msg" then
				if #Cache[number].inputs["msg"] < 10 then
					table.insert(Cache[number].inputs["msg"], val)
				end
			else
				Cache[number].inputs[input] = val
			end
			if Cache[number].events then  -- events enabled?
				-- only one event per second
				local t = minetest.get_us_time()
				 if not Cache[number].last_event or Cache[number].last_event < t then
					local meta = minetest.get_meta(pos)
					minetest.after(0.01, call_loop, pos, meta, -1)
					Cache[number].last_event = t + 500000 -- add 500 ms
				end
			end
		end
	end
end	

-- used by the command "input"
function sl_controller.get_input(number, input)
	if input then 
		if Cache[number] and Cache[number].inputs then
			return Cache[number].inputs[input] or "off"
		end
	end
	return "off"
end	

-- used for Terminal commands
function sl_controller.get_command(number)
	if Cache[number] and Cache[number].inputs then
		local cmnd = Cache[number].inputs["term"]
		Cache[number].inputs["term"] = nil
		return cmnd
	end
end	

-- used for queued messages
function sl_controller.get_msg(number)
	if Cache[number] and Cache[number].inputs then
		return table.remove(Cache[number].inputs["msg"], 1)
	end
end	

tubelib.register_node("sl_controller:controller", {}, {
	on_recv_message = function(pos, topic, payload)
		local meta = minetest.get_meta(pos)
		local number = meta:get_string("number")
		
		if topic == "on" then
			set_input(pos, number, payload, topic)
		elseif topic == "off" then
			set_input(pos, number, payload, topic)
		elseif topic == "term" then
			set_input(pos, number, "term", payload)
		elseif topic == "msg" then
			set_input(pos, number, "msg", payload)
		elseif topic == "state" then
			local running = meta:get_int("running") or tubelib.STATE_STOPPED
			return tubelib.statestring(running)
		else
			return "unsupported"
		end
	end,
	on_node_load = function(pos)
		local meta = minetest.get_meta(pos)
		if meta:get_int("running") ~= tubelib.STATE_STOPPED then
			minetest.get_node_timer(pos):start(1)
		end
	end,
})		
