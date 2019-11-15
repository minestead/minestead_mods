--[[
	Mod Sunos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Fundamento de estruturas em construção
  ]]

-- Tradução de strings
local S = sunos.S

-- Animacao de colocar assentamento para estrutura
local add_efeito = function(pos, dist)
	
	-- Adicionar particulas
	local w = dist-1
	local vetores = {
		vector.add(pos, {x=w,y=0,z=w}),
		vector.add(pos, {x=-w,y=0,z=w}),
		vector.add(pos, {x=-w,y=0,z=-w}),
		vector.add(pos, {x=w,y=0,z=-w})
	}
	for _,p in ipairs(vetores) do
		minetest.add_particlespawner({
			amount = 22*4,
			time = 8,
			minpos = {x=p.x-dist*1.1, y=p.y, z=p.z-dist*1.1},
			maxpos = {x=p.x+dist*1.1, y=p.y, z=p.z+dist*1.1},
			minvel = {x = 0, y = 1, z = 0},
			maxvel = {x = 0, y = 4, z = 0},
			minacc = vector.new(),
			maxacc = vector.new(),
			minexptime = 2,
			maxexptime = 5,
			minsize = 5,
			maxsize = 8,
			texture = "default_tree.png^sunos_filtro_circular.png^[makealpha:76,255,0",
		})
		minetest.add_particlespawner({
			amount = 28*4,
			time = 8,
			minpos = {x=p.x-dist*1.1, y=p.y, z=p.z-dist*1.1},
			maxpos = {x=p.x+dist*1.1, y=p.y, z=p.z+dist*1.1},
			minvel = {x = 0, y = 1, z = 0},
			maxvel = {x = 0, y = 4, z = 0},
			minacc = vector.new(),
			maxacc = vector.new(),
			minexptime = 2,
			maxexptime = 5,
			minsize = 5,
			maxsize = 8,
			texture = "default_cobble.png^sunos_filtro_circular.png^[makealpha:76,255,0",
		})
		minetest.add_particlespawner({
			amount = 15*4,
			time = 8,
			minpos = {x=p.x-dist*1.1, y=p.y, z=p.z-dist*1.1},
			maxpos = {x=p.x+dist*1.1, y=p.y, z=p.z+dist*1.1},
			minvel = {x = 0, y = 1, z = 0},
			maxvel = {x = 0, y = 2, z = 0},
			minacc = vector.new(),
			maxacc = vector.new(),
			minexptime = 2,
			maxexptime = 5,
			minsize = 5,
			maxsize = 8,
			texture = "farming_straw.png^sunos_filtro_circular.png^[makealpha:76,255,0",
		})
	end
	
	-- Tocar som
	minetest.sound_play("sunos_iniciando_estrutura", {
		pos = pos,
		max_hear_distance = 15,
		gain = 0.7,
	})
	minetest.sound_play("sunos_batidas_bancada", {
		pos = pos,
		max_hear_distance = 15,
		gain = 0.7,
	})
end


