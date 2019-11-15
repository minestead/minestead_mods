--[[
    Fallen Trees - Adds tree nodes to the falling_node group.
    Copyright (C) 2018 Hamlet

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
--]]


--
-- General variables
--

local minetest_log_level = minetest.settings:get("debug_log_level")
local mod_load_message = "[Mod] Fallen Trees [v1.2.2] loaded."
local mod_path = minetest.get_modpath("fallen_trees")


--
-- Groups to be assigned
--

-- Applies to acacia, jungle tree, tree

local tree_groups_a = {
	groups = {
		tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2,
		falling_node = 1
	}
}

-- Applies to aspen and pine

local tree_groups_b = {
	groups = {
		tree = 1, choppy = 3, oddly_breakable_by_hand = 1, flammable = 3,
		falling_node = 1
	}
}


--
-- Nodes to be overriden
--

local tree_nodes_a = {
	"default:acacia_tree", "default:jungletree", "default:tree"
}

local tree_nodes_b = {"default:aspen_tree", "default:pine_tree"}


--
-- Nodes overriders
--

for n = 1, 3 do
	minetest.override_item(tree_nodes_a[n], tree_groups_a)
end

for n = 1, 2 do
	minetest.override_item(tree_nodes_b[n], tree_groups_b)
end


--
-- Support for other modules
--

if minetest.get_modpath("desert_life") then
	dofile(mod_path .. "/desert_life.lua")
end

if minetest.get_modpath("mg") then
	dofile(mod_path .. "/mg.lua")
end

if minetest.get_modpath("real_trees") then
	dofile(mod_path .. "/real_trees.lua")
end


--
-- Minetest engine debug logging
--

if (minetest_log_level == nil) or (minetest_log_level == "action") or
	(minetest_log_level == "info") or (minetest_log_level == "verbose") then

	minetest.log("action", mod_load_message)
end
