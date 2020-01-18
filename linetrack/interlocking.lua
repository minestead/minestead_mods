local setaspectf = function()
 return function(pos, node, asp)
	if not asp.main.free then
		if asp.shunt.free then
			advtrains.ndb.swap_node(pos, {name="linetrack:signal_shunt", param2 = node.param2})
		else
			advtrains.ndb.swap_node(pos, {name="linetrack:signal_danger", param2 = node.param2})
		end
	else
		if asp.dst.free and asp.main.speed == -1 then
			advtrains.ndb.swap_node(pos, {name="linetrack:signal_free", param2 = node.param2})
		else
			advtrains.ndb.swap_node(pos, {name="linetrack:signal_slow", param2 = node.param2})
		end
	end
	local meta = minetest.get_meta(pos)
	if meta then
		meta:set_string("infotext", minetest.serialize(asp))
	end
 end
end

local suppasp = {
		main = {
			free = nil,
			speed = {6, -1},
		},
		dst = {
			free = nil,
			speed = nil,
		},
		shunt = {
			free = nil,
			proceed_as_main = true,
		},
		info = {
			call_on = false,
			dead_end = false,
			w_speed = nil,
		}
}

for typ, prts in pairs({
		danger = {asp = advtrains.interlocking.DANGER, n = "slow", ici=true},
		slow   = {asp = { main = { free = true, speed = 6 }, shunt = {proceed_as_main = true}} , n = "free"},
		free   = {asp = { main = { free = true, speed = -1 }, shunt = {proceed_as_main = true}} , n = "shunt"},
		shunt  = {asp = { main = {free = false}, shunt = {free = true} } , n = "danger"},
	}) do
	minetest.register_node("linetrack:signal_"..typ, {
		description = "Generic Main Signal",
		drawtype = "mesh",
		mesh = "linetrack_signal.obj",
		tiles = {"linetrack_signal_"..typ..".png"},
		
		paramtype="light",
		sunlight_propagates=true,
		light_source = 4,
		walkable = false,
		
		groups = {
			cracky = 2,
			advtrains_signal = 2,
			not_blocking_trains = 1,
			save_in_at_nodedb = 1,
			not_in_creative_inventory = prts.ici and 0 or 1,
		},
		drop = "linetrack:signal_danger",
		inventory_image = "linetrack_signal_danger.png",
		sounds = default.node_sound_stone_defaults(),
		advtrains = {
			set_aspect = setaspectf(),
			supported_aspects = suppasp,
			get_aspect = function(pos, node)
				return prts.asp
			end,
		},
		use_texture_alpha = true,
		on_rightclick = advtrains.interlocking.signal_rc_handler,
		can_dig = advtrains.interlocking.signal_can_dig,
		use_texture_alpha = true,
	})
end

local at_tcb = minetest.registered_nodes["advtrains_interlocking:tcb_node"]

minetest.register_node("linetrack:tcb_node", {
	drawtype = "mesh",
	paramtype="light",
	paramtype2="facedir",
	walkable = false,
	mesh = "linetrack_signal.obj",
	tiles = {"linetrack_tcb.png"},
	description="Line Circuit Break",
	sunlight_propagates=true,
	groups = {
		cracky=3,
		not_blocking_trains=1,
		--save_in_at_nodedb=2,
		at_il_track_circuit_break = 1,
	},
	after_place_node = at_tcb.after_place_node,
	on_rightclick = at_tcb.on_rightclick,
	can_dig = at_tcb.can_dig,
	after_dig_node = at_tcb.after_dig_node,
})
