ufos = {}

local floor_pos = function(pos)
	return {x=math.floor(pos.x),y=math.floor(pos.y),z=math.floor(pos.z)}
end

local UFO_SPEED = 1
local UFO_TURN_SPEED = 2
local UFO_MAX_SPEED = 10
local UFO_FUEL_USE = .01

fuel_from_wear = function(wear)
	local fuel
	if wear == 0 then
		fuel = 0
	else
		fuel = (65535-(wear-1))*100/65535
	end
	return fuel
end

wear_from_fuel = function(fuel)
	local wear = (100-(fuel))*65535/100+1
	if wear > 65535 then wear = 0 end
	return wear
end

get_fuel = function(self)
	return self.fuel
end

set_fuel = function(self,fuel,object)
	self.fuel = fuel
end

ufo_from_item = function(itemstack,placer,pointed_thing)
	-- restore the fuel inside the item
	local wear = itemstack:get_wear()
	set_fuel(miniufo,fuel_from_wear(wear))
	-- add the entity
	e = minetest.add_entity(pointed_thing.above, "ufowreck:miniufo")
	-- set high hp to not destroy it with guns etc
	e:set_hp(1000000)
	-- remove the item
	itemstack:take_item()
end

miniufo = {
	physical = true,
	collisionbox = {-1.5,0,-1.5, 1.5,1.2,1.5},
	visual = "mesh",
	mesh = "ufo.x",
	textures = {"ufo_0.png"},
	groups = {immortal=1},
	glow = 5,
	driver = nil,
	v = 0,
	fuel = 0,
	fueli = 0
}

function miniufo.on_rightclick(self, clicker)
	if not clicker or not clicker:is_player() then
		return
	end
	local name = clicker:get_player_name()
	if self.driver and name == self.driver then
		self.driver = nil
		self.auto = false
		clicker:set_detach()
		player_api.player_attached[name] = false
		player_api.set_animation(clicker, "stand" , 30)
		local pos = clicker:get_pos()
		pos = {x = pos.x, y = pos.y + 0.2, z = pos.z}
		minetest.after(0.1, function()
			clicker:set_pos(pos)
		end)
	elseif not self.driver then
		local attach = clicker:get_attach()
		if attach and attach:get_luaentity() then
			local luaentity = attach:get_luaentity()
			if luaentity.driver then
				luaentity.driver = nil
			end
			clicker:set_detach()
		end
		self.driver = name
		clicker:set_attach(self.object, "", {x=0,y=1.0,z=0}, {x=0,y=0,z=0})
		player_api.player_attached[name] = true
--		minetest.after(0.2, function()
--			player_api.set_animation(clicker, "sit" , 30)
--		end)
		clicker:set_look_horizontal(self.object:get_yaw())
	end
end

function miniufo:on_activate (staticdata, dtime_s)
	local data = staticdata:split(';')
	if data and data[1] and data[2] then
--		self.owner_name = data[1]
		self.name = data[1]
		self.fuel = tonumber(data[2])
	end
	self.object:set_armor_groups({immortal=1})
end

function miniufo:on_punch(puncher, time_from_last_punch, tool_capabilities, direction)
	if puncher and puncher:is_player() then
		local inv = puncher:get_inventory()
		local wear = wear_from_fuel(get_fuel(self))
		local leftover = inv:add_item("main", {name="ufowreck:miniufo", wear = wear})
		if not leftover:is_empty() then
			minetest.add_item(self.object:get_pos(), leftover)
		end
		self.object:remove()
	end
end

function miniufo:on_step (dtime)
	local fuel = get_fuel(self)
	if self.driver then
		local driver_objref = minetest.get_player_by_name(self.driver)
		if driver_objref then
			local ctrl = driver_objref:get_player_control()
