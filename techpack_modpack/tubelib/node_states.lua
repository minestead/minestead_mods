--[[

	Tube Library
	============

	Copyright (C) 2017-2020 Joachim Stolberg

	AGPL v3
	See LICENSE.txt for more information

	node_states.lua:

	A state model/class for tubelib nodes.

]]--


--[[ 

Node states:

        +-----------------------------------+    +------------+
        |                                   |    |            |                                      
        |                                   V    V            |                                      
        |                                +---------+          |                                      
        |                                |         |          |                                      
        |                      +---------| STOPPED |          |                                      
        |                      |         |         |          |                                      
        |               button |         +---------+          |                                      
        |                      |              ^               |                                      
 repair |                      V              | button        |                                      
        |                 +---------+         |               | button                               
        |                 |         |---------+               |                                      
        |                 | RUNNING |                         |                                      
        |        +--------|         |---------+               |                                      
        |        |        +---------+         |               |                                      
        |        |           ^    |           |               |                                      
        |        |           |    |           |               |                                      
        |        V           |    V           V               |                                      
        |   +---------+   +----------+   +---------+          |                                      
        |   |         |   |          |   |         |          |                                      
        +---| DEFECT  |   | STANDBY/ |   |  FAULT  |----------+                                      
            |         |   | BLOCKED  |   |         |                                                 
            +---------+   +----------+   +---------+                                                 

Node metadata:
	"tubelib_number"     - string with tubelib number, like "0123"
	"tubelib_state"      - node state, like "RUNNING"
	"tubelib_item_meter" - node item/runtime counter
	"tubelib_countdown"  - countdown to stadby mode
	"tubelib_aging"      - aging counter
]]--

-- for lazy programmers
local S = function(pos) if pos then return minetest.pos_to_string(pos) end end
local P = minetest.string_to_pos
local M = minetest.get_meta


local AGING_FACTOR = 4  -- defect random factor

--
-- Local States
--
local STOPPED = tubelib.STOPPED
local RUNNING = tubelib.RUNNING
local STANDBY = tubelib.STANDBY
local FAULT   = tubelib.FAULT
local BLOCKED = tubelib.BLOCKED
local DEFECT  = tubelib.DEFECT


--
-- NodeStates Class Functions
--
tubelib.NodeStates = {}
local NodeStates = tubelib.NodeStates

local function start_condition_fullfilled(pos, meta)
	return true
end

function NodeStates:new(attr)
	local o = {
		-- mandatory
		cycle_time = attr.cycle_time, -- for running state
		first_cycle_time = attr.first_cycle_time, -- for first run, not required
		standby_ticks = attr.standby_ticks, -- for standby state
		has_item_meter = attr.has_item_meter, -- true/false
		-- optional
		node_name_passive = attr.node_name_passive,
		node_name_active = attr.node_name_active, 
		node_name_defect = attr.node_name_defect,
		infotext_name = attr.infotext_name,
		start_condition_fullfilled = attr.start_condition_fullfilled or start_condition_fullfilled,
		on_start = attr.on_start,
		on_stop = attr.on_stop,
		formspec_func = attr.formspec_func,
	}
	if attr.aging_factor then
		o.aging_level1 = attr.aging_factor * tubelib.machine_aging_value
		o.aging_level2 = attr.aging_factor * tubelib.machine_aging_value * AGING_FACTOR
	end
	setmetatable(o, self)
	self.__index = self
	return o
end

function NodeStates:node_init(pos, number)
	local meta = M(pos)
	meta:set_int("tubelib_state", STOPPED)
	meta:set_string("tubelib_number", number)
	if self.infotext_name then
		meta:set_string("infotext", self.infotext_name.." "..number..": stopped")
	end
	if self.has_item_meter then
		meta:set_int("tubelib_item_meter", 0)
	end
	if self.aging_level1 then
		meta:set_int("tubelib_aging", 0)
	end
	if self.formspec_func then
		meta:set_string("formspec", self.formspec_func(self, pos, meta))
	end
