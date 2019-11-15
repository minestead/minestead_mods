--[[
	Mod Sovagxas para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	NPC
  ]]

-- Variaveis sistematicas

-- Verificador do Bau de Sovagxas
-- Tempo (em segundos) que demora para um bau verificar se tem um sovagxa dele por perto
local tempo_verif_npc = 60
-- Distancia (om blocos) que um bau verifica em sua volta para encontrar seu proprio npc
local dist_verif_npc = 10

-- Verificador do npc sovagxa
-- Tempo (em segundos) que um npc demora para verificar se esta perto da pos de seu bau
local tempo_verif_bau = 20

-- Verificar distancia entre duas pos
local verif_dist_pos = function(pos1, pos2)
	local x = math.abs(math.abs(pos1.x)-math.abs(pos2.x))
	local y = math.abs(math.abs(pos1.y)-math.abs(pos2.y))
	local z = math.abs(math.abs(pos1.z)-math.abs(pos2.z))
	if x > z and x > y then return x end
	if y > x and y > z then return y end
	if z > x and z > y then return z end
	return x or y or z
end

-- Registrar um NPC
mobs:register_mob("sovagxas:npc", {
	type = "npc",
	passive = false,
	damage = 3,
	attack_type = "dogfight",
	attacks_monsters = true,
	pathfinding = false,
	hp_min = 10,
	hp_max = 20,
	armor = 100,
	collisionbox = {-0.35,-1.0,-0.35, 0.35,0.8,0.35},
	visual = "mesh",
	mesh = "sovagxas_sovagxa.b3d",
	drawtype = "front",
	textures = {
		{"sovagxas_sovagxa.png"}
	},
	makes_footstep_sound = true,
	sounds = {
		random = "sovagxas_sovagxa",
	},
	walk_velocity = 1.5,
	run_velocity = 3,
	jump = true,
	drops = {
		{name = "default:junglewood", chance = 1, min = 1, max = 3},
		{name = "default:apple", chance = 2, min = 1, max = 2},
		{name = "default:axe_wood", chance = 5, min = 1, max = 1},
	},
	water_damage = 0,
	lava_damage = 2,
	light_damage = 0,
	view_range = 15,
	owner = "",
	order = "follow",
	fear_height = 3,
	animation = {
		speed_normal = 20,
		speed_run = 20,
		stand_start = 0,
		stand_end = 80,
		walk_start = 168,
		walk_end = 188,
		run_start = 168,
		run_end = 188,
		punch_start = 200,
		punch_end = 220,
	},	
	
	do_custom = function(self, dtime)
		
		-- Verifica se esta perto do bau de origem
		self.temp = (self.temp or 0) + dtime
		if self.temp >= tempo_verif_bau then
		
			self.temp = 0
			
			-- Verificar se os dados ianda existem (podem sumir por um bug no restauro dos dados estaticos da entidade lua)
			if not self.pos_bau then
				self.object:remove()
				return
			end
			
			-- Verificar se esta perto do bau
			if verif_dist_pos(self.object:getpos(), self.pos_bau) > dist_verif_npc then
				self.object:remove()
				return
			end
			
			-- Verifica o se o bau de origem ainda existe
			local node = minetest.get_node(self.pos_bau)
			if node.name ~= "sovagxas:bau" then
				self.object:remove()
				return
			end
		end
		
	end,
	
})

-- Verifica se tem um npc
sovagxas.verif_bau_sovagxa = function(pos)
	
	-- Verifica se ja tem npc
	for  n,obj in ipairs(minetest.get_objects_inside_radius(pos, dist_verif_npc)) do
		local ent = obj:get_luaentity() or {}
		if ent.name == "sovagxas:npc" then -- Verifica se for mob certo
			return
		end
	end
	
	-- Verifica se tem jogadores (evitar)
	for  n,obj in ipairs(minetest.get_objects_inside_radius(pos, dist_verif_npc)) do
		if obj:is_player() then
			return
		end
	end
	
	-- Coloca novo npc
	local node = minetest.get_node(pos)
	local p = minetest.facedir_to_dir(node.param2)
	local spos = {x=pos.x-p.x,y=pos.y+1.5,z=pos.z-p.z}
	local obj = minetest.add_entity(spos, "sovagxas:npc") -- Cria o mob
	
	-- Salva alguns dados na entidade inicialmente
	if obj then
		local ent = obj:get_luaentity()
		ent.versao = sovagxas.versao
		ent.temp = 0 -- Temporizador
		ent.pos_bau = pos -- Pos do bau
	end
end

-- Coloca e verifica o Bau dos Sovagxas
minetest.register_abm({
	label = "Verificar npc",
	nodenames = {"sovagxas:bau"},
	interval = tempo_verif_npc,
	chance = 1,
	action = function(pos)
		local meta = minetest.get_meta(pos)
		
		-- Verificar versao
		if sovagxas.verif_comp(meta:get_string("versao")) ~= true then
			local node = minetest.get_node(pos)
			minetest.set_node(pos, {name="default:chest", param2 = node.param2})
			return
		end
		
		minetest.after(2, sovagxas.verif_bau_sovagxa, pos)
	end,
})


