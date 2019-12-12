
local FORMNAME = "mission_block_help"

missions.form.missionblock_help = function(pos, node, player)

	local formspec = "size[8,8;]" ..
		--left
		"label[0,0;Mission block]" ..
		"label[0,2;1. Craft some mission-wands]" ..
		"label[0,3;2. Use mission-wands on locations or chests]" ..
		"label[0,4;3. Craft and place a mission-block]" ..
		"label[0,5;4. Add steps with the step-editor and use the]" ..
		"label[0,6;   configured position- or chest-wands]" ..
		"button_exit[0,7;8,1;exit;Exit]" ..
		missions.FORMBG

	minetest.show_formspec(player:get_player_name(),
		FORMNAME .. ";" .. minetest.pos_to_string(pos),
		formspec
	)

end



