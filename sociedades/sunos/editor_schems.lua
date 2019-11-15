--[[
	Mod Sunos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Editor de estruturas esquematicas dos sunos
  ]]

-- Tradução de strings
local S = sunos.S

-- Armazena os dados de quem acessa
local acessos = {}

-- Lista de estruturas
local lista_de_tipos = {}
-- Lista de estruturas desordenada
local lista_de_tipos_i = {}

-- Lista de larguras
local lista_de_larguras = {"3", "5", "7", "9", "13"}
local lista_de_larguras_i = {["3"]=1, ["5"]=2, ["7"]=3, ["9"]=4, ["13"]=5}

-- Lista de steps
local lista_de_steps = {"Completa", "1", "2", "3", "4", "5"}
local lista_de_steps_i = {["Completa"]=1, ["1"]=2, ["2"]=3, ["3"]=4, ["4"]=5, ["5"]=6}

-- Acessar formspec
local acessar_menu = function(name)
	
	-- Tipos de estruturas
	local lista_de_tipos = minetest.get_dir_list(minetest.get_modpath("sunos").."/schems", true)
	local list_estruturas_string = ""
	if lista_de_tipos then
		for n, ndir in ipairs(lista_de_tipos) do
			lista_de_tipos_i[ndir] = n
			if list_estruturas_string ~= "" then list_estruturas_string = list_estruturas_string .."," end
			list_estruturas_string = list_estruturas_string .. ndir
		end
	end
	local escolha_tipo = minetest.get_meta(acessos[name].pos):get_string("tipo")
	if escolha_tipo == "" then
		-- Atualiza a escolha salva com a escolha exibida
		minetest.get_meta(acessos[name].pos):set_string("tipo", 1)
		minetest.get_meta(acessos[name].pos):set_string("tipo_nome", lista_de_tipos[1])
		escolha_tipo = 1
	end
	
	local list_estruturas = minetest.get_dir_list(minetest.get_modpath("sunos").."/schems/"..lista_de_tipos[tonumber(escolha_tipo)])
	local list_estruturas_strings = ""
	local lista_estruturas_i = {}
	if list_estruturas then
		local i = 1
		for n, nschem in ipairs(list_estruturas) do
			if not string.match(nschem, "-step") then
				local nn = string.split(nschem, ".")
				local estrut = nn[1] .. " ("..nn[2]..")"
				list_estruturas[i] = estrut -- reajusta o nome
				lista_estruturas_i[estrut] = i
				i = i + 1
				if list_estruturas_strings ~= "" then list_estruturas_strings = list_estruturas_strings .."," end
				list_estruturas_strings = list_estruturas_strings .. estrut
			end
		end
		
		-- Salva listas no node
		minetest.get_meta(acessos[name].pos):set_string("lista_estruturas", minetest.serialize(list_estruturas))
		minetest.get_meta(acessos[name].pos):set_string("lista_estruturas_i", minetest.serialize(lista_estruturas_i))
	end
	
	local escolha_estrutura = minetest.get_meta(acessos[name].pos):get_string("estrutura")
	if not lista_estruturas_i[escolha_estrutura] then
		
		-- Atualiza a escolha salva com a escolha exibida
		minetest.get_meta(acessos[name].pos):set_string("estrutura", list_estruturas[1])
		escolha_estrutura = 1
	else
		escolha_estrutura = lista_estruturas_i[escolha_estrutura]
	end
	
	
	
	local formspec = "size[10,10]"
		..default.gui_bg
		..default.gui_bg_img
		.."label[0,0;"..S("Editor de Estruturas Esquematicas (Schems)").."]"
		.."label[0,0.5;"..S("Tipo de estrutura").."]"
		.."dropdown[0,1;10.5,1;tipo;"..list_estruturas_string..";"..escolha_tipo.."]"
		
		.."label[0,2;"..S("Manipular estruturas").."]"
		.."label[0,2.5;"..S("Nome da estrutura").."]"
		.."dropdown[0,3;8.5,1;estrutura;"..list_estruturas_strings..";"..escolha_estrutura.."]"
		.."label[8,2.5;"..S("Estagio").."]"
		.."dropdown[8,3;2,1;step;Completa,1,2,3,4,5;"..acessos[name].escolha_step.."]"
		.."button_exit[0,3.8;3,1;carregar;"..S("Carregar").."]"
		.."button_exit[3,3.8;3,1;salvar;"..S("Salvar").."]"
		
		.."label[0,5.2;"..S("Criar nova estrutura").."]"
		.."field[0.3,6.3;8,1;novo_nome;"..S("Nome da estrutura")..";]"
		.."label[8,5.5;"..S("Largura").."]"
		.."dropdown[8,6;2,1;nova_largura;3,5,7,9,11,13;]"
		.."button_exit[0,6.8;6,1;criar;"..S("Salvar nova estrutura").."]"
		
	
	return minetest.show_formspec(name, "sunos:editor_schems", formspec)
	
end

