--[[
	Mod Sunos para Minetest
	Copyright (C) 2018 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Mob comum das vilas
  ]]

-- Tabela global
sunos.npcs.npc = {}

-- Tabela de tipos de NPCs sunos registrados
sunos.npcs.npc.registrados = {}

-- Variaveis sistematicas

-- Verificador do Bau de sunos
-- Tempo (em segundos) que demora para um bau verificar se tem um suno dele por perto
local tempo_verif_npc = 5--20
-- Distancia (om blocos) que um bau verifica em sua volta para encontrar seu proprio npc
local dist_verif_npc = 10

-- Tempo para bau verificar se deve spawner novo npc
timeout_bau = 5--20

-- Verificador do npc suno comum 
-- Tempo (em segundos) que um npc demora para verificar se esta perto da pos de seu bau
sunos.timer_npc_check = 10

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

-- Pegar horario atual em minetest para checkins
sunos.npcs.npc.get_time = function()
	local time = minetest.get_timeofday() * 24
	time = (time) - (time % 1)
	return time
end

-- Encontrar lugar desocupado dentre lugares fornecidos
local buscar_node_livre = function(self, place_names)
	for _,name in ipairs(place_names) do
		if self.places_map[name] and minetest.get_meta(self.places_map[name].pos):get_string("advanced_npc:used") ~= "true" then
			return name
		end
	end
	return nil
end

-- Spawners
tabela_spawners = {}

-- Tabela de npcs ativos no mundo
--[[
	Essa tabela conecta um determinado hash de npc ao seu objeto,
	caso esteja nulo, o objeto não esta mais carregado ou morreu.
  ]]
sunos.npcs.npc.ativos = {}

-- Verificar se o NPC de um node está ativo
sunos.npcs.is_active = function(npcnode_pos)
	local hash = minetest.get_meta(npcnode_pos):get_string("sunos_npchash")
	if hash ~= "" and sunos.npcs.npc.ativos[hash] and sunos.npcs.npc.ativos[hash]:getpos() then
		return true
	end
	return false
end

-- Spawnar um NPC
sunos.npcs.npc.spawn = function(tipo, vila, npcnode_pos, spos)
	if not tipo then
		minetest.log("error", "[Sunos] tipo nulo (em sunos.npcs.npc.spawn)")
		return false
	end
	if not sunos.npcs.npc.registrados[tipo] then
		minetest.log("error", "[Sunos] tipo invalido (em sunos.npcs.npc.spawn)")
		return false
	end
	if not vila then
		minetest.log("error", "[Sunos] vila nula (em sunos.npcs.npc.spawn)")
		return false
	end
	if not npcnode_pos then
		minetest.log("error", "[Sunos] npcnode_pos nula (em sunos.npcs.npc.spawn)")
		return false
	end
	if not spos then
		minetest.log("error", "[Sunos] faltou coordenada para spawnar (em sunos.npcs.npc.spawn)")
		return false
	end
		
	local obj = minetest.add_entity(spos, "sunos:npc_"..tipo) -- Cria o mob
	
	-- Salva alguns dados na entidade inicialmente
	if obj then
		local ent = obj:get_luaentity()
		ent.tipo = tipo -- Tipo de npc
		ent.temp = 0 -- Temporizador
		ent.versao = sunos.versao -- Versao do mod
		ent.vila = vila -- numero da vila
		ent.mypos = npcnode_pos -- pos do npcnode de spawn (bau)
		ent.mynode = minetest.get_node(npcnode_pos).name -- nome do node de spawn (bau)
		ent.sunos_fundamento = minetest.deserialize(minetest.get_meta(npcnode_pos):get_string("pos_fundamento"))
		ent.sunos_checkin_status = "dentro"
		
		-- Gera um hash numerico com a data e coordenada
		local hash = minetest.pos_to_string(npcnode_pos)..os.date("%Y%m%d%H%M%S")
		
		ent.sunos_npchash = hash -- Salva no npc
		sunos.npcs.npc.ativos[hash] = ent.object -- salva na tabela de npcs ativos
		minetest.get_meta(ent.mypos):set_string("sunos_npchash", hash) -- Salva no bau
		
		-- Flags
		ent.flags["sunos_checkin_status"] = "dentro"
		ent.flags["sunos_target_status"] = "nenhum"
		ent.flags["sunos_repouso_status"] = "nenhum"
		
		-- Finaliza registro nos sunos
		ent.sunos_registrado = true
		
		-- Realiza chamadas que foram impedidas
		-- 'on_spawn'
		if sunos.npcs.npc.registrados[tipo].on_spawn then
			sunos.npcs.npc.registrados[tipo].on_spawn(ent)
		end
		
		-- Retorna a entidade
		return ent
	else
	
		return false
	end
	
