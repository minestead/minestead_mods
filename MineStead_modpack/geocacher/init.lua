minetest.register_node("geocacher:block", {
	--drawtype = "node",
	description = "Geocache Block",
	tiles = {
		"geocacher_block.png"
	},
	sunlight_propagates = true,
	walkable = false,
	groups = {snappy=3,oddly_breakable_by_hand=1},
	light_source = 3,
	after_place_node = function(pos, placer)
	local meta = minetest.get_meta(pos)
	local date_str = os.date("%b %d %Y at %I:%M %p")
		meta:set_string("owner",          placer:get_player_name() );
		meta:set_string("infotext",       "Right click to view geocache log.  Punch to add your name. (Owned by "..placer:get_player_name()..")");
		meta:set_string("log",   " "..placer:get_player_name().." on "..date_str);
		meta:set_string(
					"formspec", 
					"size[7,7]"..
					"textlist[0.1,0.1;6.6,5.8;Log; "..placer:get_player_name().." on "..date_str.."]"..
					"button_exit[4.9,6.3;2,1;exit;Close]"
				)
	end,
	can_dig = function( pos, player )
		local meta = minetest.get_meta(pos)
		if meta:get_string("owner") == player:get_player_name() then
			return true	
		end
		return false
	end,
	on_punch = function(pos, node, puncher)
	local meta = minetest.get_meta(pos) 
	local date_str = os.date("%b %d %Y at %I:%M %p")
		if not string.find(meta:get_string("log"), string.gsub(" "..puncher:get_player_name().." ", "%-", "%%%-")) then
			meta:set_string("log", " "..puncher:get_player_name().." on "..date_str.." ,"..meta:get_string("log"))
			meta:set_string(
					"formspec", 
					"size[7,7]"..
					"textlist[0.1,0.1;6.6,5.8;Log;"..meta:get_string("log").."]"..
					"button_exit[4.9,6.3;2,1;exit;Close]"
				)
		else 
			minetest.chat_send_player(puncher:get_player_name(), "You already signed this geocache block.")
		end
    end,
})
minetest.register_craft({
	output = "geocacher:block",
	recipe = {{"group:wood", "default:paper", "dye:black"}},
})