-- Fundamento dos sunos
--[[
	Esse é o node de fundamento de estruturas em construção
]]
minetest.register_node("sunos:fundamento_step", {
	description = S("Fundamento dos Sunos STEP"),
	tiles = {"default_cobble.png^sunos_fundamento.png", "default_cobble.png", "default_cobble.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 1, not_in_creative_inventory=1},
	sounds = default.node_sound_wood_defaults(),
	drop = "default:tree",
	
	-- Nao pode ser escavado/quebrado por jogadores
	on_dig = function() end,
	
	-- Chamada de temporizador
	on_timer = function(pos, elapsed)
		local meta = minetest.get_meta(pos)
		local versao = meta:get_string("versao")
		
		-- Verificar versao antes de tudo
		if sunos.verif_comp(versao) == false then return end
		
		-- Coleta dados
		local tipo = meta:get_string("tipo")
		local dist = meta:get_string("dist")
		local vila = meta:get_string("vila")
		local step = tonumber(meta:get_string("step")) or 0
		local dia_inicio = tonumber(meta:get_string("data_inicio"))
		local tempo_inicio = tonumber(meta:get_string("tempo_inicio"))
		local duracao = tonumber(meta:get_string("duracao"))
		local schem = meta:get_string("schem")
		local rotat = meta:get_string("rotat")
		
		-- Conjugado do momento de inicio
		local inicio = (dia_inicio * 24000) + (tempo_inicio*24000)
		
		-- Conjugado do momento atual
		local agora = (minetest.get_day_count() * 24000) + (minetest.get_timeofday()*24000)
		
		-- Decorrido
		local decorrido = agora - inicio
		
		-- Verifica se ja terminou
		if decorrido > duracao then
			
			-- evita jogador, adia procedimento
			if not sunos.verif_player_perto(pos, 25) then
				-- Reinicia o ciclo com um tempo definido
				minetest.get_node_timer(pos):set(10, 0)
				return false -- Evita que repita com um tempo diferente do definido
			end
			
			local r
			
			-- Verifica se vila ainda existe
			if sunos.verificar_vila_existente(vila) ~= true then
				r = "Vila "..dump(vila).." inexistente"
				
			-- Construir de acordo com o tipo
			elseif tipo ~= "" then
				r = sunos.estruturas[tipo].construir(pos, dist, vila)
			
			-- Nenhum tipo encontrado
			else
				r = "tipo de estrutura "..dump(tipo).." nao planejado"
			end
			
			if r ~= true then
				-- Informa o ocorrido no depurador
				minetest.log("action", "[Sunos] Construção de "..tipo.." cancelada em "..minetest.pos_to_string(pos).." : "..r)
				minetest.set_node(pos, {name="default:tree"})
				
				-- Monta ruina
				sunos.montar_ruinas(pos, dist)
			end
			
			return
			
		-- Verifica se está entre o inicio e o fim (evita bug ao voltar no tempo)
		elseif agora > inicio then
			
			-- evita jogador, adia procedimento
			if not sunos.verif_player_perto(pos, 15) then
				-- Reinicia o ciclo com um tempo definido
				minetest.get_node_timer(pos):set(10, 0)
				return false -- Evita que repita com um tempo diferente do definido
			end
			
			-- Calcula o passo novo
			local nstep = (decorrido*5)/duracao
			nstep = math.ceil(nstep)
			if nstep == 0 then nstep = 1 end
			if nstep == 6 then nstep = 5 end
			step = nstep
			
			-- Faz efeito de colocacao caso seja a primeira parte
			if step == 1 and meta:get_string("iniciado") ~= "sim" then
				meta:set_string("iniciado", "sim")
				add_efeito(pos, dist)
			end
			
			-- Constroi estrutura do novo passo
			local table = meta:to_table() -- salva metadados numa tabela
			sunos.montar_estrutura(pos, dist, tipo, rotat, schem, step)
			-- Restaura dados do fundamento step
			minetest.set_node(pos, {name="sunos:fundamento_step"})
			minetest.get_meta(pos):from_table(table)
		end
		
		-- Reinicia o ciclo com um tempo definido
		minetest.get_node_timer(pos):set(10, 0)
		return false -- Evita que repita com um tempo diferente do definido
	end,
	
	-- Impede explosão
	on_blast = function() end,
})


-- Colocar fundamento step
sunos.colocar_fundamento_step = function(pos, def)
	
	-- Coloca fundamento step para construir estrutura
	minetest.set_node(pos, {name="sunos:fundamento_step"})
	local meta = minetest.get_meta(pos)
	meta:set_string("tipo", def.tipo)
	meta:set_string("dist", def.dist)
	meta:set_string("versao", sunos.versao)
	meta:set_string("vila", def.vila)
	meta:set_string("step", 1)
	meta:set_string("data_inicio", minetest.get_day_count())
	meta:set_string("tempo_inicio", minetest.get_timeofday())
	meta:set_string("duracao", (def.dias*24000))
	meta:set_string("schem", def.schem)
	meta:set_string("rotat", def.rotat)
	
	-- Verifica se deve construir instantaneamente
	if sunos.var.instant_structure_build == true then
		meta:set_string("duracao", 0)
	end
	
	minetest.get_node_timer(pos):set(0.1, 0) -- Inicia temporizador
end
