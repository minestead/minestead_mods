
local FORMNAME = "mission_block_stats"

missions.form.missionblock_stats = function(pos, node, player)

	local meta = minetest.get_meta(pos)
	local successcount = meta:get_int("successcount")
	local failcount = meta:get_int("failcount")

	local formspec = "size[8,8;]" ..
		--left
		"label[0,0;Mission block]" ..
		"label[0,2;Success-count: " .. successcount .. "]" ..
		"label[0,3;Fail-count: " .. failcount .. "]" ..
		"button_exit[0,7;8,1;exit;Exit]" ..
		missions.FORMBG

	minetest.show_formspec(player:get_player_name(),
		FORMNAME .. ";" .. minetest.pos_to_string(pos),
		formspec
	)

end



