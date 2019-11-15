--[[
	Mod Sunos para Minetest
	Copyright (C) 2018 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Caixa de musica dos sunos
  ]]

-- Tradução de strings
local S = sunos.S

-- Alcance do som
local alcance_som = 20

-- Tempo minimo entre as musicas
local tempo_min = 180

-- Tabela ordenada das musicas
local musicas = {}
for musica,dados in pairs(sunos.var.musicas) do
	table.insert(musicas, musica)
end

-- Tocar sozinho aleatoriamente
local tocar_sozinho = false

-- Vilas onde esta tocando
local tocando = {}
-- Zerar vila
local reset_tocando = function(index)
	tocando[index] = nil
end

-- Caixa de musica dos sunos
--[[
	Esse é o node toca musicas dos sunso
]]
minetest.register_node("sunos:caixa_de_musica", {
	description = S("Caixa de Musica dos Sunos"),
	tiles = {"sunos_caixa_de_musica_tampo.png", "sunos_caixa_de_musica_tampo.png", "sunos_caixa_de_musica_lado.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 1},
	sounds = default.node_sound_wood_defaults(),
	
	on_timer = function(pos, elapsed)
		local meta = minetest.get_meta(pos)
		
		-- Sistema global para evitar repeticao na mesma regiao/vila
		if tocando[minetest.pos_to_string(pos)] == true then
			if tocar_sozinho == true then
				minetest.get_node_timer(pos):set(tempo_min, 0)
			end
			return
		end
		
		-- Verifica se está perto de um fundamento suno
		if not minetest.find_node_near(pos, 15, {"sunos:fundamento"}) then
			return false
		end
		
		-- Verifica se ja tem algum tocando nas redondezas (evitar varios tocando junto)
		do
			-- Pega outras caixas proximas
			local caixas = minetest.find_nodes_in_area(
				vector.subtract(pos, alcance_som), 
				vector.add(pos, alcance_som), 
				{"sunos:caixa_de_musica", "sunos:caixa_de_musica_nodrop"}
			)
			-- Verifica se algum deles está tocando
			for _,p in ipairs(caixas) do
				if tocando[minetest.pos_to_string(p)] == true then
					-- Tenta novamente apos alguns segundos
					if tocar_sozinho == true then
						minetest.get_node_timer(pos):set(tempo_min, 0)
					end
					return false
				end
			end
		end
		
		-- Inicia musica
		
		-- Esolhe musica e coleta dados
		local musica = musicas[math.random(1,table.maxn(musicas))]
		local dados = sunos.var.musicas[musica]
		
		-- Tocar musica
		minetest.sound_play(musica, {
			pos = pos,
			max_hear_distance = alcance_som,
			gain = dados.gain*0.35, -- reduz o ganho para a musica ficar sempre de fundo
		})
		
		-- Sistema global de musicas dos sunos
		tocando[minetest.pos_to_string(pos)] = true
		minetest.after(dados.duracao, reset_tocando, minetest.pos_to_string(pos))
		
		-- Volta quando terminar a musica
		if tocar_sozinho == true then
			minetest.get_node_timer(pos):set(dados.duracao, 0)
		end
		return false
		
	end,
	
	-- Força tocar
	on_punch = function(pos, node, player, pointed_thing)
		minetest.registered_nodes["sunos:caixa_de_musica"].on_timer(pos, minetest.get_node_timer(pos):get_elapsed())
	end,
})


-- Criar cópia sem Drop (para evitar furtos em estruturas dos sunos)
do
	-- Copiar tabela de definições
	local def = {}
	for n,d in pairs(minetest.registered_nodes["sunos:caixa_de_musica"]) do
		def[n] = d
	end
	-- Mantem a tabela groups separada
	def.groups = minetest.deserialize(minetest.serialize(def.groups))
	
	-- Altera alguns paremetros
	def.description = def.description .. " ("..S("Sem Drop")..")"
	def.groups.not_in_creative_inventory = 1
	def.drop = ""
	-- Registra o novo node
	minetest.register_node("sunos:caixa_de_musica_nodrop", def)
end


-- LBM para iniciar timer das caixas
if tocar_sozinho == true then
	minetest.register_lbm({
		name = "sunos:tocar_caixa_de_musica",
		nodenames = {"sunos:caixa_de_musica", "sunos:caixa_de_musica_nodrop"},
		run_at_every_load = true,
		action = function(pos, node)
			if minetest.get_node_timer(pos):is_started() == false then
				minetest.get_node_timer(pos):set(2, 0)
			end
		end,
	})
end
