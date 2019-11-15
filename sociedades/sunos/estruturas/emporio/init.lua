--[[
	Mod Sunos para Minetest
	Copyright (C) 2018 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	emporio dos sunos
  ]]

-- Tradução de strings
local S = sunos.S

-- Tabela global de emporio
sunos.estruturas.emporio = {}

-- Caminho do diretório do mod
local modpath = minetest.get_modpath("sunos")

-- Diretrizes (carregamento de script)
dofile(minetest.get_modpath("sunos").."/estruturas/emporio/diretrizes.lua") 

-- Placa de Emporio (carregamento de script)
dofile(minetest.get_modpath("sunos").."/estruturas/emporio/placa.lua") 


-- Construir emporio de sunos
--[[
	Essa função construi uma emporio de sunos e configura o fundamento
	Retorno:
		^ true caso ocorra tudo bem
		^ string de erro caso algo de errado
	Argumentos:
		<pos> é a coordenada do fundamento da estrutura
		<dist>
		<vila> OPCIONAL | é o numero da vila a qual a estrutura decorativa pertence
]]
sunos.estruturas.emporio.construir = function(pos, dist, vila)
	
	-- Remover jogadores da area construida (evitar travar em paredes)
	sunos.ajustar_jogadores(pos)
	
	-- Armazena dados do antigo fundamento caso exista
	local old_meta_tb = nil
	if minetest.get_node(pos).name == "sunos:fundamento" then
		old_meta_tb = minetest.get_meta(pos):to_table()
		if old_meta_tb.tipo ~= "emporio" then old_meta_tb = nil end
	end
	
	-- Distancia centro a borda padrão
	dist = 5
	
	-- Pegar nivel
	local nivel = sunos.verif_nivel(sunos.bd.pegar("vila_"..vila, "pop_total"), sunos.estruturas.emporio.var.niveis)
	if nivel == 0 then nivel = 1 end -- evita pegar nivel 0
	
	-- Variaveis auxiliares
	local largura = (dist*2)+1
	local pos1 = {x=pos.x-dist, y=pos.y, z=pos.z-dist}
	local pos2 = {x=pos.x+dist, y=pos.y+14, z=pos.z+dist}
	
	-- Limpar metadados dos nodes que possam estar la
	sunos.limpar_metadados(pos1, pos2)
	
	-- Criar estrutura
	
	local rotat = sunos.pegar_rotat()
	local schem = "nivel_"..nivel
	
	-- Pega schem ja existente
	-- Atualizar schem do nivel
	if old_meta_tb ~= nil and old_meta_tb.schem ~= nil then
		rotat = old_meta_tb.rotat
		schem = old_meta_tb.schem
	end
	
	-- Caminho do arquivo da estrutura
	local caminho_arquivo = modpath.."/schems/emporio/"..schem..".11.mts"
	
	-- Criar estrutura
	minetest.place_schematic({x=pos.x-dist, y=pos.y, z=pos.z-dist}, caminho_arquivo, rotat, sunos.var.nodes_trocados, true)
	
	-- Colocar saidas para rua
	sunos.saida_para_rua(pos, dist)
	
	-- Verifica se já tem fundamento
	if old_meta_tb ~= nil then
		-- Reestabelece fundamento
		minetest.set_node(pos, {name="sunos:fundamento"})
		local meta = minetest.get_meta(pos)
		meta:from_table(old_meta_tb) -- recoloca metadados no novo fumdamento
		-- Atualiza dados no fundamento
		meta:set_string("schem", schem) -- Nome do arquivo da esquematico da estrutura
		
	-- Novo fundamento
	else
		-- Colocar fundamento e configurar
		sunos.colocar_fundamento(pos, {
			vila = vila,
			tipo = "emporio",
			dist = dist,
			num = sunos.nova_estrutura(vila),
			schem = schem,
			rotat = rotat,
		})
	end
	
	-- Registros a serem salvos
	local registros = {
		tipo = "emporio",
		estrutura = {
			dist = dist,
			largura = largura,
			pos = pos
		}
	}
	-- Salva no banco de dados
	sunos.bd.salvar("vila_"..vila, "emporio", registros)
	
	return true
end


