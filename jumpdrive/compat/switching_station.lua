-- borrowed from technic/machines/switching_station

jumpdrive.switching_station_compat = function (from, to)
  minetest.after(2, function (oldpos)
    minetest.log('action', 'jumpdrive: Free forceload block:'..minetest.serialize(oldpos))
    minetest.forceload_free_block(oldpos)
    oldpos.y = oldpos.y - 1
    minetest.log('action', 'jumpdrive: Free forceload block:'..minetest.serialize(oldpos))
    minetest.forceload_free_block(oldpos)
    local poshash = minetest.hash_node_position(oldpos)
    technic.redundant_warn.poshash = nil
  end, from)
  local meta_to = minetest.get_meta(to)
  meta_to:set_int('is_forceloaded', 0)
end