-- Receptor de botoes
minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname == "sunos:editor_schems" then 
		local name = player:get_player_name()
		local pos = acessos[name].pos
		
		-- Carregar estrutura
		if fields.carregar then
			
			-- Verificar step
			local step_sufix = ""
			if acessos[name].escolha_step > 1 then
				step_sufix = "-step"..acessos[name].escolha_step-1
			end
					
			-- Verificar tipo
			local tipo = minetest.get_meta(acessos[name].pos):get_string("tipo_nome")
			-- Verificar estrutura e largura 
			local estrutura = minetest.get_meta(acessos[name].pos):get_string("estrutura")
			if tipo == "" or estrutura == "" then 
				minetest.chat_send_player(name, S("Defina o tipo e estrutura desejada"))
				return
			end
			-- Separar largura
			local largura = ""
			do
				local v = string.split(estrutura, " (")
				estrutura = v[1]
				local vv = string.split(v[2], ")")
				largura = tonumber(vv[1])			
			end
			
			-- Monta a base para colocar a estrutura
			minetest.place_schematic(
				{x=pos.x+1, y=pos.y, z=pos.z-7}, 
				minetest.get_modpath("sunos").."/schems_basicos/base_editor.mts", 
				0, nil, true
			)
			
			-- Verificar estrutura
			local dist = ((largura-1)/2)
			-- Pegar nome do caminho do arquivo
			local arq = tipo.."/"..estrutura.."."..largura..".mts"..step_sufix
			local r = minetest.place_schematic({x=pos.x+8-dist, y=pos.y, z=pos.z-dist}, minetest.get_modpath("sunos").."/schems/"..arq, 0, nil, true)
			
			if r == true then
				minetest.chat_send_player(name, S("Estrutura carregada"))
			else
				minetest.chat_send_player(name, S("Falha ao carregar estrutura"))
			end
			return
		end
		
		if fields.salvar then
			
			-- Verificar step
			local step_sufix = ""
			if acessos[name].escolha_step > 1 then
				step_sufix = "-step"..acessos[name].escolha_step-1
			end
			
			-- Verificar tipo
			local tipo = minetest.get_meta(acessos[name].pos):get_string("tipo_nome")
			-- Verificar estrutura e largura 
			local estrutura = minetest.get_meta(acessos[name].pos):get_string("estrutura")
			if tipo == "" or estrutura == "" then 
				minetest.chat_send_player(name, S("Defina o tipo e estrutura desejada"))
				return
			end
			-- Separar largura
			local largura = ""
			do
				local v = string.split(estrutura, " (")
				estrutura = v[1]
				local vv = string.split(v[2], ")")
				largura = tonumber(vv[1])			
			end
			
			-- Pegar nome do caminho do arquivo
			local arq = tipo.."/"..estrutura.."."..largura..".mts"..step_sufix
			-- Remove o antigo arquivo schematic
			if step_sufix == "" and os.remove(minetest.get_modpath("sunos").."/schems/"..arq) == nil then
				minetest.chat_send_player(name, S("Falha ao remover arquivo antigo"))
			end
			
			-- Criar novo arquivo schematic
			local dist = ((largura-1)/2)
			minetest.create_schematic(
				{x=pos.x+8-dist, y=pos.y, z=pos.z-dist}, 
				{x=pos.x+8+dist, y=pos.y+14, z=pos.z+dist}, {}, 
				minetest.get_modpath("sunos").."/schems/"..arq
			)
			
			-- Avisa o bug do minetest
			minetest.chat_send_player(name, S("Estrutura foi salva. Mas precisa reiniciar o minetest para carregar ela novamente"))
			return
		end
		
		if fields.criar then
			
			-- Verificar nome da nova estrutura
			if fields.novo_nome == "" then 
				minetest.chat_send_player(name, S("Defina um nome da estrutura"))
				return
			end
			if string.match(fields.novo_nome, " ") ~= nil then
				minetest.chat_send_player(name, S("Use apenas letras e sublinhado (_)"))
				return
			end
			
			-- Verificar tipo
			local tipo = minetest.get_meta(acessos[name].pos):get_string("tipo_nome")
			if tipo == "" then
				minetest.chat_send_player(name, S("Nenhum tipo definido"))
				return
			end
			
			local largura = tonumber(fields.nova_largura)
			
			-- Pegar nome do caminho do arquivo
			local arq = "/"..tipo.."/"..fields.novo_nome.."."..largura..".mts"
			
			-- Criar novo arquivo schematic
			local dist = ((largura-1)/2)
			minetest.create_schematic(
				{x=pos.x+8-dist, y=pos.y, z=pos.z-dist}, 
				{x=pos.x+8+dist, y=pos.y+14, z=pos.z+dist}, {}, 
				minetest.get_modpath("sunos").."/schems/"..arq
			)
			
			minetest.chat_send_player(name, S("Estrutura nova foi salva"))
			return
		end
		
		-- Seletores devem ficar apos o botao para evitar seleção errada
		
		-- Escolheu um tipo
		if fields.tipo then
			minetest.get_meta(acessos[name].pos):set_string("tipo", lista_de_tipos_i[fields.tipo])
			minetest.get_meta(acessos[name].pos):set_string("tipo_nome", fields.tipo)
			-- Atualiza o menu
			acessar_menu(name)
		end
		
		-- Escolheu estrutura
		if fields.estrutura then
			minetest.get_meta(acessos[name].pos):set_string("estrutura", fields.estrutura)
		end
		
		-- Escolheu step
		if fields.step then
			acessos[name].escolha_step = lista_de_steps_i[fields.step]
		end
	end
end)

-- Node de Acesso
minetest.register_node("sunos:editor_schems", {
	description = S("Editor de estruturas dos Sunos"),
	tiles = {"default_wood.png^sunos_editor_schems.png"},
	paramtype2 = "facedir",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
	legacy_facedir_simple = true,
	is_ground_content = false,
	sounds = default.node_sound_wood_defaults(),
	
	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		local name = player:get_player_name()
		
		-- Verifica se tem privilegios
		if minetest.check_player_privs(name, {server=true}) ~= true then
			return
		end
		
		if not acessos[name] then
			acessos[name] = {}
		end
		acessos[name].pos = {x=pos.x, y=pos.y, z=pos.z}
		acessos[name].escolha_step = acessos[name].escolha_step or 1
		
		acessar_menu(name)
	end,
})
