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
-- Groups to be assigned
--

local trees_groups_a = {
	groups = {
		tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2,
		falling_node = 1
	}
}

local trees_groups_b = {
	groups = {
		tree = 1, choppy = 3, oddly_breakable_by_hand = 1, flammable = 3,
		falling_node = 1
	}
}


--
-- Nodes to be overriden
--

local trees_nodes_a = {
	"real_trees:large_acacia_tree", "real_trees:large_jungle_tree",
	"real_trees:large_tree", "real_trees:medium_acacia_tree",
	"real_trees:medium_jungle_tree", "real_trees:medium_tree",
	"real_trees:small_acacia_tree", "real_trees:small_jungle_tree",
	"real_trees:small_tree", "real_trees:corner_acacia_tree",
	"real_trees:t_corner_acacia_tree", "real_trees:h_large_acacia_tree",
	"real_trees:a_small_acacia_tree", "real_trees:a_medium_acacia_tree",
	"real_trees:a_large_acacia_tree", "real_trees:a_small_jungle_tree",
	"real_trees:a_medium_jungle_tree", "real_trees:a_large_jungle_tree",
	"real_trees:a_small_tree", "real_trees:a_medium_tree",
	"real_trees:a_large_tree", 
}

local trees_nodes_b = {
	"real_trees:large_aspen_tree", "real_trees:large_pine_tree",
	"real_trees:medium_aspen_tree", "real_trees:medium_pine_tree",
	"real_trees:small_aspen_tree", "real_trees:small_pine_tree",
	"real_trees:a_small_pine_tree", "real_trees:a_medium_pine_tree",
	"real_trees:a_large_pine_tree", "real_trees:a_small_aspen_tree",
	"real_trees:a_medium_aspen_tree", "real_trees:a_large_aspen_tree",
}


--
-- Nodes overriders
--

for n = 1, 21 do
	minetest.override_item(trees_nodes_a[n], trees_groups_a)
end

for n = 1, 12 do
	minetest.override_item(trees_nodes_b[n], trees_groups_b)
end