end

function NodeStates:stop(pos, meta)
	local state = meta:get_int("tubelib_state")
	if state ~= DEFECT then
		if self.on_stop then
			self.on_stop(pos, meta, state)
		end
		meta:set_int("tubelib_state", STOPPED)
		if self.node_name_passive then
			local node = minetest.get_node(pos)
			node.name = self.node_name_passive
			minetest.swap_node(pos, node)
		end
		if self.infotext_name then
			local number = meta:get_string("tubelib_number")
			meta:set_string("infotext", self.infotext_name.." "..number..": stopped")
		end
		if self.formspec_func then
			meta:set_string("formspec", self.formspec_func(self, pos, meta))
		end
		minetest.get_node_timer(pos):stop()
		return true
	end
	return false
end

function NodeStates:start(pos, meta, called_from_on_timer)
	local state = meta:get_int("tubelib_state")
	if state == STOPPED or state == STANDBY or state == BLOCKED then
		if not self.start_condition_fullfilled(pos, meta) then
			return false
		end
		if self.on_start then
			self.on_start(pos, meta, state)
		end
		meta:set_int("tubelib_state", RUNNING)
		meta:set_int("tubelib_countdown", 4)
		if called_from_on_timer then
			-- timer has to be stopped once to be able to be restarted
			self.stop_timer = true
		end
		if self.node_name_active then
			local node = minetest.get_node(pos)
			node.name = self.node_name_active
			minetest.swap_node(pos, node)
		end
		if self.infotext_name then
			local number = meta:get_string("tubelib_number")
			meta:set_string("infotext", self.infotext_name.." "..number..": running")
		end
		if self.formspec_func then
			meta:set_string("formspec", self.formspec_func(self, pos, meta))
		end
		local cycle_time = self.cycle_time
		if self.first_cycle_time then
			if meta:get_int("tubelib_first_run") == 1 then
				meta:set_int("tubelib_first_run", 0)
				cycle_time = self.cycle_time
			else
				meta:set_int("tubelib_first_run", 1)
				cycle_time = self.first_cycle_time
			end
		end
		minetest.get_node_timer(pos):start(cycle_time)
		return true
	end
	if self.first_cycle_time and meta:get_int("tubelib_first_run") == 1 then
		local cycle_time = self.cycle_time
		local timer = minetest.get_node_timer(pos)
		minetest.after(0, function ()
			timer:set(cycle_time, timer:get_elapsed())
		end)
		meta:set_int("tubelib_first_run", 0)
	end
	return false
end

function NodeStates:standby(pos, meta)
	if meta:get_int("tubelib_state") == RUNNING then
		meta:set_int("tubelib_state", STANDBY)
		-- timer has to be stopped once to be able to be restarted
		self.stop_timer = true
		if self.node_name_passive then
			local node = minetest.get_node(pos)
			node.name = self.node_name_passive
			minetest.swap_node(pos, node)
		end
		if self.infotext_name then
			local number = meta:get_string("tubelib_number")
			meta:set_string("infotext", self.infotext_name.." "..number..": standby")
		end
		if self.formspec_func then
			meta:set_string("formspec", self.formspec_func(self, pos, meta))
		end
		minetest.get_node_timer(pos):start(self.cycle_time * self.standby_ticks)
		return true
	end
	return false
end	

-- special case of standby for pushing nodes
function NodeStates:blocked(pos, meta)
	if meta:get_int("tubelib_state") == RUNNING then
		meta:set_int("tubelib_state", BLOCKED)
		-- timer has to be stopped once to be able to be restarted
		self.stop_timer = true
		if self.node_name_passive then
			local node = minetest.get_node(pos)
			node.name = self.node_name_passive
			minetest.swap_node(pos, node)
		end
		if self.infotext_name then
			local number = meta:get_string("tubelib_number")
			meta:set_string("infotext", self.infotext_name.." "..number..": blocked")
		end
		if self.formspec_func then
			meta:set_string("formspec", self.formspec_func(self, pos, meta))
		end
		minetest.get_node_timer(pos):start(self.cycle_time * self.standby_ticks)
		return true
	end
	return false
