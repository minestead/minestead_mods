
missions.register_step({

	type = "grant",
	name = "Grant privilege",

	privs = {privs=true},

	create = function()
		return {priv=""}
	end,

	edit_formspec = function(ctx)
		local stepdata = ctx.step.data

		local formspec = "size[8,8;]" ..
			"label[0,0;Grant privilege]" ..
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
		local name = player:get_player_name()
		local stepdata = ctx.step.data
		local priv = stepdata.priv

		if priv then
			local privs = minetest.get_player_privs(name)
			privs[priv] = true
			minetest.set_player_privs(name, privs)
		end

		ctx.on_success()
	end

})


