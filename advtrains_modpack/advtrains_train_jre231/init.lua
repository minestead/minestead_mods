local S
if minetest.get_modpath("intllib") then
    S = intllib.Getter()
else
    S = function(s,a,...)a={a,...}return s:gsub("@(%d+)",function(n)return a[tonumber(n)]end)end
end

local SND_LOOP_LEN = 2



local cfg_seats = {
		{
			name=S("Driver stand"),
			attach_offset={x=0, y=0, z=8},
			view_offset={x=0, y=0, z=0},
			driving_ctrl_access=true,
			group="dstand",
		},
		{
			name="1",
			attach_offset={x=-4, y=0, z=0},
			view_offset={x=0, y=0, z=0},
			group="pass",
		},
		{
			name="2",
			attach_offset={x=4, y=0, z=0},
			view_offset={x=0, y=0, z=0},
			group="pass",
		},
		{
			name="3",
			attach_offset={x=-4, y=0, z=-8},
			view_offset={x=0, y=0, z=0},
			group="pass",
		},
		{
			name="4",
			attach_offset={x=4, y=0, z=-8},
			view_offset={x=0, y=0, z=0},
			group="pass",
		},
	}

local cfg_seat_groups = {
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
	}

local cfg_doors = {
		open={
			[-1]={frames={x=0, y=40}, time=1},
			[1]={frames={x=80, y=120}, time=1},
			sound="advtrains_electric_door"
		},
		close={
			[-1]={frames={x=40, y=80}, time=1},
			[1]={frames={x=120, y=160}, time=1},
			sound="advtrains_electric_door"
		}
	}

function e321_custom_onstep(self, dtime)
                if self:train().velocity > 0 then -- First make sure that the train isn't standing
                        if not self.sound_loop_tmr or self.sound_loop_tmr <= 0 then
                                -- start the sound if it was never started or has expired
                                self.sound_loop_handle = minetest.sound_play({name="advtrains_electric_loop", gain=0.04, max_hear_distance=2}, {object=self.object})
                                self.sound_loop_tmr = SND_LOOP_LEN
                        end
                        --decrease the sound timer
                        self.sound_loop_tmr = self.sound_loop_tmr - dtime
                else
                        -- If the train is standing, the sound will be stopped in some time. We do not need to interfere with it.
                        self.sound_loop_tmr = nil
                end
        end

advtrains.register_wagon("KuHa_E231", {
	mesh="advtrains_KuHa_E231.b3d",
	drives_on={default=true},
	max_speed=20,
	seats = cfg_seats,
	seat_groups = cfg_seat_groups,
	assign_to_seat_group = {"dstand", "pass"},
	doors= cfg_doors,
        custom_on_step=e321_custom_onstep,
	door_entry={-1},
	assign_to_seat_group = {"dstand", "pass"},
	visual_size = {x=1, y=1},
	wagon_span=2.5,
	is_locomotive=true,
	collisionbox = {-1.0,-0.5,-1.0, 1.0,2.5,1.0},
	glow = 2,
	textures = {"advtrains_KuHa_E231.png"},
	drops={"advtrains:KuHa_E231"}
}, S("KuHa_E231"), "advtrains_KuHa_E231_inv.png")

minetest.register_craft({
	output = 'advtrains:KuHa_E231',
	recipe = {
		{'dye:green', 'dye:green', 'dye:green'},
		{'advtrains_train_electric:train_hull', 'dye:white', 'advtrains_train_electric:train_engine'},
		{'advtrains_train_electric:steel_wheel', 'advtrains_train_electric:steel_wheel', 'advtrains_train_electric:steel_wheel'},
	},
})