-- Verificação do fundamento
sunos.estruturas.emporio.verificar = function(pos)
	local meta = minetest.get_meta(pos)
	local vila = meta:get_string("vila")
	if vila == "" then return false end
	vila = tonumber(vila)
	local dist = tonumber(meta:get_string("dist"))
	
	-- Verificar nivel minimo
	if sunos.verif_nivel(sunos.bd.pegar("vila_"..vila, "pop_total"), sunos.estruturas.emporio.var.niveis) == 0 then
		return false
	end
	
	-- Atualizar nivel
	-- Pegar nivel que a estrutura está
	local nivel_atual = meta:get_string("nivel")
	-- Pegar nivel que deve estar
	local nivel_novo = sunos.verif_nivel(sunos.bd.pegar("vila_"..vila, "pop_total"), sunos.estruturas.emporio.var.niveis)
	if tonumber(nivel_atual) ~= tonumber(nivel_novo) then
		-- Atualiza fundamento
		minetest.get_meta(pos):set_string("schem", "nivel_"..nivel_novo)
		sunos.estruturas.emporio.construir(pos, dist, vila)
	end
	
	return true
end

-- Verificação de estrutura defendida
sunos.estruturas.emporio.defendido = function(pos)
	
	-- Sempre protegido
	return true
	
end

-- Verificar terreno e vila
local verificar_terreno = function(pos, dist)
	
	-- Encontrar vila ativa
	local vila = sunos.encontrar_vila(pos, 25)
	if not vila then
		return S("Nenhuma vila habitavel encontrada")
	end
	
	-- Verifica se está muito perto de outras estruturas atravez de areas protegidas
	for x=-1, 1 do
		for y=-1, 1 do
			for z=-1, 1 do
				if minetest.is_protected({x=pos.x+((dist+2)*x), y=pos.y+((8*y)+7), z=pos.z+((dist+2)*z)}, "") == true then
					return S("Muito perto de estruturas protegidas")
				end
			end
		end
	end
	
	-- Verificar emporio ja existente
	if sunos.bd.verif("vila_"..vila, "emporio") == true then
		return S("Ja existe @1 nessa vila", S("Emporio"))
	end
	
	-- Verificar população minima
	if sunos.verif_nivel(sunos.bd.pegar("vila_"..vila, "pop_total"), sunos.estruturas.emporio.var.niveis) == 0 then
		return S("A vila precisa ter ao menos @1 habitantes", sunos.estruturas.emporio.var.niveis[1])
	end
	
	-- Verificações de area
	do
		local r = sunos.verificar_area_para_fundamento(pos, dist)
		if r ~= true then
			return r
		end
	end
	
	return true, vila
end


-- Fundamento de emporio
minetest.register_node("sunos:fundamento_emporio", {
	description = S("Fundamento de Emporio dos Sunos"),
	tiles = {"default_tree_top.png^sunos_fundamento.png", "default_tree_top.png", "default_tree.png"},
	inventory_image = "sunos_fundamento_fundo_inv.png^sunos_fundamento_emporio_inv.png",
	wield_image = "sunos_fundamento_estrutura_namao.png^sunos_fundamento_emporio_namao.png",
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 1},
	sounds = default.node_sound_wood_defaults(),
	stack_max = 1,
	
	-- Colocar uma emporio
	on_place = function(itemstack, placer, pointed_thing)
		
		local pos = pointed_thing.under
		
		local r, vila = verificar_terreno(pos, 5)
		
		if r == true then
			
			-- Coloca rua em torno
			sunos.colocar_rua(pos, 5)
			
			-- Construir estrutura
			-- Colocar fundamento step
			sunos.colocar_fundamento_step(pos, {
				tipo = "emporio",
				dist = 5,
				vila = vila,
				dias = 3,
				schem = "nivel_1",
				rotat = sunos.pegar_rotat(),
			})
			
			-- Retorna mensagem de montagem concluida
			minetest.chat_send_player(placer:get_player_name(), S("Construindo @1", S("Emporio")))
			itemstack:take_item()
			return itemstack
			
		else
			
			-- Mostra area necessaria
			sunos.criar_caixa_de_area(pos, 5+1)
			-- Retorna mensagem de falha
			minetest.chat_send_player(placer:get_player_name(), r)
			return itemstack
		end
	end,
})


