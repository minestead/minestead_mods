-- Default tracks for advtrains
-- (c) orwell96 and contributors

--flat

local function suitable_substrate(upos)
	return minetest.registered_nodes[minetest.get_node(upos).name] and (minetest.registered_nodes[minetest.get_node(upos).name].liquidtype == "source" or minetest.registered_nodes[minetest.get_node(upos).name].liquidtype == "flowing")
end

advtrains.register_tracks("waterline", {
	nodename_prefix="linetrack:watertrack",
	texture_prefix="advtrains_ltrack",
	models_prefix="advtrains_ltrack",
	models_suffix=".obj",
	shared_texture="linetrack_line.png",
	description=attrans("Water Line Track"),
	formats={},
	liquids_pointable=true,
	suitable_substrate=suitable_substrate,
	get_additional_definiton = function(def, preset, suffix, rotation)
		return {
			groups = {
				advtrains_track=1,
				advtrains_track_waterline=1,
				save_in_at_nodedb=1,
				dig_immediate=2,
				not_in_creative_inventory=1,
				not_blocking_trains=1,
			},
			use_texture_alpha = true,
		}
	end
}, advtrains.ap.t_30deg_flat)
--slopes
advtrains.register_tracks("waterline", {
	nodename_prefix="linetrack:watertrack",
	texture_prefix="advtrains_ltrack",
	models_prefix="advtrains_ltrack",
	models_suffix=".obj",
	shared_texture="linetrack_line.png",
	description=attrans("Line Track"),
	formats={vst1={true, false, true}, vst2={true, false, true}, vst31={true}, vst32={true}, vst33={true}},
	liquids_pointable=true,
	suitable_substrate=suitable_substrate,
	get_additional_definiton = function(def, preset, suffix, rotation)
		return {
			groups = {
				advtrains_track=1,
				advtrains_track_waterline=1,
				save_in_at_nodedb=1,
				dig_immediate=2,
				not_in_creative_inventory=1,
				not_blocking_trains=1,
			},
			use_texture_alpha = true,
		}
	end
}, advtrains.ap.t_30deg_slope)

if atlatc ~= nil then
	advtrains.register_tracks("waterline", {
		nodename_prefix="linetrack:watertrack_lua",
		texture_prefix="advtrains_ltrack_lua",
		models_prefix="advtrains_ltrack",
		models_suffix=".obj",
		shared_texture="linetrack_lua.png",
		description=atltrans("LuaAutomation ATC Line"),
		formats={},
		liquids_pointable=true,
		suitable_substrate=suitable_substrate,
		get_additional_definiton = function(def, preset, suffix, rotation)
			return {
				after_place_node = atlatc.active.after_place_node,
				after_dig_node = atlatc.active.after_dig_node,

				on_receive_fields = function(pos, ...)
					atlatc.active.on_receive_fields(pos, ...)
					
					--set arrowconn (for ATC)
					local ph=minetest.pos_to_string(pos)
					local _, conns=advtrains.get_rail_info_at(pos, advtrains.all_tracktypes)
					atlatc.active.nodes[ph].arrowconn=conns[1].c
				end,

				advtrains = {
					on_train_enter = function(pos, train_id)
						--do async. Event is fired in train steps
						atlatc.interrupt.add(0, pos, {type="train", train=true, id=train_id})
					end,
				},
				luaautomation = {
					fire_event=atlatc.rail.fire_event
				},
				digiline = {
					receptor = {},
					effector = {
						action = atlatc.active.on_digiline_receive
					},
				},
				groups = {
					advtrains_track=1,
					advtrains_track_waterline=1,
					save_in_at_nodedb=1,
					dig_immediate=2,
					not_in_creative_inventory=1,
					not_blocking_trains=1,
				},
				use_texture_alpha = true,
			}
		end,
	}, advtrains.trackpresets.t_30deg_straightonly)
end