-- BLUE
advtrains.register_wagon("KuHa_E231B", {
	mesh="advtrains_KuHa_E231.b3d",
	drives_on={default=true},
	max_speed=20,
	seats = cfg_seats,
	seat_groups = cfg_seat_groups,
	assign_to_seat_group = {"dstand", "pass"},
	doors= cfg_doors,
        custom_on_step=e321_custom_onstep,
	door_entry={-1},
	assign_to_seat_group = {"dstand", "pass"},
	visual_size = {x=1, y=1},
	wagon_span=2.5,
	is_locomotive=true,
	collisionbox = {-1.0,-0.5,-1.0, 1.0,2.5,1.0},
	glow = 2,
	textures = {"advtrains_KuHa_E231B.png"},
	drops={"advtrains:KuHa_E231B"}
}, S("KuHa_E231 Blue"), "advtrains_KuHa_E231B_inv.png")
minetest.register_craft({
	output = 'advtrains:KuHa_E231B',
	recipe = {
		{'dye:blue', 'dye:blue', 'dye:blue'},
		{'advtrains_train_electric:train_hull', 'dye:white', 'advtrains_train_electric:train_engine'},
		{'advtrains_train_electric:steel_wheel', 'advtrains_train_electric:steel_wheel', 'advtrains_train_electric:steel_wheel'},
	},
})

-- CYAN
advtrains.register_wagon("KuHa_E231C", {
	mesh="advtrains_KuHa_E231.b3d",
	drives_on={default=true},
	max_speed=20,
	seats = cfg_seats,
	seat_groups = cfg_seat_groups,
	assign_to_seat_group = {"dstand", "pass"},
	doors= cfg_doors,
        custom_on_step=e321_custom_onstep,
	door_entry={-1},
	assign_to_seat_group = {"dstand", "pass"},
	visual_size = {x=1, y=1},
	wagon_span=2.5,
	is_locomotive=true,
	collisionbox = {-1.0,-0.5,-1.0, 1.0,2.5,1.0},
	glow = 2,
	textures = {"advtrains_KuHa_E231C.png"},
	drops={"advtrains:KuHa_E231C"}
}, S("KuHa_E231 Cyan"), "advtrains_KuHa_E231C_inv.png")
minetest.register_craft({
	output = 'advtrains:KuHa_E231C',
	recipe = {
		{'dye:cyan', 'dye:cyan', 'dye:cyan'},
		{'advtrains_train_electric:train_hull', 'dye:white', 'advtrains_train_electric:train_engine'},
		{'advtrains_train_electric:steel_wheel', 'advtrains_train_electric:steel_wheel', 'advtrains_train_electric:steel_wheel'},
	},
})

-- PURPLE
advtrains.register_wagon("KuHa_E231P", {
	mesh="advtrains_KuHa_E231.b3d",
	drives_on={default=true},
	max_speed=20,
	seats = cfg_seats,
	seat_groups = cfg_seat_groups,
	assign_to_seat_group = {"dstand", "pass"},
	doors= cfg_doors,
        custom_on_step=e321_custom_onstep,
	door_entry={-1},
	assign_to_seat_group = {"dstand", "pass"},
	visual_size = {x=1, y=1},
	wagon_span=2.5,
	is_locomotive=true,
	collisionbox = {-1.0,-0.5,-1.0, 1.0,2.5,1.0},
	glow = 2,
	textures = {"advtrains_KuHa_E231P.png"},
	drops={"advtrains:KuHa_E231P"}
}, S("KuHa_E231 Purple"), "advtrains_KuHa_E231P_inv.png")
minetest.register_craft({
	output = 'advtrains:KuHa_E231P',
	recipe = {
		{'dye:violet', 'dye:violet', 'dye:violet'},
		{'advtrains_train_electric:train_hull', 'dye:white', 'advtrains_train_electric:train_engine'},
		{'advtrains_train_electric:steel_wheel', 'advtrains_train_electric:steel_wheel', 'advtrains_train_electric:steel_wheel'},
	},
})

-- RED
advtrains.register_wagon("KuHa_E231R", {
	mesh="advtrains_KuHa_E231.b3d",
	drives_on={default=true},
	max_speed=20,
	seats = cfg_seats,
	seat_groups = cfg_seat_groups,
	assign_to_seat_group = {"dstand", "pass"},
	doors= cfg_doors,
        custom_on_step=e321_custom_onstep,
	door_entry={-1},
	assign_to_seat_group = {"dstand", "pass"},
	visual_size = {x=1, y=1},
	wagon_span=2.5,
	is_locomotive=true,
	collisionbox = {-1.0,-0.5,-1.0, 1.0,2.5,1.0},
	glow = 2,
	textures = {"advtrains_KuHa_E231R.png"},
	drops={"advtrains:KuHa_E231R"}
}, S("KuHa_E231 Red"), "advtrains_KuHa_E231R_inv.png")
minetest.register_craft({
	output = 'advtrains:KuHa_E231R',
	recipe = {
		{'dye:red', 'dye:red', 'dye:red'},
		{'advtrains_train_electric:train_hull', 'dye:white', 'advtrains_train_electric:train_engine'},
		{'advtrains_train_electric:steel_wheel', 'advtrains_train_electric:steel_wheel', 'advtrains_train_electric:steel_wheel'},
	},
})

