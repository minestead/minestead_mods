--[[
	Mod Sunos para Minetest
	Copyright (C) 2018 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Programa para fazer o NPC andar até o checkin
  ]]


-- Andar trecho de caminho até o checkin
npc.programs.instr.register("sunos:walk_to_checkin_check", function(self, args)
	--minetest.chat_send_all("sunos:walk_to_checkin_check")
	-- Verifica distancia atual
	if sunos.p1_to_p2(
		self.object:getpos(), 
		sunos.copy_tb(self.sunos_checkin[tostring(sunos.npcs.npc.get_time())])) > args.dist_min 
	then
		-- Adiciona instrução para andar mais um trecho
		npc.exec.proc.enqueue(self, "sunos:walk_to_checkin_step", args)
	else
		self.sunos_checkin_status = "dentro"
		--minetest.chat_send_all("chegou")
	end
end)


-- Verificar se ja andou até o checkin
npc.programs.instr.register("sunos:walk_to_checkin_step", function(self, args)
	--minetest.chat_send_all("sunos:walk_to_checkin_step")
	-- Encontra um node para ir caminhando na direção do alvo
	local pos_indo = sunos.ir_p1_to_p2(self.object:getpos(), args.end_pos, 7)
	-- Escolher caminho
	-- 1º Rua calcetada
	local alvo = minetest.find_node_near(pos_indo, 4, {"sunos:rua_calcetada"}, true)
	-- 2º Gramado
	if not alvo then
		alvo = minetest.find_node_near(pos_indo, 4, {"default:dirt_with_grass"}, true)
	end
	-- 3º Carpete da casa
	if not alvo then
		alvo = minetest.find_node_near(pos_indo, 4, {"sunos:carpete_palha", "sunos:carpete_palha_nodrop"}, true)
		if alvo then alvo.y = alvo.y-1 end
	end
	
	if alvo ~= nil then
		-- Ajuste de altura (caminhar ate sobre o node)
		alvo.y = alvo.y+1
		
		npc.exec.proc.enqueue(self, "advanced_npc:interrupt", {
			new_program = "advanced_npc:walk_to_pos",
			new_args = {
				-- Precisa asegurar que está no node
				optimize_one_node_distance =  sunos.p1_to_p2(self.object:getpos(), alvo) > 3, 
				end_pos = sunos.copy_tb(alvo),
				walkable = sunos.var.node_group.walkable,
			},
			interrupt_options = {}
		})
	else
		alvo = sunos.copy_tb(args.end_pos)
		-- Fica um tempo esperando
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
	
	-- Adiciona instrução para verificar
	npc.exec.proc.enqueue(self, "sunos:walk_to_checkin_check", args)
end)

-- Interagir aleatoriamente com a mobilia da casa
--[[
	Argumentos
	{
		end_pos = {x=0, y=0, z=0}, -- Coordenada do checkin
		dist_min = 5, -- Distancia minima que o NPC deve ficar do checkin
	}
  ]]
npc.programs.register("sunos:walk_to_checkin", function(self, args)
	--minetest.chat_send_all("sunos:walk_to_checkin")
	--minetest.chat_send_all("self.sunos_checkin_status = "..dump(self.sunos_checkin_status))
	-- Verifica se ja esta acaminho do checkin
	if self.sunos_checkin_status ~= "indo" then
		self.sunos_checkin_status = "indo"
		-- Realiza primeira verificação (daí em diante um loop ira continuar)
		npc.programs.instr.execute(self, "sunos:walk_to_checkin_check", args)
	else
		--minetest.chat_send_all("ja esta indo")
	end
end)
