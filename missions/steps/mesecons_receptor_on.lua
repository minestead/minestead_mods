
missions.register_step({

	type = "mesecons_receptor_on",
	name = "Emit mesecons signal",

	on_step_enter = function(ctx)
		mesecon.receptor_on(ctx.block_pos)

		minetest.after(1, function()
			mesecon.receptor_off(ctx.block_pos)
		end)

		ctx.on_success()
	end

})


