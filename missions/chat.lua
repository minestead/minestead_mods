

minetest.register_chatcommand("mission_abort", {
	description = "Aborts the current mission",
	func = function(name)
		missions.abort(name)
	end
})