--[[

	=======================================================================
	Tubelib Biogas Machines Mod
	by Micu (c) 2018

	Copyright (C) 2018 Michal Cieslakiewicz

	Helper file for all machines that accept water through pipes from
	'pipeworks' mod.

	Note: machine face orientation is apparently ignored by pipe logic,
	'back' for pipes means always param2 = 0 (z+).

	License: LGPLv2.1+
	=======================================================================
	
]]--

-- all pipeworks objects that can carry water but are not junctions
local pipeworks_straight_object = {
	["pipeworks:straight_pipe_loaded"] = true,
	["pipeworks:entry_panel_loaded"] = true,
	["pipeworks:valve_on_loaded"] = true,
	["pipeworks:flow_sensor_loaded"] = true,
}

-- direction attributes for pipe connections
local ctable = {
	["top"] = { dv = { x = 0, y = 1, z = 0 },
		    p2 = { [17] = true } },
	["bottom"] = { dv = { x = 0, y = -1, z = 0 },
		       p2 = { [17] = true } },
	["front"] = { dv = { x = 0, y = 0, z = -1 },
		      p2 = { [0] = true, [2] = true } },
	["back"] = { dv = { x = 0, y = 0, z = 1 },
		      p2 = { [0] = true, [2] = true } },
	["left"] = { dv = { x = -1, y = 0, z = 0 },
		     p2 = { [1] = true, [3] = true } },
	["right"] = { dv = { x = 1, y = 0, z = 0 },
		      p2 = { [1] = true, [3] = true } },
}

--[[
	------
	Public
	------
]]--

-- Check if machine is connected to pipe network and water flows into machine
-- Parameters: node position, node object (optional)
-- Returns: true if water is flowing into device node
function biogasmachines.is_pipe_with_water(pos, opt_node)
	if not minetest.global_exists("pipeworks") then
		return false
	end
	local node = opt_node
	if not node then
		node = minetest.get_node_or_nil(pos)
		if not node then return false end
	end
	local node_def = minetest.registered_nodes[node.name]
	if not node_def then return false end
	local pipe_con = node_def.pipe_connections
	if not pipe_con then return false end
	for d, v in pairs(pipe_con) do
		if v then
			local d_node = minetest.get_node_or_nil(
				vector.add(pos, ctable[d].dv))
			if d_node and string.match(d_node.name,
				"^pipeworks:pipe_.*_loaded") then
				return true
			end
			if d_node and ctable[d].p2[d_node.param2]
				and pipeworks_straight_object[d_node.name]
					then
				return true
			end
		end
	end
	return false
end

