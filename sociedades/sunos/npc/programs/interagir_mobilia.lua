--[[
	Mod Sunos para Minetest
	Copyright (C) 2018 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Programa para interagir com um node de mobilia próximo do NPC
  ]]

-- Tradução de strings
local S = sunos.S

-- Tabela interna
local interagir_mobilia = {}

-- Sons
local sons = {
	["sunos_batidas_bancada"] = {
		gain = 0.9,
	},
	["sunos_revirando_terra"] = {
		gain = 1,
	},
	["sunos_pilao"] = {
		gain = 0.8,
	},
	["sunos_bau_abrir_fechar"] = {
		gain = 0.8,
	},
}

-- tabela de animações
local animacoes = {
	["sunos_movimento_bancada.b3d"] = {
		-- Arquivo de malha
		name = "sunos_movimento_bancada.b3d",
		-- Animação para inicio
		pre_act_time = 1,
		pre_act_frame_start = 1,
		pre_act_frame_end = 60,
		pre_act_frame_speed = 25,
		-- Animação principal
		act_frame_start = 20,
		act_frame_end = 60,
		act_frame_speed = 25,
		-- Animação para fim
		pos_act_time = 1.7,
		pos_act_frame_start = 55,
		pos_act_frame_end = 160,
		pos_act_frame_speed = 20,
	},
	["sunos_movimento_bau.b3d"] = {
		-- Arquivo de malha
		name = "sunos_movimento_bau.b3d",
		-- Animação principal
		act_frame_start = 1,
		act_frame_end = 80,
		act_frame_speed = 25,
		act_time = 1.7,
	},
}

-- Tabela de caracteristicas de interação com cada mobilia
local mobilias = {
	["sunos:bancada_de_trabalho"] = {
		-- Tempo de atividade
		time = 8,
		-- Animações
		anim = animacoes["sunos_movimento_bancada.b3d"],
		-- Particulas
		particulas = {
			tipo = "simples",
			textura = "sunos_poeirinha.png",
		},
		-- Som
		som = {
			name = "sunos_batidas_bancada",
			gain = sons["sunos_batidas_bancada"].gain,
			alcance = 7,
		},
	},
	["sunos:caixa_de_musica"] = {
		-- Tempo de atividade
		time = 0,
		-- Animações
		anim = animacoes["sunos_movimento_bau.b3d"],
		-- Particulas
		-- Nenhum
		-- Som
		-- Nenhum
		-- Função pos ação
		pos_func = function(self, pos)
			minetest.registered_nodes["sunos:caixa_de_musica"].on_timer(pos, minetest.get_node_timer(pos):get_elapsed())
		end,
	},
	["sunos:bau_casa"] = {
		-- Tempo de atividade
		time = 0,
		-- Animações
		anim = animacoes["sunos_movimento_bau.b3d"],
		-- Particulas
		-- Nenhuma
		-- Som
		som = {
			name = "sunos_bau_abrir_fechar",
			gain = sons["sunos_bau_abrir_fechar"].gain,
			alcance = 7,
		},
	},
	["sunos:bau_loja"] = {
		-- Tempo de atividade
		time = 0,
		-- Animações
		anim = animacoes["sunos_movimento_bau.b3d"],
		-- Particulas
		-- Nenhuma
		-- Som
		som = {
			name = "sunos_bau_abrir_fechar",
			gain = sons["sunos_bau_abrir_fechar"].gain,
			alcance = 7,
		},
	},
	["sunos:kit_culinario"] = {
		-- Tempo de atividade
		time = 8,
		-- Animações
		anim = animacoes["sunos_movimento_bancada.b3d"],
		-- Particulas
		particulas = {
			tipo = "simples",
			textura = "sunos_poeirinha_comida.png",
		},
		-- Som
		som = {
			name = "sunos_pilao",
			gain = sons["sunos_pilao"].gain,
			alcance = 7,
		},
	},
	["sunos:tear_palha"] = {
		-- Tempo de atividade
		time = 8,
		-- Animações
		anim = animacoes["sunos_movimento_bancada.b3d"],
		-- Particulas
		particulas = {
			tipo = "simples",
			textura = "sunos_poeirinha_palha.png",
		},
		-- Som
		som = {
			name = "sunos_batidas_bancada",
			gain = sons["sunos_batidas_bancada"].gain,
			alcance = 7,
		},
	},
	["sunos:wood_barrel"] = {
		-- Tempo de atividade
		time = 8,
		-- Animações
		anim = animacoes["sunos_movimento_bancada.b3d"],
		-- Particulas
		particulas = {
			tipo = "simples",
			textura = "sunos_poeirinha_marrom.png",
		},
		-- Som
		som = {
			name = "sunos_revirando_terra",
			gain = sons["sunos_revirando_terra"].gain,
			alcance = 7,
		},
	},
}
-- Copiando tabela para versoes nodrop
mobilias["sunos:bancada_de_trabalho_nodrop"] = mobilias["sunos:bancada_de_trabalho"]
mobilias["sunos:tear_palha_nodrop"] = mobilias["sunos:tear_palha"]
mobilias["sunos:kit_culinario_nodrop"] = mobilias["sunos:kit_culinario"]
mobilias["sunos:wood_barrel_nodrop"] = mobilias["sunos:wood_barrel"]
mobilias["sunos:caixa_de_musica_nodrop"] = mobilias["sunos:caixa_de_musica"]


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