end	

function NodeStates:fault(pos, meta)
	if meta:get_int("tubelib_state") == RUNNING then
		meta:set_int("tubelib_state", FAULT)
		if self.node_name_passive then
			local node = minetest.get_node(pos)
			node.name = self.node_name_passive
			minetest.swap_node(pos, node)
		end
		if self.infotext_name then
			local number = meta:get_string("tubelib_number")
			meta:set_string("infotext", self.infotext_name.." "..number..": fault")
		end
		if self.formspec_func then
			meta:set_string("formspec", self.formspec_func(self, pos, meta))
		end
		minetest.get_node_timer(pos):stop()
		return true
	end
	return false
end	

function NodeStates:defect(pos, meta)
	meta:set_int("tubelib_state", DEFECT)
	if self.node_name_defect then
		local node = minetest.get_node(pos)
		node.name = self.node_name_defect
		minetest.swap_node(pos, node)
	end
	if self.infotext_name then
		local number = meta:get_string("tubelib_number")
		meta:set_string("infotext", self.infotext_name.." "..number..": defect")
	end
	if self.formspec_func then
		meta:set_string("formspec", self.formspec_func(self, pos, meta))
	end
	minetest.get_node_timer(pos):stop()
	return true
end	

function NodeStates:get_state(meta)
	return meta:get_int("tubelib_state")
end

function NodeStates:get_state_string(meta)
	return tubelib.StateStrings[meta:get_int("tubelib_state")]
end

function NodeStates:is_active(meta)
	local state = meta:get_int("tubelib_state")
	if self.stop_timer == true then
		self.stop_timer = false
		return false
	end
	return state == RUNNING or state == STANDBY or state == BLOCKED
end

-- To be called if node is idle.
-- If countdown reaches zero, the node is set to STANDBY.
function NodeStates:idle(pos, meta)
	local countdown = meta:get_int("tubelib_countdown") - 1
	meta:set_int("tubelib_countdown", countdown)
	if countdown < 0 then
		self:standby(pos, meta)
	end
end

-- To be called after successful node action to raise the timer
-- and keep the node in state RUNNING
function NodeStates:keep_running(pos, meta, val, num_items)
	if not num_items or num_items < 1 then num_items = 1 end
	-- set to RUNNING if not already done
	self:start(pos, meta, true)
	meta:set_int("tubelib_countdown", val)
	meta:set_int("tubelib_item_meter", meta:get_int("tubelib_item_meter") + (num_items or 1))
		
	if self.aging_level1 then
		local cnt = meta:get_int("tubelib_aging") + num_items
		meta:set_int("tubelib_aging", cnt)
		if (cnt > (self.aging_level1) and math.random(math.max(1, math.floor(self.aging_level2/num_items))) == 1)
		or cnt >= 999999 then
			self:defect(pos, meta)
		end
	end
end

-- Start/stop node based on button events.
-- if function returns false, no button was pressed
function NodeStates:state_button_event(pos, fields)
	if fields.state_button ~= nil then
		local state = self:get_state(M(pos))
		if state == STOPPED or state == STANDBY or state == BLOCKED then
			self:start(pos, M(pos))
		elseif state == RUNNING or state == FAULT then
			self:stop(pos, M(pos))
		end
		return true
	end
	return false
end

function NodeStates:get_state_button_image(meta)
	local state = meta:get_int("tubelib_state")
	return tubelib.state_button(state)
end

