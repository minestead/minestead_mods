
missions.register_step({

	type = "checkpriv",
	name = "Check Privilege",

	create = function()
		return {priv="interact"}
	end,

	edit_formspec = function(ctx)
		local stepdata = ctx.step.data
		local stepnumber = ctx.stepnumber

		local formspec = "size[8,8;]" ..
			"label[0,0;Priv check (Step #" .. stepnumber .. ")]" ..

			"field[0,2;8,1;priv;Privilege;" .. stepdata.priv ..  "]" ..
			"button[0,7;8,1;save;Save]"

		return formspec;
	end,

	update = function(ctx)
		local fields = ctx.fields
		local stepdata = ctx.step.data

		if fields.priv then
			stepdata.priv = fields.priv
		end

		if fields.save then
			ctx.show_mission()
		end
	end,

	on_step_enter = function(ctx)
		local player = ctx.player
		local stepdata = ctx.step.data

		local p_obj = {}
		p_obj[stepdata.priv] = true

		if minetest.check_player_privs(player:get_player_name(), p_obj) then
			ctx.on_success()
		else
			ctx.on_failed("Privilege '" .. stepdata.priv .. "' needed!")
		end
	end

})
