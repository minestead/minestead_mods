--[[
	Mod Sunos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Métodos para verificação de ataques a estruturas
	
	Descritivo:
	
	Uma tabela com indeces de nomes de jogadores com uma lista de 
	nodes onde o jogador se suspeita de estar mexendo
	
	Os nodes de fundamento enviam os nomes  
	de jogadores que estão próximos para serem inseridos na tabela
	
	Quando um jogador está sendo rastreado. Sempre que o motor de 
	minetest verifica uma area protegida para esse jogador, ocorre 
	uma verificação entre os nodes que ele esteve proximo nos ultimos instantes
	
	Para jogadores que são rastreados pela primeira vez 
	após algum periodo sem rastreamento, é executado uma verificação dos nodes 
	mexidos nos últimos segundos
	
  ]]

-- Tabela de jogadores que estão sendo rastreados
local rastreados = {}

-- Tabela de players que devem permanecer no servidor após alguma interação
local tbp = {}

-- Verificar se uma coordenada está dentro de uma area de uma estrutura de acordo com nodes dos jogadores rastreados
local verif_pos = function(pos, name)
	if not rastreados[name] then return end
	
	local r = false -- Verifica se está dentro da area de ao menos uma estrutura
	local f = {} -- Tabela de fundamentos das areas que abrangem a coordenada 'pos'
	
	for np,p in pairs(rastreados[name]) do
		-- Verificar se a coordenada está dentro dos limites da area
		if p.minp.x <= pos.x
			and p.minp.y <= pos.y 
			and p.minp.z <= pos.z
			and p.maxp.x >= pos.x
			and p.maxp.y >= pos.y 
			and p.maxp.z >= pos.z
		then
			
			-- Mexeu dentro de uma das areas (retorna a coordenada do fundamento)
			r = true
			-- Armazena o local do fundamento
			table.insert(f, {x=(p.minp.x+p.maxp.x)/2, y=p.minp.y, z=(p.minp.z+p.maxp.z)/2})
		end
	end
	
	-- Nao foi dentro de nenhuma das areas
	return r, f
end


--[[
	Realiza algumas verificações dos ultimos nodes 
	mexidos nos ultimos segundos quando o jogador ainda 
	não tinha sido pego pelos detectodes dos fundamentos
]]
local novo_rastreado = function(name)
	
	if not minetest.get_player_by_name(name) then return end
	
	-- Pega as coordenadas dos ultimos tirados/colocados
	local postb = sunos.rollback(name, minetest.get_player_by_name(name):getpos())
	
	minetest.log("info", "[Sunos] "..name.." passou a ser rastrado no verificador de ataques")
	
	-- Verifica todas as ultimas coordenadas do rollback
	for _,p in ipairs(postb) do
		
		local r, f = verif_pos(p, name)
		if r == true then
			for _,pf in ipairs(f) do
				local vila = minetest.get_meta(pf):get_string("vila")
				-- Verifica se já é inimigo nessa vila
				if sunos.verif_inimigo(vila, name) == false then
					sunos.novo_inimigo(vila, name)
					minetest.log("action", "Vila "..vila.." dos sunos passou a ser inimiga de "..name.." (modo 1)")
				end
			end
		end
	end
	
end

-- Inserir um node proximo a um jogador na tabela
local inserir = function(pos, dist, name)

	-- Verificar se ja existe o nome do jogador na tabela
	if not rastreados[name] then 
		rastreados[name] = {} 
		-- Executa uma verificações dos ultimos nodes mexidos para os novos rastreados
		minetest.after(2, novo_rastreado, name)
	end
	
	-- Adiciona o node caso ainda não exista
	if not rastreados[name][pos.x.." "..pos.y.." "..pos.z] then
		rastreados[name][pos.x.." "..pos.y.." "..pos.z] = {
			minp = {x=pos.x-dist, y=pos.y, z=pos.z-dist},
			maxp = {x=pos.x+dist, y=pos.y+14, z=pos.z+dist}
		}
	end
	
end

-- ABM para atualizar jogadores proximos
minetest.register_abm({
	label = "Detector de jogadores",
	nodenames = {"sunos:fundamento"},
	interval = sunos.var.tempo_atualizar_jogadores_perto,
	chance = 1,
	action = function(pos)
		-- Verifica se o fundamento pertence a uma vila
		if minetest.get_meta(pos):get_string("vila") == "" then return end
		local all_objects = minetest.get_objects_inside_radius(pos, 25)
		local players = {}
		for _,obj in ipairs(all_objects) do
			if obj:is_player() then
				-- Inserir node na tabela do jogador
				inserir(pos, tonumber(minetest.get_meta(pos):get_string("dist")), obj:get_player_name())
			end
		end
	end,
})


