--[[

	Tube Library 2
	==============

	Copyright (C) 2017-2018 Joachim Stolberg

	LGPLv2.1+
	See LICENSE.txt for more information

	storage.lua

]]--

--
-- Data maintenance
--
local MemStore = {}
local storage = minetest.get_mod_storage()

local function update_mod_storage()
	local gametime = minetest.get_gametime()
	for k,v in pairs(MemStore) do
		if v.used then
			v.used = false
			v.best_before = gametime + (60 * 30)  -- 30 min
			storage:set_string(k, minetest.serialize(v))
		elseif v.best_before < gametime then
			storage:set_string(k, minetest.serialize(v))
			MemStore[k] = nil  -- remove from memory
		end
	end	
	-- run every 10 minutes
	minetest.after(600, update_mod_storage)
end

minetest.register_on_shutdown(function()
	for k,v in pairs(MemStore) do
		storage:set_string(k, minetest.serialize(v))
	end	
end)

minetest.after(600, update_mod_storage)


--
-- Local helper functions
--
local function new_block(block_key)
	local data = storage:get_string(block_key)
	if data == nil or data == "" then  -- TODO: change for v5
		MemStore[block_key] = {}
	else
		MemStore[block_key] = minetest.deserialize(data)
	end
	return MemStore[block_key]
end

local function new_node(block, node_key)
	block[node_key] = {}
	return block[node_key]
end

local function unlock(pos)
	local block_key = math.floor((pos.z+32768)/16)*4096*4096 + 
		math.floor((pos.y+32768)/16)*4096 + math.floor((pos.x+32768)/16)
	local node_key = (pos.z%16)*16*16 + (pos.y%16)*16 + (pos.x%16)
	local block = MemStore[block_key] or new_block(block_key)
	block.used = true
	return block, node_key
end


-------------------------------------------------------------------------------
-- API functions for a node related and high efficient storage table
-- for all kind of node data.
-------------------------------------------------------------------------------

-- To be called when a node is placed
function tubelib2.init_mem(pos)
	local block, node_key = unlock(pos)
	return new_node(block, node_key)
end

-- To get the node data table
function tubelib2.get_mem(pos)
	local block, node_key = unlock(pos)
	return block[node_key] or new_node(block, node_key)
end

-- To be called when a node is removed
function tubelib2.del_mem(pos)
	local block, node_key = unlock(pos)
	block[node_key] = nil
end

-- Read a value, or return the default value if not available
function tubelib2.get_mem_data(pos, key, default)
	return tubelib2.get_mem(pos)[key] or default
end

