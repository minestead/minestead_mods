
if minetest.get_modpath("pipeworks") then
  mesecons_ratelimiter.register_action_on("pipeworks:filter")
  mesecons_ratelimiter.register_action_on("pipeworks:mese_filter")
  mesecons_ratelimiter.register_action_on("pipeworks:dispenser_off")
  mesecons_ratelimiter.register_action_on("pipeworks:deployer_off")
  mesecons_ratelimiter.register_action_on("pipeworks:nodebreaker_off")
end

if minetest.get_modpath("mesecons_lightstone") then
  mesecons_ratelimiter.register_action_on("mesecons_lightstone:lightstone_red_off")
  mesecons_ratelimiter.register_action_on("mesecons_lightstone:lightstone_green_off")
  mesecons_ratelimiter.register_action_on("mesecons_lightstone:lightstone_blue_off")
  mesecons_ratelimiter.register_action_on("mesecons_lightstone:lightstone_gray_off")
  mesecons_ratelimiter.register_action_on("mesecons_lightstone:lightstone_darkgray_off")
  mesecons_ratelimiter.register_action_on("mesecons_lightstone:lightstone_yellow_off")
  mesecons_ratelimiter.register_action_on("mesecons_lightstone:lightstone_orange_off")
  mesecons_ratelimiter.register_action_on("mesecons_lightstone:lightstone_white_off")
  mesecons_ratelimiter.register_action_on("mesecons_lightstone:lightstone_pink_off")
  mesecons_ratelimiter.register_action_on("mesecons_lightstone:lightstone_magent_off")
  mesecons_ratelimiter.register_action_on("mesecons_lightstone:lightstone_cyan_off")
  mesecons_ratelimiter.register_action_on("mesecons_lightstone:lightstone_violet_off")
end

if minetest.get_modpath("mesecons_pistons") then
  mesecons_ratelimiter.register_action_on("mesecons_pistons:piston_normal_off")
  mesecons_ratelimiter.register_action_on("mesecons_pistons:piston_sticky_off")
end
