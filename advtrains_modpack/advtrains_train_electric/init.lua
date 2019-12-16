local S
if minetest.get_modpath("intllib") then
    S = intllib.Getter()
else
    S = function(s,a,...)a={a,...}return s:gsub("@(%d+)",function(n)return a[tonumber(n)]end)end
end

local SND_LOOP_LEN = 2

advtrains.register_wagon("engine_electric", {
	mesh="advtrains_engine_electric.b3d",
	textures = {"advtrains_engine_electric.png"},
	drives_on={default=true},
	max_speed=20,
	seats = {	
		{
			name=S("Driver Stand (left)"),
			attach_offset={x=-1, y=5, z=2},
			view_offset={x=0, y=-4, z=2},
			driving_ctrl_access=true,
			group = "dstand",
		},
		{
			name="1",
			attach_offset={x=-4, y=8, z=0},
			view_offset={x=0, y=-4, z=0},
			group="pass",
		},
		{
			name="2",
			attach_offset={x=4, y=8, z=0},
			view_offset={x=0, y=-4, z=0},
			group="pass",
		},
		{
			name="3",
			attach_offset={x=-4, y=8, z=-8},
			view_offset={x=0, y=-4, z=0},
			group="pass",
		},
		{
			name="4",
			attach_offset={x=4, y=8, z=-8},
			view_offset={x=0, y=-4, z=0},
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
	assign_to_seat_group = {"dstand", "pass"},
	doors={
		open={
			[-1]={frames={x=0, y=20}, time=1},
			[1]={frames={x=40, y=60}, time=1},
			sound="advtrains_electric_door"
		},
		close={
			[-1]={frames={x=20, y=40}, time=1},
			[1]={frames={x=60, y=80}, time=1},
			sound="advtrains_electric_door"
		}
	},
        custom_on_step=function(self, dtime)
                if self:train().velocity > 0 then -- First make sure that the train isn't standing
                        if not self.sound_loop_tmr or self.sound_loop_tmr <= 0 then
                                -- start the sound if it was never started or has expired
                                self.sound_loop_handle = minetest.sound_play({name="advtrains_electric_loop", gain=0.04, max_hear_distance=4}, {object=self.object})
                                self.sound_loop_tmr = SND_LOOP_LEN
                        end
                        --decrease the sound timer
                        self.sound_loop_tmr = self.sound_loop_tmr - dtime
                else
                        -- If the train is standing, the sound will be stopped in some time. We do not need to interfere with it.
                        self.sound_loop_tmr = nil
                end
        end,
	update_animation=function(self, velocity)
		if self.old_anim_velocity~=advtrains.abs_ceil(velocity) then
			self.object:set_animation({x=1,y=80}, advtrains.abs_ceil(velocity)*15, 0, true)
			self.old_anim_velocity=advtrains.abs_ceil(velocity)
		end
	end,
	door_entry={-1.7},
	visual_size = {x=1, y=1},
	wagon_span=2.5,
	is_locomotive=true,
	collisionbox = {-1.0,-0.5,-1.0, 1.0,2.5,1.0},
	drops={"advtrains:engine_electric"},
	horn_sound = "advtrains_electric_horn",
	glow = 5,
}, S("Electric Train Engine"), "advtrains_engine_electric_inv.png")


-- ######## ADD CRAFTING RECIPES ############

minetest.register_craft({
	output = 'advtrains:engine_electric',
	recipe = {
		{'dye:green', 'dye:white', 'dye:red'},
		{'advtrains_train_electric:train_hull', 'dye:white', 'advtrains_train_electric:train_engine'},
		{'advtrains_train_electric:steel_wheel', 'advtrains_train_electric:steel_wheel', 'advtrains_train_electric:steel_wheel'},
	},
})

minetest.register_craftitem("advtrains_train_electric:train_hull", {
	description = "Electric Train Hull",
	inventory_image = "advtrains_electric_train_hull.png",
})

minetest.register_craft({
	output = 'advtrains_train_electric:train_hull',
	recipe = {
		{'technic:stainless_steel_ingot', 'technic:stainless_steel_ingot', 'technic:stainless_steel_ingot'},
		{'default:glass', 'default:glass', 'default:glass'},
		{'technic:stainless_steel_ingot', 'technic:stainless_steel_ingot', 'technic:stainless_steel_ingot'},
	},
})


minetest.register_craftitem("advtrains_train_electric:train_engine", {
	description = "Electric Train Engine",
	inventory_image = "advtrains_electric_train_engine.png",
})

minetest.register_craft({
	output = 'advtrains_train_electric:train_engine',
	recipe = {
		{'basic_materials:gear_steel', 'basic_materials:gear_steel', 'basic_materials:gear_steel'},
		{'technic:red_energy_crystal', 'basic_materials:motor', 'technic:red_energy_crystal'},
		{'technic:lv_transformer', 'basic_materials:motor', 'technic:lv_transformer'},
	},
})

minetest.register_craftitem("advtrains_train_electric:steel_wheel", {
	description = "Steel Wheels",
	inventory_image = "advtrains_steel_wheel.png",
})

minetest.register_craft({
	output = 'advtrains_train_electric:steel_wheel',
	recipe = {
		{'', 'default:steel_ingot', ''},
		{'default:steel_ingot', 'basic_materials:steel_bar', 'default:steel_ingot'},
		{'', 'default:steel_ingot', ''},
	},
})