--		local ctrl = self.driver:get_player_control()
		local vel = self.object:get_velocity()
		if fuel == nil then fuel = 0 end
		if fuel > 0 and ctrl.up then
			vel.x = vel.x + math.cos(self.object:getyaw()+math.pi/2)*UFO_SPEED
			vel.z = vel.z + math.sin(self.object:getyaw()+math.pi/2)*UFO_SPEED
			fuel = fuel - UFO_FUEL_USE
		else
			vel.x = vel.x*.99
			vel.z = vel.z*.99
		end
		if ctrl.down then
			vel.x = vel.x*.9
			vel.z = vel.z*.9
		end
		if fuel > 0 and ctrl.jump then
			vel.y = vel.y+UFO_SPEED
			fuel = fuel - UFO_FUEL_USE
		elseif fuel > 0 and ctrl.sneak then
			vel.y = vel.y-UFO_SPEED
			fuel = fuel - UFO_FUEL_USE
		else
			vel.y = vel.y*.9
		end
		if vel.x > UFO_MAX_SPEED then vel.x = UFO_MAX_SPEED end
		if vel.x < -UFO_MAX_SPEED then vel.x = -UFO_MAX_SPEED end
		if vel.y > UFO_MAX_SPEED then vel.y = UFO_MAX_SPEED end
		if vel.y < -UFO_MAX_SPEED then vel.y = -UFO_MAX_SPEED end
		if vel.z > UFO_MAX_SPEED then vel.z = UFO_MAX_SPEED end
		if vel.z < -UFO_MAX_SPEED then vel.z = -UFO_MAX_SPEED end
		self.object:set_velocity(vel)
		if ctrl.left then
			self.object:setyaw(self.object:getyaw()+math.pi/120*UFO_TURN_SPEED)
		end
		if ctrl.right then
			self.object:setyaw(self.object:getyaw()-math.pi/120*UFO_TURN_SPEED)
		end
		end
	else
	        self.object:set_velocity({x=0, y=0, z=0})
	end
	
	if fuel < 0 then fuel = 0 end
	if fuel > 100 then fuel = 100 end
	if self.fueli ~= math.floor(fuel*8/100) then
		self.fueli = math.floor(fuel*8/100)
		print(self.fueli)
		self.textures = {"ufo_"..self.fueli..".png"}
		self.object:set_properties(self)
	end
	set_fuel(self,fuel)
end

function miniufo:get_staticdata()
	return self.name..";"..tostring(self.fuel)
end

minetest.register_entity("ufowreck:miniufo", miniufo)


--register tool (with/without technic mod)
local tooldef = {
	description = "miniufo",
	inventory_image = "ufos_inventory.png",
	wield_image = "ufos_inventory.png",
	tool_capabilities = {load=0,max_drop_level=0, groupcaps={fleshy={times={}, uses=100, maxlevel=0}}},
	
	on_place = function(itemstack, placer, pointed_thing)
		if pointed_thing.type ~= "node" then
			return
		end
		
		-- Call on_rightclick if the pointed node defines it
		if placer and not placer:get_player_control().sneak then
			local n = minetest.get_node(pointed_thing.under)
			local nn = n.name
			if minetest.registered_nodes[nn] and minetest.registered_nodes[nn].on_rightclick then
				return minetest.registered_nodes[nn].on_rightclick(pointed_thing.under, n, placer, itemstack) or itemstack
			end
		end
		
		ufo_from_item(itemstack,placer,pointed_thing)
		return itemstack
	end,
}

if technic then
        tooldef.on_refill = technic.refill_RE_charge
        tooldef.wear_represents = "technic_RE_charge"
        technic.register_power_tool("ufowreck:miniufo", 2000000)
end
minetest.register_tool("ufowreck:miniufo", tooldef)

minetest.register_craft( {
	output = 'ufowreck:miniufo',
	recipe = {
		{ "ufowreck:alien_control", "xdecor:cushion", "ufowreck:alien_metal"},
		{ "ufowreck:alien_metal", "ufowreck:alien_engine", "ufowreck:alien_metal"},
		{ "default:meselamp", "tubelib:lamp", "default:meselamp"},
	},
})