-- command interface
function NodeStates:on_receive_message(pos, topic, payload)
	if topic == "on" then
		self:start(pos, M(pos))
		return true
	elseif topic == "off" then
		self:stop(pos, M(pos))
		return true
	elseif topic == "state" then
		local node = minetest.get_node(pos)
		if node.name == "ignore" then  -- unloaded node?
			return "blocked"
		end
		return self:get_state_string(M(pos))
	elseif self.has_item_meter and topic == "counter" then
		return M(pos):get_int("tubelib_item_meter")
	elseif self.has_item_meter and topic == "clear_counter" then
		M(pos):set_int("tubelib_item_meter", 0)
		return true
	elseif self.aging_level1 and topic == "aging" then
		return M(pos):get_int("tubelib_aging")
	end
end
	
-- repair corrupt node data and/or migrate node to state2
function NodeStates:on_node_load(pos, not_start_timer)
	local meta = minetest.get_meta(pos)
	
	-- legacy node number/state/counter?
	local number = meta:get_string("number")
	if number ~= "" and number ~= nil then
		meta:set_string("tubelib_number", number)
		meta:set_int("tubelib_state", tubelib.state(meta:get_int("running")))
		if self.has_item_meter then
			meta:set_int("tubelib_item_meter", meta:get_int("counter"))
		end
		if self.aging_level1 then
			meta:set_int("tubelib_aging", 0)
		end
		meta:set_string("number", nil)
		meta:set_int("running", 0)
		meta:set_int("counter", 0)
	end

	-- node corrupt?
	if not tubelib.data_not_corrupted(pos) then
		return
	end
	
	-- state corrupt?
	local state = meta:get_int("tubelib_state")
	if state == 0 then
		if minetest.get_node_timer(pos):is_started() then
			meta:set_int("tubelib_state", RUNNING)
		else
			meta:set_int("tubelib_state", STOPPED)
		end
	elseif state == RUNNING and not not_start_timer then
		minetest.get_node_timer(pos):start(self.cycle_time)
	elseif state == STANDBY then
		minetest.get_node_timer(pos):start(self.cycle_time * self.standby_ticks)
	elseif state == BLOCKED then
		minetest.get_node_timer(pos):start(self.cycle_time * self.standby_ticks)
	end
	
	if self.formspec_func then
		meta:set_string("formspec", self.formspec_func(self, pos, meta))
	end
end

-- Repair of defect (feature!) nodes
function NodeStates:on_node_repair(pos)
	local meta = M(pos)
	if meta:get_int("tubelib_state") == DEFECT then
		meta:set_int("tubelib_state", STOPPED)
		if self.node_name_passive then
			local node = minetest.get_node(pos)
			node.name = self.node_name_passive
			minetest.swap_node(pos, node)
		end
		if self.aging_level1 then
			meta:set_int("tubelib_aging", 0)
		end
		if self.infotext_name then
			local number = meta:get_string("tubelib_number")
			meta:set_string("infotext", self.infotext_name.." "..number..": stopped")
		end
		if self.formspec_func then
			meta:set_string("formspec", self.formspec_func(self, pos, meta))
		end
		return true
	end
	return false
end	


--[[
Callback after digging a node but before removing the node.

The tubelib node becomes defect after digging it:
	- always if the aging counter "tubelib_aging" is greater than self.aging_level2
	- with a certain probability if the aging counter "tubelib_aging" is greater than self.aging_level1
	but smaller than self.aging_level2
	
Info: If a tubelib machine has been running quite some time but is dropped as a non-defect machine and then placed back again, the
tubelib machine will be reset to new (digging will reset the aging counter). So this code tries to prevent this exploit

]]--
function NodeStates:on_dig_node(pos, node, player)
	local meta = M(pos)
	local cnt = tonumber(meta:get_string("tubelib_aging"))
	if (not cnt or cnt < 1) then
		cnt = 1
	end
	
	local is_defect = (cnt > self.aging_level1) and ( math.random(math.max(1, math.floor(self.aging_level2 / cnt))) == 1 )
	
	if is_defect then
			self:defect(pos, meta) -- replace node with defect one 
		node = minetest.get_node(pos) 
	end
	
	
	minetest.node_dig(pos, node, player) -- default behaviour (this function is called automatically if on_dig() callback isn't set)

end