npc.programs.instr.register("sunos:rotate_to_pos", function(self, args)
	npc.programs.instr.execute(self, "advanced_npc:rotate", {
		start_pos = self.object:getpos(), 
		end_pos = args.pos,
	})
end)

npc.programs.instr.register("sunos:mark_place_used", function(self, args)
	npc.locations.mark_place_used(args.pos, args.value)
end)

npc.programs.instr.register("sunos:set_animation", function(self, args)
	
	-- Verifica se está perto da coordenada desejada
	if args.check_pos and verif_dist_pos(args.check_pos, self.object:getpos()) > 1.5 then return end
	
	self.object:set_properties({mesh = args.mesh})
	self.object:set_animation(
		{x = args.start_frame, y = args.end_frame},
		args.frame_speed, 
		0
	)

	-- Reset programado da animação
	if args.pos_reset_time then
		minetest.after(args.pos_reset_time, npc.programs.instr.execute, self, "sunos:reset_animation", {})
	end
end)

npc.programs.instr.register("sunos:reset_animation", function(self, args)
	self.object:set_properties({mesh = "sunos_character.b3d"})
	self.object:set_animation(
		{x = npc.ANIMATION_STAND_START, y = npc.ANIMATION_STAND_END},
        	30, 
        	0
        )
end)

-- Executa funcao mobilia do node
npc.programs.instr.register("sunos:execute_func_mobilia", function(self, args)
	
	-- Verifica se está perto da coordenada desejada
	if args.check_pos and verif_dist_pos(args.check_pos, self.object:getpos()) > 1.5 then return end
	
	-- Função para inicio do trabalho na mobilia
	if args.m and args.tipo == "pre" then
		if args.m.pre_func then
			args.m.pre_func(self, args.pos)
		end
	elseif args.tipo == "pos" then
		if args.m.pos_func then
			args.m.pos_func(self, args.pos)
		end
	end
end)

-- Cria particular de movimento
npc.programs.instr.register("sunos:add_efeito_interacao_mobilia", function(self, args)
	
	-- Verifica se está perto da coordenada desejada
	if args.check_pos and verif_dist_pos(args.check_pos, self.object:getpos()) > 1.5 then return end
	
	local mypos = self.object:getpos()
	
	-- Adiciona particulas em cima da bancada
	if args.m.particulas then
		-- Simples
		if args.m.particulas.tipo == "simples" then
			self.sunos_particlespawner_id = minetest.add_particlespawner({
				amount = args.m.time*10,
				time = args.m.time,
				minpos = {x = args.pos.x - 0.6, y = mypos.y + 1, z = args.pos.z - 0.6},
				maxpos = {x = args.pos.x + 0.6, y = mypos.y + 1.4, z = args.pos.z + 0.6},
				minvel = {x= -0.02, y= -0.02, z= -0.02},
				maxvel = {x= 0.02, y= 0.02, z= 0.02},
				minacc = {x= -0.02, y= -0.02, z= -0.02},
				maxacc = {x= 0.02, y= 0.05, z= 0.02},
				minexptime = 3,
				maxexptime = 3,
				minsize = 4,
				maxsize = 5,
				collisiondetection = false,
				texture = args.m.particulas.textura,
			})
		end
	end
	
	-- Tocar som
	if args.m.som then
		if (args.m.time or 0) > 0 then
			self.sunos_particlespawner_sound_handle = minetest.sound_play(args.m.som.name, {
				pos = args.pos,
				max_hear_distance = args.m.som.alcance,
				gain = args.m.som.gain,
				loop = true,
			})
			minetest.after(args.m.time, minetest.sound_stop, self.sunos_particlespawner_sound_handle)
		else
			self.sunos_particlespawner_sound_handle = minetest.sound_play(args.m.som.name, {
				pos = args.pos,
				max_hear_distance = args.m.som.alcance,
				gain = args.m.som.gain,
				loop = false,
			})
		end
	end
end)

-- Verificar se tem algum objeto obstruindos
local verif_obj_obs = function(pos)
	
	for _,obj in ipairs(minetest.get_objects_inside_radius({x=pos.x, y=pos.y, z=pos.z}, 0.5)) do
		return true
	end 
	for _,obj in ipairs(minetest.get_objects_inside_radius({x=pos.x, y=pos.y+1, z=pos.z}, 0.5)) do
		return true
	end 
	return false
