
local metric_allowed = { inc = function() end }
local metric_blocked = { inc = function() end }

if minetest.get_modpath("monitoring") then
  metric_allowed = monitoring.counter(
    "mesecons_ratelimiter_allowed",
    "allowed action_on calls"
  )

  metric_blocked = monitoring.counter(
    "mesecons_ratelimiter_blocked",
    "blocked action_on calls"
  )
end

mesecons_ratelimiter.register_action_on = function(name)

  local nodedef = minetest.registered_nodes[name]

  local old_action_on = nodedef and
    nodedef.mesecons and
    nodedef.mesecons.effector and
    nodedef.mesecons.effector.action_on

  if not old_action_on then
    minetest.log(
      "warning",
      "[mesecons_ratelimiter] node not found: " .. name
    )
    return
  end

  nodedef.mesecons.effector.action_on = function(pos, node, rulename)
    if mesecons_ratelimiter.can_call(pos) then
      old_action_on(pos, node, rulename)
      metric_allowed.inc()
    else
      metric_blocked.inc()
    end
  end

end