-- Verificador de proteção 
-- Salva o antigo is_protected para que seja realizado normalmente após as verificações
antigo_is_protected = minetest.is_protected
-- Novo trecho a ser executado na verificação de area protegido
function minetest.is_protected(pos, name)

	-- Verifica se o jogador está sendo rastreado
	if rastreados[name] then
		-- Verificar se a area que o jogador mexer seria de uma estrutura dos sunos
		local r, f = verif_pos(pos, name)
		if r == true then
			-- Declara o jogador inimigo das vilas envolvidas 
			for _,pf in ipairs(f) do
				local vila = minetest.get_meta(pf):get_string("vila")
				-- Verifica se já é inimigo nessa vila
				if sunos.verif_inimigo(vila, name) == false then
					sunos.novo_inimigo(vila, name)
					minetest.log("action", "Vila "..vila.." dos sunos passou a ser inimiga de "..name.." (modo 1)")
				end
			end
			
			-- Verifica se estava defendida (caso esteja funciona como se fosse uma area protegida normal)
			for _,pf in ipairs(f) do
				if sunos.verificar_defesa(pf) == true then return true end
			end
			
		end
	end
	
	-- Executar antigas verificações (de outros mods)
	return antigo_is_protected(pos, name)
end

--
-- Sistema para impedir saida subta do servidor e evitar os verificadores de ataque
--

-- Remover jogador da lista
local remover_tbp = function(name)
	tbp[name] = nil
end

-- Coloca na tabela por um tempo após remover um node
minetest.register_on_dignode(function(pos, oldnode, digger)
	if not digger then return end
	tbp[digger:get_player_name()] = {x=pos.x, y=pos.y, z=pos.z}
	minetest.after(sunos.var.tempo_atualizar_jogadores_perto, remover_tbp, digger:get_player_name())

end)

-- Coloca na tabela por um tempo após colocar um node
minetest.register_on_placenode(function(pos, newnode, placer)
	if not placer then return end
	tbp[placer:get_player_name()] = {x=pos.x, y=pos.y, z=pos.z}
	minetest.after(sunos.var.tempo_atualizar_jogadores_perto, remover_tbp, placer:get_player_name())
end)

-- Verificações de segurança para jogadores que saiam abruptamente após tirar/colocar algum bloco
minetest.register_on_leaveplayer(function(player)
	if not player then return end
	
	local name = player:get_player_name()
	
	-- Verifica se o jogador ainda estava na lista no momento da saida
	if not tbp[name] then return end
	
	-- Realizar verificação de nodes próximos
	
	local pos = tbp[player:get_player_name()]
	
	-- Pega todos os nodes proximos
	local nodes = minetest.find_nodes_in_area(
		{x=pos.x-20, y=pos.y-20, z=pos.z-20}, 
		{x=pos.x+20, y=pos.y+15, z=pos.z+20}, 
		{"sunos:fundamento", "sunos:fundamento_step"}
	)
	
	-- Adiciona o node caso ainda não exista
	if not rastreados[name] then rastreados[name] = {} end
	
	-- Insere os fundamentos proximos	
	for _,p in ipairs(nodes) do
		-- Verifica se está registrado
		if minetest.get_meta(p):get_string("vila") ~= "" then
			local dist = minetest.get_meta(p):get_string("dist")
			if not rastreados[name][p.x.." "..p.y.." "..p.z] then
				rastreados[name][p.x.." "..p.y.." "..p.z] = {
					minp = {x=p.x-dist, y=p.y, z=p.z-dist},
					maxp = {x=p.x+dist, y=p.y+14, z=p.z+dist}
				}
			end
		end
	end
	
	-- Pega as coordenadas dos ultimos tirados/colocados
	local postb = sunos.rollback(name, pos)
	
	-- Verifica todas as ultimas coordenadas do rollback
	for _,p in ipairs(postb) do
		
		local r, f = verif_pos(p, name)
		if r == true then
			for _,pf in ipairs(f) do
				local vila = minetest.get_meta(pf):get_string("vila")
				-- Verifica se já é inimigo nessa vila
				if sunos.verif_inimigo(vila, name) == false then
					sunos.novo_inimigo(vila, name)
					minetest.log("action", "Vila "..vila.." dos sunos passou a ser inimiga de "..name.." (modo 1)")
				end
			end
		end
	end
	
end)