end


-- Envia o npc para o checkin
--[[
    Retorna true se conseguir enviar ação
    Retorna false se nao conseguir
  ]]
sunos.npcs.npc.send_to_checkin = function(self)
	if not self or not self.object or not self.object:getpos() then return end
	
	local pos1 = sunos.copy_tb(self.object:getpos())
	local pos2 = sunos.copy_tb(self.sunos_checkin[tostring(sunos.npcs.npc.get_time())])
	local cmds = 0
	local dist = sunos.p1_to_p2(pos1, pos2)
	
	while (dist >= 15) do
		local pos_indo = sunos.ir_p1_to_p2(pos1, pos2, 7)
		
		-- Escolher caminho
		-- 1º Rua calcetada
		local alvo = minetest.find_node_near(pos_indo, 4, {"sunos:rua_calcetada"}, true)
		-- 2º Gramado
		if not alvo then
			alvo = minetest.find_node_near(pos_indo, 4, {"default:dirt_with_grass"}, true)
		end
		
		if alvo then
			if alvo then alvo.y = alvo.y+1 end
		end
		
		if alvo then
			-- Atualiza numero do comando
			cmds = cmds + 1 
			-- Salva o local para andar
			npc.locations.add_shared_accessible_place(
				self, 
				{owner="", node_pos=alvo}, 
				"sunos_npc_walk_"..cmds, 
				true,
				{}
			)
			npc.programs.execute(self, "advanced_npc:walk_to_pos", {
				end_pos = "sunos_npc_walk_"..cmds,
				walkable = {}
			})
		end
		
		-- Atualiza para proximo loop
		pos1 = sunos.copy_tb(pos_indo)
		dist = sunos.p1_to_p2(pos1, pos2)
	end
	
	if cmds > 0 then 
		return true
	else
		return false
	end
end

-- Verificar se é NPc do bau
local verif_npc_bau = function(self)
	if self.object and self.mypos and self.sunos_npchash then
		-- Verifica se é o npc atual de seu node
		if minetest.get_meta(self.mypos):get_string("sunos_npchash") ~= self.sunos_npchash then
			return false
		else
			return true
		end
	end
	return false
end

-- Instrução para manter deitado
npc.programs.instr.register("sunos:definir_deitado", function(self, args)
	local node = minetest.get_node(args.pos)
	local dir = minetest.facedir_to_dir(node.param2)
	local bed_pos = npc.programs.instr.nodes.beds[node.name].get_lay_pos(args.pos, dir)
	
	npc.programs.instr.execute(self, npc.programs.instr.default.SIT, {pos=bed_pos, dir=(node.param2 + 2) % 4})
	npc.programs.instr.execute(self, npc.programs.instr.default.LAY, {})
	-- Marca cama em uso
	npc.locations.mark_place_used(args.pos, "true")
end)

-- Tabela de temporizadores
local tb_timers = {}

-- Register temporizador STEP
--[[
	Argumentos
	#1 String do tipo de NPC (conferido para realizar o temporizador)
	#2 Tabela de definições
		{
			time = 5, -- Tempo em segundos
			func = function(self), -- Funçao executada ao termino do tempo 
			  --(se retornar algo diferente de nulo, o retorno é enviado para a API mobs_redo como retorno da callback do_custom)
		}
  ]]
sunos.npcs.npc.register_step = function(tipo, def)
	if tb_timers[tipo] == nil then tb_timers[tipo] = {} end
	
	-- Tabela de dados do registro
	table.insert(tb_timers[tipo], def)
end

