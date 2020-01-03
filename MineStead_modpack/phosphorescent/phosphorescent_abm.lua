minetest.register_abm({
nodenames = {"group:phosphorescent"},
interval = 10,
chance = 1,
action = function(pos, node, active_object_count, 	active_object_count_wider)
	if not node.param2 then 
		node.param2 = 0
	end
	local energy = node.param2
	if minetest.get_node_light(pos) >= (default.LIGHT_MAX - 3) then
		node_off(node)
		if energy < 255 then
			node.param2 = energy + 1
			minetest.set_node(pos,node)
		end
	else
		if energy > 0 then
			node.param2 = energy - 1
			node_on(node)
		else
			node_off(node)
		end
		minetest.set_node(pos, node)
	end
end})

node_on = function(node)
	if node.name == "phosphorescent:phosphorescent_stonebrick_green_off" then
		node.name = "phosphorescent:phosphorescent_stonebrick_green_on"
	end
	if node.name == "phosphorescent:phosphorescent_stonebrick_blue_off" then
		node.name = "phosphorescent:phosphorescent_stonebrick_blue_on"
	end	
	if node.name == "phosphorescent:phosphorescent_desert_stonebrick_green_off" then
		node.name = "phosphorescent:phosphorescent_desert_stonebrick_green_on"
	end
	if node.name == "phosphorescent:phosphorescent_desert_stonebrick_blue_off" then
		node.name = "phosphorescent:phosphorescent_desert_stonebrick_blue_on"
	end	
	if node.name == "phosphorescent:phosphorescent_desert_sandstonebrick_green_off" then
		node.name = "phosphorescent:phosphorescent_desert_sandstonebrick_green_on"
	end
	if node.name == "phosphorescent:phosphorescent_desert_sandstonebrick_blue_off" then
		node.name = "phosphorescent:phosphorescent_desert_sandstonebrick_blue_on"
	end		
	if node.name == "phosphorescent:phosphorescent_sandstonebrick_green_off" then
		node.name = "phosphorescent:phosphorescent_sandstonebrick_green_on"
	end
	if node.name == "phosphorescent:phosphorescent_sandstonebrick_blue_off" then
		node.name = "phosphorescent:phosphorescent_sandstonebrick_blue_on"
	end	
	if node.name == "phosphorescent:phosphorescent_silver_sandstonebrick_green_off" then
		node.name = "phosphorescent:phosphorescent_silver_sandstonebrick_green_on"
	end
	if node.name == "phosphorescent:phosphorescent_silver_sandstonebrick_blue_off" then
		node.name = "phosphorescent:phosphorescent_silver_sandstonebrick_blue_on"
	end	
end;

node_off = function(node)
	if node.name == "phosphorescent:phosphorescent_stonebrick_green_on" then
		node.name = "phosphorescent:phosphorescent_stonebrick_green_off"
	end
	if node.name == "phosphorescent:phosphorescent_stonebrick_blue_on" then
		node.name = "phosphorescent:phosphorescent_stonebrick_blue_off"
	end	
	if node.name == "phosphorescent:phosphorescent_desert_stonebrick_green_on" then
		node.name = "phosphorescent:phosphorescent_desert_stonebrick_green_off"
	end
	if node.name == "phosphorescent:phosphorescent_desert_stonebrick_blue_on" then
		node.name = "phosphorescent:phosphorescent_desert_stonebrick_blue_off"
	end	
	if node.name == "phosphorescent:phosphorescent_desert_sandstonebrick_green_on" then
		node.name = "phosphorescent:phosphorescent_desert_sandstonebrick_green_off"
	end
	if node.name == "phosphorescent:phosphorescent_desert_sandstonebrick_blue_on" then
		node.name = "phosphorescent:phosphorescent_desert_sandstonebrick_blue_off"
	end	
	if node.name == "phosphorescent:phosphorescent_sandstonebrick_green_on" then
		node.name = "phosphorescent:phosphorescent_sandstonebrick_green_off"
	end
	if node.name == "phosphorescent:phosphorescent_sandstonebrick_blue_on" then
		node.name = "phosphorescent:phosphorescent_sandstonebrick_blue_off"
	end	
	if node.name == "phosphorescent:phosphorescent_silver_sandstonebrick_green_on" then
		node.name = "phosphorescent:phosphorescent_silver_sandstonebrick_green_off"
	end
	if node.name == "phosphorescent:phosphorescent_silver_sandstonebrick_blue_on" then
		node.name = "phosphorescent:phosphorescent_silver_sandstonebrick_blue_off"
	end	
end;
