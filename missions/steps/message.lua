
local markers = {} -- playername -> boolean

local FORMNAME = "mission_block_step_message"

missions.register_step({

	type = "message",
	name = "Show message",

	create = function()
		return {title="", message=""}
	end,

	edit_formspec = function(ctx)
		local stepdata = ctx.step.data

		local formspec = "size[8,8;]" ..
			"label[0,0;Show a message]" ..
			"field[0,1;8,1;title;Title;" .. stepdata.title ..  "]" ..
			"textarea[0,2;8,4;message;Message;" .. stepdata.message ..  "]" ..
			"button[0,7;8,1;save;Save]"

		return formspec;
	end,

	update = function(ctx)
		local fields = ctx.fields
		local stepdata = ctx.step.data

		if fields.title then
			stepdata.title = fields.title
		end

		if fields.message then
			stepdata.message = fields.message
		end

		ctx.show_mission()
	end,

	on_step_enter = function(ctx)
		local player = ctx.player
		local stepdata = ctx.step.data

		markers[player:get_player_name()] = false

		local formspec = "size[8,8;]" ..
			"label[0,0;" .. stepdata.title .. "]" ..
			"label[0,2;" .. stepdata.message .. "]" ..
			"button_exit[5.5,1;2,1;ok;OK]" ..
			missions.FORMBG

		minetest.show_formspec(player:get_player_name(), FORMNAME, formspec)
	end,

	on_step_interval = function(ctx)
		local player = ctx.player

		if markers[player:get_player_name()] then
			ctx.on_success()
		end
	end,

	on_step_exit = function(ctx)
		local player = ctx.player
		markers[player:get_player_name()] = false
	end


})

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= FORMNAME then
		return
	end

	markers[player:get_player_name()] = true
end)





