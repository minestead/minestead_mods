
minetest.register_chatcommand("mesecons_ratelimiter_delay", {
	description = "sets or gets the ratelimiter delay (in microseconds)",
	privs = {server=true},
	func = function(_, params)
    local setvalue = tonumber(params)

    if setvalue then
      mesecons_ratelimiter.delay_time = setvalue
    end

    return true, "Ratelimiter-delay: " .. mesecons_ratelimiter.delay_time ..
      " microseconds"
	end
})
