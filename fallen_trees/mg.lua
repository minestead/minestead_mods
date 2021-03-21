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
-- Nodes overriders
--

minetest.override_item("mg:pinetree", {
	groups = {
		tree = 1, choppy = 3, oddly_breakable_by_hand = 1, flammable = 3,
		falling_node = 1
	}
})

minetest.override_item("mg:savannatree", {
	groups = {
		tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2,
		falling_node = 1
	}
})
