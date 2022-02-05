--
-- items
--

-- wheel
minetest.register_craftitem("automobiles_roadster:wheel",{
	description = "Roadster wheel",
	inventory_image = "automobiles_roadster_wheel.png",
})

-- roadster
minetest.register_craftitem("automobiles_roadster:roadster", {
	description = "Roadster",
	inventory_image = "automobiles_roadster.png",
    liquids_pointable = false,

	on_place = function(itemstack, placer, pointed_thing)
		if pointed_thing.type ~= "node" then
			return
		end
        
        local pointed_pos = pointed_thing.above
		--pointed_pos.y=pointed_pos.y+0.2
		local car = minetest.add_entity(pointed_pos, "automobiles_roadster:roadster")
		if car and placer then
            local ent = car:get_luaentity()
            local owner = placer:get_player_name()
            if ent then
                ent.owner = owner
			    car:set_yaw(placer:get_look_horizontal())
			    itemstack:take_item()
                ent.object:set_acceleration({x=0,y=-automobiles_lib.gravity,z=0})
                automobiles_lib.setText(ent, "Roadster")
            end
		end

		return itemstack
	end,
})

--
-- crafting
--
if minetest.get_modpath("default") then
	minetest.register_craft({
		output = "automobiles_roadster:roadster",
		recipe = {
			{"automobiles_roadster:wheel", "group:wood", "automobiles_roadster:wheel"},
			{"automobiles_lib:engine", "xpanes:pane_flat", "wool:black"},
			{"automobiles_roadster:wheel", "group:wood", "automobiles_roadster:wheel"},
		}
	})
	minetest.register_craft({
		output = "automobiles_roadster:wheel",
		recipe = {
			{"technic:rubber", "default:stick", "technic:rubber"},
			{"default:stick","group:wood",  "default:stick"},
            {"technic:rubber", "default:stick", "technic:rubber"},
		}
	})
end


