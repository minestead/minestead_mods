
missions.register_step({

	type = "checkxp",
	name = "Check XP",

	create = function()
		return {xp=100}
	end,

	edit_formspec = function(ctx)
		local stepdata = ctx.step.data
		local stepnumber = ctx.stepnumber

		local formspec = "size[8,8;]" ..
			"label[0,0;XP Check (Step #" .. stepnumber .. ")]" ..
			"field[0,2;8,1;xp;XP Threshold;" .. stepdata.xp ..  "]" ..
			"button[0,7;8,1;save;Save]"

		return formspec;
	end,

	update = function(ctx)
		local fields = ctx.fields
		local stepdata = ctx.step.data

		if fields.xp then
			local xp = tonumber(fields.xp)
			if xp and xp > 0 then
				stepdata.xp = xp
			end
		end

		if fields.save then
			ctx.show_mission()
		end
	end,

	on_step_enter = function(ctx)
		local player = ctx.player
		local stepdata = ctx.step.data

		if xp_redo.get_xp(player:get_player_name()) > stepdata.xp then
			ctx.on_success()
		else
			ctx.on_failed("Not enough xp, " .. stepdata.xp .. " needed!")
		end
	end

})


