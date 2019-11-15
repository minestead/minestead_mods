function mapmarkers_save(table)
   local file = io.open(minetest.get_worldpath().."/mapmarkers.json", "w")
   if file then
      file:write(minetest.write_json(table))
      file:close()
   end
end

function mapmarkers_load()
   local file = io.open(minetest.get_worldpath().."/mapmarkers.json", "r")
   if file then
      local table = minetest.parse_json(file:read("*all"))
      if type(table) == "table" then
         return table
      end
   end
   return {}
end


minetest.register_chatcommand("marker", {
    params = "description",
    description = "Set marker on map",
    func = function(name, param)
	local player = minetest.get_player_by_name(name)
	if not player then
	    return false, "Player not found"
	end
        local ppos = player:get_pos()
        local markers = mapmarkers_load()
        table.insert(
	    markers,
	    {
        	title = "[" .. player:get_player_name() .. "] " .. param,
        	latlng = { math.ceil(ppos.x), math.ceil(ppos.z) }
    	    }
	)
	mapmarkers_save(markers)
	return true, "# Map marker is set at "..math.ceil(ppos.x)..", "..math.ceil(ppos.z).."."
    end,
})