-- YELLOW
advtrains.register_wagon("KuHa_E231Y", {
	mesh="advtrains_KuHa_E231.b3d",
	drives_on={default=true},
	max_speed=20,
	seats = cfg_seats,
	seat_groups = cfg_seat_groups,
	assign_to_seat_group = {"dstand", "pass"},
	doors= cfg_doors,
        custom_on_step=e321_custom_onstep,
	door_entry={-1},
	assign_to_seat_group = {"dstand", "pass"},
	visual_size = {x=1, y=1},
	wagon_span=2.5,
	is_locomotive=true,
	collisionbox = {-1.0,-0.5,-1.0, 1.0,2.5,1.0},
	glow = 2,
	textures = {"advtrains_KuHa_E231Y.png"},
	drops={"advtrains:KuHa_E231Y"}
}, S("KuHa_E231 Yellow"), "advtrains_KuHa_E231Y_inv.png")
minetest.register_craft({
	output = 'advtrains:KuHa_E231Y',
	recipe = {
		{'dye:yellow', 'dye:yellow', 'dye:yellow'},
		{'advtrains_train_electric:train_hull', 'dye:white', 'advtrains_train_electric:train_engine'},
		{'advtrains_train_electric:steel_wheel', 'advtrains_train_electric:steel_wheel', 'advtrains_train_electric:steel_wheel'},
	},
})



advtrains.register_wagon("SaHa_E231", {
	mesh="advtrains_SaHa_E231.b3d",
	textures = {"advtrains_SaHa_E231.png"},
	drives_on={default=true},
	max_speed=20,
	seats = {
		{
			name="1",
			attach_offset={x=-4, y=0, z=8},
			view_offset={x=0, y=0, z=0},
			group="pass",
		},
		{
			name="2",
			attach_offset={x=4, y=0, z=8},
			view_offset={x=0, y=0, z=0},
			group="pass",
		},
		{
			name="1a",
			attach_offset={x=-4, y=0, z=0},
			view_offset={x=0, y=0, z=0},
			group="pass",
		},
		{
			name="2a",
			attach_offset={x=4, y=0, z=0},
			view_offset={x=0, y=0, z=0},
			group="pass",
		},
		{
			name="3",
			attach_offset={x=-4, y=0, z=-8},
			view_offset={x=0, y=0, z=0},
			group="pass",
		},
		{
			name="4",
			attach_offset={x=4, y=0, z=-8},
			view_offset={x=0, y=0, z=0},
			group="pass",
		},
	},
	seat_groups = {
		pass={
			name = "Passenger area",
			access_to = {},
			require_doors_open=true,
		},
	},
	assign_to_seat_group = {"pass"},
	doors={
		open={
			[-1]={frames={x=0, y=40}, time=1},
			[1]={frames={x=80, y=120}, time=1},
			sound="advtrains_electric_door"
		},
		close={
			[-1]={frames={x=40, y=80}, time=1},
			[1]={frames={x=120, y=160}, time=1},
			sound="advtrains_electric_door"
		}
	},
	door_entry={-1, 1},
	visual_size = {x=1, y=1},
	wagon_span=2.3,
	collisionbox = {-1.0,-0.5,-1.0, 1.0,2.5,1.0},
	drops={"advtrains:SaHa_E231"},
	glow = 2,
}, S("SaHa_E231"), "advtrains_SaHa_E231_inv.png")

minetest.register_craft({
	output = 'advtrains:SaHa_E231',
	recipe = {
		{'dye:green', 'dye:green', 'dye:green'},
		{'advtrains_train_electric:train_hull', 'dye:white', ''},
		{'advtrains_train_electric:steel_wheel', 'advtrains_train_electric:steel_wheel', 'advtrains_train_electric:steel_wheel'},
	},
})