end

-- Liberar mobilia para uso (caso fique travada a tag de uso impedindo outros NPCs)
local verif_mobilia_em_uso = function(pos, access_node)
	if verif_obj_obs(access_node) == false and minetest.get_meta(pos):get_string("advanced_npc:used") == "true" then
		npc.locations.mark_place_used(pos, "false")
	end
end

-- Escolher mobilia valida
interagir_mobilia.escolher_mobilia = function(self, place_names)
	if table.maxn(place_names) == 0 then return end
	
	-- Escolhe um aleatorio
	local i = math.random(1, #place_names)
	local name = place_names[i]
	-- Verifica se local está registrado no NPC
	if self.places_map[name] == nil then 
		table.remove(place_names, i)
		self.places_map[name] = nil -- Remove local
		return interagir_mobilia.escolher_mobilia(self, place_names)
	end
	-- Verificar node
	local nn = minetest.get_node(self.places_map[name].pos).name
	if nn == "air" then 
		table.remove(place_names, i)
		self.places_map[name] = nil -- Remove local
		return interagir_mobilia.escolher_mobilia(self, place_names)
	end
	if nn == "ignore" then 
		table.remove(place_names, i)
		self.places_map[name] = nil -- Remove local
		return interagir_mobilia.escolher_mobilia(self, place_names)
	end
	-- Verifica se está em uso
	if minetest.get_meta(self.places_map[name].pos):get_string("advanced_npc:used") == "true" then
		minetest.after(5, verif_mobilia_em_uso, 
			sunos.copy_tb(self.places_map[name].pos), 
			sunos.copy_tb(self.places_map[name].access_node)) -- Tenta liberar apos 5 segundos
		table.remove(place_names, i)
		return interagir_mobilia.escolher_mobilia(self, place_names)
	end
	-- Verifica se tem objeto obstruindo o acesso
	if verif_obj_obs(self.places_map[name].access_node) == true then
		table.remove(place_names, i)
		return interagir_mobilia.escolher_mobilia(self, place_names)
	end
	
	-- Verifica se nodename é aceitavel
	if sunos.nodes_de_mobilias[name] then
		for _,n in ipairs(sunos.nodes_de_mobilias[name]) do
			if n == nn then
				-- Node certo
				return sunos.copy_tb(self.places_map[name])
			end
		end
		-- Repete com o que restar
		table.remove(place_names, i)
		self.places_map[name] = nil -- Remove local
		return interagir_mobilia.escolher_mobilia(self, place_names)
	end
	-- Nao catalogado
	return nil
end
local escolher_mobilia = interagir_mobilia.escolher_mobilia

-- Encontrar node por perto e salva-lo no place map para interagir
local buscar_node_para_interagir = function(self, list, dist)
	local pos = self.object:getpos()
	local nodes = minetest.find_nodes_in_area(
		{x=pos.x-dist, y=pos.y-dist, z=pos.z-dist}, 
		{x=pos.x+dist, y=pos.y+dist, z=pos.z+dist}, 
		list
	)
	if nodes[1] == nil then return end
	
	-- Sorteia um dos encontrados
	local i = math.random(1, table.maxn(nodes))
	local v = minetest.facedir_to_dir(minetest.get_node(nodes[i]).param2)
	local acesso = vector.subtract(nodes[i], v)
	npc.locations.add_shared(self, "sunos_alvo_mobilia", "sunos_alvo_mobilia", nodes[i], acesso)
	return sunos.copy_tb(self.places_map["sunos_alvo_mobilia"])
end


-- Interagir aleatoriamente com a mobilia da casa
npc.programs.register("sunos:interagir_mobilia", function(self, args)
	
	-- Verifica se esta minimamente perto do checkin
	if sunos.p1_to_p2(
		self.object:getpos(), 
		sunos.copy_tb(self.sunos_checkin[tostring(sunos.npcs.npc.get_time())])) > 9
	then
		npc.exec.proc.enqueue(self, "advanced_npc:interrupt", {
			new_program = "advanced_npc:idle",
			new_args = {
				acknowledge_nearby_objs = true,
			},
			interrupt_options = {}
		})
		npc.exec.proc.enqueue(self, "advanced_npc:wait", {
			time = math.random(5, 10),
		})
	end
	
	-- Verificar total de lugares disponiveis no NPC
	local t = 0
	-- Conta o total
	if args.place_names then
		for _,n in ipairs(args.place_names) do
			if self.places_map[n] ~= nil then
				t = t + 1
			end
		end
	end
	
	-- Tabela do local no Place map
	local p = nil
	
	-- Verificar tabela de mobilias
	if self.sunos_interagir_mobilia_tb == nil then
		self.sunos_interagir_mobilia_tb = sunos.copy_tb(args.place_names)
	end
	
	local mypos = self.object:getpos()
	
	if args.place_names ~= nil then
		p = escolher_mobilia(self, sunos.copy_tb(args.place_names))
	elseif args.search ~= nil then
		p = buscar_node_para_interagir(self, args.search, (args.search_dist or 5))
		if p == nil then
			self.flags["sunos_checkin_status"] = "fora"
		end
	end
	
	-- Interagir com uma mobilia
	if p ~= nil then 
		
		-- Analisa node escolhido
		local m = mobilias[sunos.pegar_node(p.pos).name]
		if not m then
			minetest.log("error", "[Sunos] Node '"..sunos.pegar_node(p.pos).name.."' nao catalogado para interagir (programa 'sunos:interagir_mobilia')")
		else
			
			npc.locations.add_shared(self, "sunos_alvo_mobilia", "sunos_alvo_mobilia", p.pos, p.access_node)
			
			-- Marca node como em uso para evitar outros NPCs usarem
			npc.programs.instr.execute(self, "sunos:mark_place_used", {
				pos = p.pos,
				value = "true",
			})
			
			npc.exec.proc.enqueue(self, "advanced_npc:interrupt", {
				new_program = "advanced_npc:walk_to_pos",
				new_args = {
					optimize_one_node_distance = verif_dist_pos(p.pos, mypos) > 3,
					end_pos = {
						place_type="sunos_alvo_mobilia",
						use_access_node=true,
					},
					walkable = sunos.var.node_group.walkable,
				},
				interrupt_options = {}
			})
			
			-- Vira para "pos"
			npc.exec.proc.enqueue(self, "sunos:rotate_to_pos", {
				pos = p.pos,
			})
			
			-- Pré animação
			if (m.anim.pre_act_time or 0) > 0 then
				npc.exec.proc.enqueue(self, "sunos:set_animation", {
					mesh = m.anim.name,
					start_frame = m.anim.pre_act_frame_start,
					end_frame = m.anim.pre_act_frame_end,
					frame_speed = m.anim.pre_act_frame_speed,
					check_pos = p.pos,
				})
				npc.exec.proc.enqueue(self, "advanced_npc:wait", {
					time = m.anim.pre_act_time,
				})
			end
			
			-- Muda animação
			npc.exec.proc.enqueue(self, "sunos:set_animation", {
				mesh = m.anim.name,
				start_frame = m.anim.act_frame_start,
				end_frame = m.anim.act_frame_end,
				frame_speed = m.anim.act_frame_speed,
				-- Caso seja animação rapida sem loop
				pos_reset_time = m.anim.act_time,
				check_pos = p.pos,
			})
			
			-- Particulas
			npc.exec.proc.enqueue(self, "sunos:add_efeito_interacao_mobilia", {
				pos = p.pos,
				m = m,
				check_pos = p.pos,
			})
			
			-- Executa pré funcao da mobilia
			if m.pre_func ~= nil then
				npc.exec.proc.enqueue(self, "sunos:execute_func_mobilia", {
					tipo = "pre",
					pos = p.pos,
					m = m,
					check_pos = p.pos,
				})
			end
			
			-- Mantem trabalhando
			if (m.time or 0) > 0 then
				npc.exec.proc.enqueue(self, "advanced_npc:wait", {
					time = m.time,
				})
			end
			
			-- Executa pos funcao da mobilia
			if m.pos_func ~= nil then
				npc.exec.proc.enqueue(self, "sunos:execute_func_mobilia", {
					tipo = "pos",
					pos = p.pos,
					m = m,
					check_pos = p.pos,
				})
			end
			
			-- Pós animação
			if (m.anim.pos_act_time or 0) > 0 then
				npc.exec.proc.enqueue(self, "sunos:set_animation", {
					mesh = m.anim.name,
					start_frame = m.anim.pos_act_frame_start,
					end_frame = m.anim.pos_act_frame_end,
					frame_speed = m.anim.pos_act_frame_speed,
					pos_reset = true,
					pos_reset_time = m.anim.pos_act_time,
					check_pos = p.pos,
				})
			end
			
			-- Desmarca local em uso para outros NPCs poderem usar
			npc.exec.proc.enqueue(self, "sunos:mark_place_used", {
				pos = p.pos,
				value = "false",
			})
		end
	end
	-- Se estiver poucas mobilias fica um tempo parado apos interagir
	if t <= 3 then
		npc.exec.proc.enqueue(self, "advanced_npc:interrupt", {
			new_program = "advanced_npc:idle",
			new_args = {
				acknowledge_nearby_objs = true,
			},
			interrupt_options = {}
		})
		npc.exec.proc.enqueue(self, "advanced_npc:wait", {
			time = math.random(5, 10),
		})
	end
end)