-- Registrar um NPC
sunos.npcs.npc.registrar = function(tipo, def)
	if not tipo then
		minetest.log("error", "[Sunos] Tipo de npc invalido (em sunos.registrar_npc)")
		return false
	end
	if not def then
		minetest.log("error", "[Sunos] Tabela def nula (em sunos.registrar_npc)")
		return false
	end
	
	-- Cria o registro na tabela global
	sunos.npcs.npc.registrados[tipo] = def
	
	-- Registrar um mob
	mobs:register_mob("sunos:npc_"..tipo, {
		type = "npc",
		passive = false,
		damage = 3,
		attack_type = "dogfight",
		attacks_monsters = true,
		pathfinding = true,
		hp_min = 10,
		hp_max = 20,
		armor = 100,
		collisionbox = {-0.35,0.0,-0.35, 0.35,1.8,0.35},
		visual = "mesh",
		mesh = "sunos_character.b3d",
		drawtype = "front",
		textures = {
			{"sunos_npc_male.png"},
			{"sunos_npc_female.png"},
		},
		makes_footstep_sound = true,
		sounds = {},
		walk_velocity = 2,
		run_velocity = 3,
		jump = true,
		drops = def.drops,
		water_damage = 0,
		lava_damage = 2,
		light_damage = 0,
		view_range = 15,
		owner = "",
		order = "follow",
		fear_height = 7,
		animation = {
			speed_normal = 30,
			speed_run = 30,
			stand_start = 0,
			stand_end = 79,
			walk_start = 168,
			walk_end = 187,
			run_start = 168,
			run_end = 187,
			punch_start = 200,
			punch_end = 219,
		},
		
		
		on_spawn = function(self)
		
			if self.initialized == nil then
				npc.initialize(self, self.object:getpos(), true, nil, {name={tags={"sunos"}}})
				self.tamed = false
			end
			
			-- Constroi temporizadores de acordo com os atualmente registrados
			self.sunos_t = {}
			for n,d in ipairs(tb_timers[tipo]) do
				self.sunos_t[n] = 0
			end
			
			-- Verifica se já está registrado
			if self.sunos_registrado == true then
				-- Verifica a versao do mod
				if sunos.verif_comp(self.versao or "") == false then
					self.object:remove()
					return
				end
				-- executa on_spawn registrado
				if sunos.npcs.npc.registrados[tipo].on_spawn then
					sunos.npcs.npc.registrados[tipo].on_spawn(self)
				end
			end
			
			-- Verifica se está durmindo
			if self.npc_state.movement.is_laying == true then
				if minetest.get_node(self.sunos_cama_usada).name == "beds:bed_bottom" then
					npc.programs.instr.execute(self, "sunos:definir_deitado", {pos=self.sunos_cama_usada})
				else
					sunos.debug("NPC teve sua cama removida enquanto durmia "..minetest.pos_to_string(self.object:getpos()))
				end
			end
			
		end,
		
		-- Atualiza dados com tabela de NPCs ativos
		after_activate = function(self, staticdata, def, dtime)

			-- Verifica se está registrado
			if self.sunos_registrado == true then
				
				-- Verifica se é o npc atual de seu node
				local node = sunos.pegar_node(self.mypos) -- Certifica que carregou no node
				if minetest.get_meta(self.mypos):get_string("sunos_npchash") ~= self.sunos_npchash then
					self.object:remove()
					return
				else
					-- Atualiza tabela de npcs ativos
					sunos.npcs.npc.ativos[self.sunos_npchash] = self.object
				end
				
				-- Realiza procedimento personalizado
				if sunos.npcs.npc.registrados[tipo].after_activate then
					sunos.npcs.npc.registrados[tipo].after_activate(self, staticdata, def, dtime)
				end
			end
		end,
	
		do_custom = function(self, dtime)
			
			-- Verifica se spawnou corretamente
			if not self.tipo then
				self.object:remove()
				return
			end
			
			if verif_npc_bau(self) == false then
				self.object:remove()
				return 
			end
			
			-- Realiza timers registrados
			for n,d in ipairs(tb_timers[tipo]) do
				self.sunos_t[n] = self.sunos_t[n] + dtime
				-- Verifica se atingiu o tempo
				if self.sunos_t[n] >= tb_timers[tipo][n].time then
					self.sunos_t[n] = 0 -- zera temporizador
					local r = tb_timers[tipo][n].func(self, dtime)
					if r ~= nil then
						return r
					end
				end
			end
			
			-- Evita continuar se esta em luta
			if self.state == "attack" then
				return
			end
			
			-- Realiza procedimento personalizado
			if sunos.npcs.npc.registrados[self.tipo].on_step then
				sunos.npcs.npc.registrados[self.tipo].on_step(self, dtime)
			end
			
			return npc.step(self, dtime)
		
		end,
		
		-- Ao ser socado
		do_punch = function(self, hitter, time_from_last_punch, tool_capabilities, direction)
			if hitter and hitter:is_player() == true then
				self.attack = obj
				self.state = "attack"
				sunos.novo_inimigo(self.vila, hitter:get_player_name())
			end
		end,
		
		-- Clique direito (acessar)
		on_rightclick = function(self, player)
			if sunos.npcs.npc.registrados[tipo].on_rightclick then 
				return sunos.npcs.npc.registrados[tipo].on_rightclick(self, player) 
			end
		end, 
		
	})
	
	-- Verifica se quer durmir (atravez de uma flag)
	sunos.npcs.npc.register_step(tipo, {
		time = 10,
		func = function(self, dtime)
			
			-- Verifica se deve ir durmir
			if self.flags["sunos_repouso_status"] == "durmir" then
				
				-- Verifica se ja esta durmindo
				if self.npc_state.movement.is_laying == true then
					self.flags["sunos_repouso_status"] = "nenhum"
					return
				end
				
				local target_name = buscar_node_livre(self, {"cama_1", "cama_2", "cama_3"})
				
				if target_name == nil then
					sunos.debug("NPC sem cama livre no place map em "..minetest.pos_to_string(self.object:getpos()))
					return
				end
				local target = self.places_map[target_name]
				
				-- Verific se esta muito distante da cama
				if sunos.p1_to_p2(
					self.object:getpos(), 
					target.pos) > 10
				then
					self.flags["sunos_repouso_status"] = "nenhum"
					return
				end
				
				-- Verifica se alvo tem cama ainda e se está livre
				if minetest.get_node(target.pos).name ~= "beds:bed_bottom"
					or minetest.get_meta(target.pos):get_string("advanced_npc:used") == "true" 
				then
					self.flags["sunos_repouso_status"] = "nenhum"
					return
				end
				
				-- Envia NPC pra cama
				npc.exec.enqueue_program(self, "advanced_npc:walk_to_pos", {
					end_pos = target.access_node,
				})
				npc.exec.enqueue_program(self, "advanced_npc:use_bed", {
					pos = target.pos,
					action = npc.programs.const.node_ops.beds.LAY
				})
				npc.exec.enqueue_program(self, "advanced_npc:idle", 
					{
						acknowledge_nearby_objs = false,
						wander_chance = 0
					},
					{},
					true
				)
				-- Salva ultima cama usada para recoloca-lo caso precise
				self.sunos_cama_usada = sunos.copy_tb(target.pos)
				-- Trava o local mesmo antes de o NPC chegar na cama (evitar que outro a pegue)
				npc.locations.mark_place_used(target.pos, "true")
				
				sunos.debug("NPC "..minetest.pos_to_string(self.object:getpos())
					.." indo durmir na cama "..minetest.pos_to_string(target.pos))
				self.flags["sunos_repouso_status"] = "nenhum"
				
			end
		end, 
		
	})
	
	-- Verifica se é o NPC atual do proprio npcnode (confere hash)
	sunos.npcs.npc.register_step(tipo, {
		time = 11,
		func = function(self, dtime)
			local node = sunos.pegar_node(self.mypos) -- Certifica que carregou no node
			if minetest.get_meta(self.mypos):get_string("sunos_npchash") ~= self.sunos_npchash then
				sunos.debug("NPC "..minetest.pos_to_string(self.object:getpos())
					.." possui hash invalido")
				return
			end
		end, 
		
	})
					
	-- Verifica se algum dos jogadores proximos é um inimigo
	sunos.npcs.npc.register_step(tipo, {
		time = 8,
		func = function(self, dtime)
			if self.state ~= "attack" then -- Verifica se ja não está em um ataque
				for _,obj in ipairs(minetest.get_objects_inside_radius(self.object:getpos(), 13)) do
					if obj:is_player() then
					
						-- Verifica se o jogador é inimigo
						if sunos.verif_inimigo(self.vila, obj:get_player_name()) == true then
							self.attack = obj
							self.state = "attack"
							return npc.step(self, dtime)
						end
				
					end
				end
			end
		end,
	})
	
	-- Registra envio ao checkin
	sunos.npcs.npc.register_step(tipo, {
		time = 10,
		func = function(self, dtime)
			
			-- Verifica se tem checkin
			if not self.sunos_checkin then
				return
			end
			
			-- Verificiar se deve ir para o checkin atual
			if self.sunos_checkin_status ~= "indo" -- Não está indo
				and self.sunos_checkin_status ~= "enviado" -- Não foi enviado
				and sunos.p1_to_p2(
					self.object:getpos(), 
					sunos.copy_tb(self.sunos_checkin[tostring(sunos.npcs.npc.get_time())])) > 10 
				
			then
				self.sunos_checkin_status = "enviado"
				
				npc.exec.enqueue_program(self, "sunos:walk_to_checkin", {
					end_pos = sunos.copy_tb(self.sunos_checkin[tostring(sunos.npcs.npc.get_time())]),
					dist_min = 10,
				})
			end
		end,
	})
	
	
end


-- Verifica se cama está liberada para destrava-la
minetest.register_abm({
	nodenames = {"beds:bed_bottom"},
	interval = 20,
	chance = 1,
	action = function(pos)
		-- Verifica se tem algum objeto perto da cama
		for _,obj in ipairs(minetest.get_objects_inside_radius({x=pos.x, y=pos.y+1, z=pos.z}, 1.5)) do
			return -- Ja retorna sem mexer nada
		end 
		
		-- Verifica se ja esta liberada
		if minetest.get_meta(pos):get_string("advanced_npc:used") ~= "false" then
			npc.locations.mark_place_used(pos, "false")
		end
	end,
})
