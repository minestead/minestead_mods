-- Minetest 5.4.1 : automobiles

automobiles_lib = {}

automobiles_lib.fuel = {['biofuel:biofuel'] = 10,['farming:bottle_ethanol'] = 2, ['tubelib_addons1:biofuel'] = 1}

automobiles_lib.gravity = 9.8
automobiles_lib.is_creative = minetest.settings:get_bool("creative_mode", false)

--cars colors
automobiles_lib.colors ={
    black='#2b2b2b',
    blue='#0063b0',
    brown='#8c5922',
    cyan='#07B6BC',
    dark_green='#567a42',
    dark_grey='#6d6d6d',
    green='#4ee34c',
    grey='#9f9f9f',
    magenta='#ff0098',
    orange='#ff8b0e',
    pink='#ff62c6',
    red='#dc1818',
    violet='#a437ff',
    white='#FFFFFF',
    yellow='#ffe400',
}

--
-- helpers and co.
--

function automobiles_lib.get_hipotenuse_value(point1, point2)
    return math.sqrt((point1.x - point2.x) ^ 2 + (point1.y - point2.y) ^ 2 + (point1.z - point2.z) ^ 2)
end

function automobiles_lib.dot(v1,v2)
	return (v1.x*v2.x)+(v1.y*v2.y)+(v1.z*v2.z)
end

function automobiles_lib.sign(n)
	return n>=0 and 1 or -1
end

function automobiles_lib.minmax(v,m)
	return math.min(math.abs(v),m)*minekart.sign(v)
end

--painting
function automobiles_lib.paint(self, colstr)
    if colstr then
        self._color = colstr
        local l_textures = self.initial_properties.textures
        for _, texture in ipairs(l_textures) do
            local indx = texture:find('automobiles_painting.png')
            if indx then
                l_textures[_] = "automobiles_painting.png^[multiply:".. colstr
            end
        end
	    self.object:set_properties({textures=l_textures})
    end
end

--returns 0 for old, 1 for new
function automobiles_lib.detect_player_api(player)
    local player_proterties = player:get_properties()
    local mesh = "character.b3d"
    if player_proterties.mesh == mesh then
        local models = player_api.registered_models
        local character = models[mesh]
        if character then
            if character.animations.sit.eye_height then
                return 1
            else
                return 0
            end
        end
    end

    return 0
end

-- attach player
function automobiles_lib.attach_driver(self, player)
    local name = player:get_player_name()
    self.driver_name = name

    -- attach the driver
    player:set_attach(self.driver_seat, "", {x = 0, y = 0, z = 0}, {x = 0, y = 0, z = 0})
    local eye_y = -4
    if automobiles_lib.detect_player_api(player) == 1 then
        eye_y = 2.5
    end
    player:set_eye_offset({x = 0, y = eye_y, z = 0}, {x = 0, y = eye_y, z = -30})
    player_api.player_attached[name] = true
    -- make the driver sit
    minetest.after(0.2, function()
        player = minetest.get_player_by_name(name)
        if player then
	        player_api.set_animation(player, "sit")
            --apply_physics_override(player, {speed=0,gravity=0,jump=0})
        end
    end)
end

function automobiles_lib.dettach_driver(self, player)
    local name = self.driver_name

    --self._engine_running = false

    -- driver clicked the object => driver gets off the vehicle
    self.driver_name = nil

    if self._engine_running then
	    self._engine_running = false
    end
    -- sound and animation
    if self.sound_handle then
        minetest.sound_stop(self.sound_handle)
        self.sound_handle = nil
    end

    -- detach the player
    if player then
        --automobiles_lib.remove_hud(player)

        player:set_detach()
        player_api.player_attached[name] = nil
        player:set_eye_offset({x=0,y=0,z=0},{x=0,y=0,z=0})
        player_api.set_animation(player, "stand")
    end
    self.driver = nil
end

