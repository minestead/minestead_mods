
local metric_cache_size = { set = function() end }
local cache_size = 0

if minetest.get_modpath("monitoring") then
  metric_cache_size = monitoring.gauge(
    "mesecons_ratelimiter_cache_size",
    "cache size"
  )
end


local cache = {} -- hash -> time_in_micros

mesecons_ratelimiter.can_call = function(pos)
  local hash = minetest.hash_node_position(pos)
  local last_call = cache[hash]

  if not last_call then
    last_call = 0
    cache_size = cache_size + 1
    metric_cache_size.set(cache_size)
  end

  local now = minetest.get_us_time()
  local delta = now - last_call

  if delta > mesecons_ratelimiter.delay_time then
    cache[hash] = now
    return true
  end

  return false
end


-- cache flush timer
local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer < 60 then return end
	timer=0

  cache = {}
  cache_size = 0
  metric_cache_size.set(cache_size)
end)
