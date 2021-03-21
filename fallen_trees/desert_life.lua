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

local cacti_groups_a = {
	groups = {choppy = 1, falling_node = 1}
}

local cacti_groups_b = {
	groups = {
		oddly_breakable_by_hand = 3, choppy = 1, dl_bc = 1,
		not_in_creative_inventory = 1, falling_node = 1
	}
}

local prickly_pears_groups_a = {
	groups = {dig_immediate = 3, falling_node=1}
}

local prickly_pears_groups_b = {
	groups = {not_in_creative_inventory=1, dl_pp=1, falling_node=1}
}


--
-- Nodes to be overriden
--

local cacti_nodes_a = {
	"desert_life:barrel_cacti_1", "desert_life:barrel_cacti_2",
	"desert_life:barrel_cacti_3",
}

local cacti_nodes_b = {
	"desert_life:barrel_cacti_1_sp", "desert_life:barrel_cacti_2_sp",
	"desert_life:barrel_cacti_3_sp"
}

local prickly_pears_nodes_b = {
	"desert_life:prickly_pear_1", "desert_life:prickly_pear_2",
	"desert_life:prickly_pear_3", "desert_life:prickly_pear_4",
	"desert_life:prickly_pear_5", "desert_life:prickly_pear_6",
	"desert_life:prickly_pear_7"
}


--
-- Nodes overriders
--

for n = 1, 3 do
	minetest.override_item(cacti_nodes_a[n], cacti_groups_a)
end

for n = 1, 3 do
	minetest.override_item(cacti_nodes_b[n], cacti_groups_b)
end

minetest.override_item("desert_life:prickly_pear", prickly_pears_groups_a)

for n = 1, 7 do
	minetest.override_item(prickly_pears_nodes_b[n], prickly_pears_groups_b)
end