if minetest.get_modpath("advtrains_line_automation") ~= nil then
	local adef = minetest.registered_nodes["advtrains_line_automation:dtrack_stop_st"]
	
	advtrains.register_tracks("waterline", {
		nodename_prefix="linetrack:watertrack_stn",
		texture_prefix="advtrains_ltrack_stn",
		models_prefix="advtrains_ltrack",
		models_suffix=".obj",
		shared_texture="linetrack_stn.png",
		description="Station/Stop Line",
		formats={},
		liquids_pointable=true,
		suitable_substrate=suitable_substrate,
		get_additional_definiton = function(def, preset, suffix, rotation)
			return {
				after_place_node = adef.after_place_node,
				after_dig_node = adef.after_dig_node,
				on_rightclick = adef.on_rightclick,
				advtrains = adef.advtrains,
				groups = {
					advtrains_track=1,
					advtrains_track_waterline=1,
					save_in_at_nodedb=1,
					dig_immediate=2,
					not_in_creative_inventory=1,
					not_blocking_trains=1,
				},
				use_texture_alpha = true,
			}
		end,
	}, advtrains.trackpresets.t_30deg_straightonly)
end

if minetest.get_modpath("advtrains_interlocking") ~= nil then
	dofile(minetest.get_modpath("linetrack") .. "/interlocking.lua")
end

advtrains.register_wagon("boat", {
	mesh="linetrack_boat.obj",
	textures = {"linetrack_boat.png"},
	drives_on={waterline=true},
	max_speed=10,
	seats = {
		{
			name="Driver stand",
			attach_offset={x=0, y=2, z=12},
			view_offset={x=0, y=0, z=0},
			group="dstand",
		},
		{
			name="1",
			attach_offset={x=-4, y=0, z=-4},
			view_offset={x=0, y=0, z=0},
			group="pass",
		},
		{
			name="2",
			attach_offset={x=4, y=0, z=-4},
			view_offset={x=0, y=0, z=0},
			group="pass",
		},
		{
			name="3",
			attach_offset={x=-4, y=0, z=4},
			view_offset={x=0, y=0, z=0},
			group="pass",
		},
		{
			name="4",
			attach_offset={x=4, y=0, z=4},
			view_offset={x=0, y=0, z=0},
			group="pass",
		},
		{
			name="5",
			attach_offset={x=-4, y=0, z=-12},
			view_offset={x=0, y=0, z=0},
			group="pass",
		},
		{
			name="6",
			attach_offset={x=4, y=0, z=-12},
			view_offset={x=0, y=0, z=0},
			group="pass",
		},
		{
			name="7",
			attach_offset={x=-4, y=0, z=-20},
			view_offset={x=0, y=0, z=0},
			group="pass",
		},
		{
			name="8",
			attach_offset={x=4, y=0, z=-20},
			view_offset={x=0, y=0, z=0},
			group="pass",
		},
		{
			name="9",
			attach_offset={x=-4, y=0, z=-28},
			view_offset={x=0, y=0, z=0},
			group="pass",
		},
		{
			name="10",
			attach_offset={x=4, y=0, z=-28},
			view_offset={x=0, y=0, z=0},
			group="pass",
		},
	},
	seat_groups = {
		dstand={
			name = "Driver Stand",
			access_to = {"pass"},
			require_doors_open=true,
			driving_ctrl_access=true,
		},
		pass={
			name = "Passenger area",
			access_to = {"dstand"},
			require_doors_open=true,
		},
	},
	assign_to_seat_group = {"pass", "dstand"},
	door_entry={-1, 1},
	visual_size = {x=1, y=1},
	wagon_span=2,
	collisionbox = {-2.0,-3.0,-2.0, 2.0,4.0,2.0},
	is_locomotive=true,
	drops={"default:steelblock 4"},
	horn_sound = "advtrains_subway_horn",
	glow = -1, --supposed to disable effect of light to texture color, so that the entity always appears as full-bright
}, "Boat", "linetrack_boat_inv.png")

minetest.register_node("linetrack:invisible_platform", {
	description = "Invisible Platform",
	groups = {cracky = 1, not_blocking_trains = 1, platform=1},
	drawtype = "airlike",
	inventory_image = "linetrack_invisible_platform.png",
	wield_image = "linetrack_invisible_platform.png",
	walkable = false,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.1, -0.1, 0.5,  0  , 0.5},
			{-0.5, -0.5,  0  , 0.5, -0.1, 0.5}
		},
	},
	paramtype2="facedir",
	paramtype = "light",
	sunlight_propagates = true,
})
	