-- attach passenger
function automobiles_lib.attach_pax(self, player, onside)
    local onside = onside or false
    local name = player:get_player_name()

    if onside == true then
        if self._passenger == nil then
            self._passenger = name

            -- attach the driver
            player:set_attach(self.passenger_seat, "", {x = 0, y = 0, z = 0}, {x = 0, y = 0, z = 0})
            local eye_y = -4
            if automobiles_lib.detect_player_api(player) == 1 then
                eye_y = 2.5
            end
            player:set_eye_offset({x = 0, y = eye_y, z = 0}, {x = 0, y = eye_y, z = -30})
            player_api.player_attached[name] = true
            -- make the driver sit
            minetest.after(0.2, function()
                player = minetest.get_player_by_name(name)
                if player then
	                player_api.set_animation(player, "sit")
                    --apply_physics_override(player, {speed=0,gravity=0,jump=0})
                end
            end)
        end
    else
        --randomize the seat
        --[[local t = {1,2,3,4,5,6,7,8,9,10}
        for i = 1, #t*2 do
            local a = math.random(#t)
            local b = math.random(#t)
            t[a],t[b] = t[b],t[a]
        end

        --for i = 1,10,1 do
        for k,v in ipairs(t) do
            i = t[k]
            if self._passengers[i] == nil then
                --minetest.chat_send_all(self.driver_name)
                self._passengers[i] = name
                player:set_attach(self._passengers_base[i], "", {x = 0, y = 0, z = 0}, {x = 0, y = 0, z = 0})
                if i > 2 then
                    player:set_eye_offset({x = 0, y = -4, z = 2}, {x = 0, y = 3, z = -30})
                else
                    player:set_eye_offset({x = 0, y = -4, z = 0}, {x = 0, y = 3, z = -30})
                end
                player_api.player_attached[name] = true
                -- make the driver sit
                minetest.after(0.2, function()
                    player = minetest.get_player_by_name(name)
                    if player then
	                    player_api.set_animation(player, "sit")
                        --apply_physics_override(player, {speed=0,gravity=0,jump=0})
                    end
                end)
                break
            end
        end]]--

    end
end

function automobiles_lib.dettach_pax(self, player)
    local name = player:get_player_name() --self._passenger

    -- passenger clicked the object => driver gets off the vehicle
    if self._passenger == name then
        self._passenger = nil
    else
        --[[for i = 10,1,-1 
        do 
            if self._passengers[i] == name then
                self._passengers[i] = nil
                break
            end
        end]]--
    end

    -- detach the player
    if player then
        player:set_detach()
        player_api.player_attached[name] = nil
        player_api.set_animation(player, "stand")
        player:set_eye_offset({x=0,y=0,z=0},{x=0,y=0,z=0})
        --remove_physics_override(player, {speed=1,gravity=1,jump=1})
    end
end

function automobiles_lib.get_gauge_angle(value, initial_angle)
    initial_angle = initial_angle or 90
    local angle = value * 18
    angle = angle - initial_angle
    angle = angle * -1
	return angle
end

function automobiles_lib.setText(self, vehicle_name)
    local properties = self.object:get_properties()
    local formatted = ""
    if self.hp_max then
        formatted = " Current hp: " .. string.format(
           "%.2f", self.hp_max
        )
    end
    if properties then
        properties.infotext = "Nice ".. vehicle_name .." of " .. self.owner .. "." .. formatted
        self.object:set_properties(properties)
    end
end

function automobiles_lib.get_xz_from_hipotenuse(orig_x, orig_z, yaw, distance)
    --cara, o minetest é bizarro, ele considera o eixo no sentido ANTI-HORÁRIO... Então pra equação funcionar, subtrair o angulo de 360 antes
    yaw = math.rad(360) - yaw
    local z = (math.cos(yaw)*distance) + orig_z
    local x = (math.sin(yaw)*distance) + orig_x
    return x, z
end

function automobiles_lib.remove_light(self)
    if self._light_old_pos then
        --force the remotion of the last light
        minetest.add_node(self._light_old_pos, {name="air"})
        self._light_old_pos = nil
    end
end

function automobiles_lib.swap_node(self, pos)
    local target_pos = pos
    local have_air = false
    local node = nil
    local count = 0
    while have_air == false and count <= 3 do
        node = minetest.get_node(target_pos)
        if node.name == "air" then
            have_air = true
            break
        end
        count = count + 1
        target_pos.y = target_pos.y + 1
    end
    
    if have_air then
        minetest.set_node(target_pos, {name='automobiles_lib:light'})
        automobiles_lib.remove_light(self)
        self._light_old_pos = target_pos
        --remove after one second
        --[[minetest.after(1,function(target_pos)
            local node = minetest.get_node_or_nil(target_pos)
            if node and node.name == "automobiles_lib:light" then
                minetest.swap_node(target_pos, {name="air"})
            end
        end, target_pos)]]--
        return true
    end
    return false
end

function automobiles_lib.put_light(self)
    local pos = self.object:get_pos()
    pos.y = pos.y + 1
    local yaw = self.object:get_yaw()
    local lx, lz = automobiles_lib.get_xz_from_hipotenuse(pos.x, pos.z, yaw, 10)
    local light_pos = {x=lx, y=pos.y, z=lz}

	local cast = minetest.raycast(pos, light_pos, false, false)
	local thing = cast:next()
    local was_set = false
	while thing do
		if thing.type == "node" then
            local ipos = thing.intersection_point
            if ipos then
                was_set = automobiles_lib.swap_node(self, ipos)
            end
        end
        thing = cast:next()
    end
    if was_set == false then
        local n = minetest.get_node_or_nil(light_pos)
        if n and n.name == 'air' then
            automobiles_lib.swap_node(self, light_pos)
        end
    end


    --[[local n = minetest.get_node_or_nil(light_pos)
    --minetest.chat_send_player(name, n.name)
    if n and n.name == 'air' then
        minetest.set_node(pos, {name='automobiles_lib:light'})
        --local timer = minetest.get_node_timer(pos)
        --timer:set(10, 0)
        minetest.after(0.3,function(pos)
            local node = minetest.get_node_or_nil(pos)
            if node and node.name == "automobiles_lib:light" then
                minetest.swap_node(pos, {name="air"})
            end
        end, pos)
    end]]--

end

minetest.register_node("automobiles_lib:light", {
	drawtype = "glasslike",
	tile_images = {"automobiles_light.png"},
	inventory_image = minetest.inventorycube("automobiles_light.png"),
	paramtype = "light",
	walkable = false,
	is_ground_content = true,
	light_propagates = true,
	sunlight_propagates = true,
	light_source = 14,
	selection_box = {
		type = "fixed",
		fixed = {0, 0, 0, 0, 0, 0},
	},
})

dofile(minetest.get_modpath("automobiles_lib") .. DIR_DELIM .. "custom_physics.lua")
dofile(minetest.get_modpath("automobiles_lib") .. DIR_DELIM .. "control.lua")
dofile(minetest.get_modpath("automobiles_lib") .. DIR_DELIM .. "fuel_management.lua")
dofile(minetest.get_modpath("automobiles_lib") .. DIR_DELIM .. "ground_detection.lua")

-- engine
minetest.register_craftitem("automobiles_lib:engine",{
	description = "Car engine",
	inventory_image = "automobiles_engine.png",
})

if minetest.get_modpath("default") then
	minetest.register_craft({
		output = "automobiles_lib:engine",
		recipe = {
			{"basic_materials:gear_steel","basic_materials:gear_steel","basic_materials:gear_steel"},
			{"pipeworks:pipe_1_empty","default:steelblock", "pipeworks:pipe_1_empty"},
			{"pipeworks:pipe_1_empty","basic_materials:gear_steel", "pipeworks:pipe_1_empty"},
		}
	})
end
