
missions.register_step({

	type = "revokeinteract",
	name = "Temporary revoke interact",

	on_step_enter = function(ctx)
		local player = ctx.player
		local name = player:get_player_name()

		local privs = minetest.get_player_privs(name)
		privs.interact = nil
		minetest.set_player_privs(name, privs)

		ctx.on_success()
	end

})


