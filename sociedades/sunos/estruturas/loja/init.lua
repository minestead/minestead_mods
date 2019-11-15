--[[
	Mod Sunos para Minetest
	Copyright (C) 2018 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Loja dos sunos
  ]]

-- Tradução de strings
local S = sunos.S

-- Caminho do diretório do mod
local modpath = minetest.get_modpath("sunos")

-- Bau de loja (carregamento de script)
dofile(minetest.get_modpath("sunos").."/estruturas/loja/bau.lua") 

-- Fundamento de loja (carregamento de script)
dofile(minetest.get_modpath("sunos").."/estruturas/loja/fundamento.lua") 

-- Tabela global de Loja
sunos.estruturas.loja = {}

local set_bau = function(pos, vila, dist)

	-- Verifica se tem baus na estrutura montada
	local baus = minetest.find_nodes_in_area(
		{x=pos.x-dist, y=pos.y, z=pos.z-dist}, 
		{x=pos.x+dist, y=pos.y+14, z=pos.z+dist}, 
		{"sunos:bau_loja"}
	)
	-- Salva dados da estrutura no bau dela
	for _,pos_bau in ipairs(baus) do
		local meta = minetest.get_meta(pos_bau)
		meta:set_string("infotext", S("Bau de Venda dos Sunos"))
		meta:set_string("formspec", "size[9,9]"
			..default.gui_bg_img
			.."image[0,0;3,3;sunos.png]"
			.."label[3,0;"..S("Bau de Venda dos Sunos").."]"
			.."label[3,1;"..S("Troque alguns itens aqui").."]"
			.."image[7.5,-0.2;2,2;default_apple.png]"
			.."image[6.6,0;2,2;default_apple.png]"
			.."image[6.6,1;2,2;default_apple.png]"
			.."image[7.5,0.8;2,2;default_apple.png]"
			-- Botoes de trocas
			.."item_image_button[0,3;3,3;default:tree;trocar_madeira;2]"
			.."item_image_button[0,6;3,3;default:stonebrick;trocar_pedra;2]"
			.."item_image_button[3,3;3,3;default:gold_ingot;trocar_ouro;10]"
			.."item_image_button[3,6;3,3;default:steel_ingot;trocar_ferro;6]"
			.."item_image_button[6,3;3,3;default:coal_lump;trocar_carvao;2]"
			.."item_image_button[6,6;3,3;default:glass;trocar_vidro;2]"
		)
	end

end

-- Construir loja de sunos
--[[
	Essa função construi uma loja de sunos e configura o fundamento
	Retorno:
		^ true caso ocorra tudo bem
		^ string de erro caso algo de errado
	Argumentos:
		<pos> é a coordenada do fundamento da estrutura
		<dist> distancia centro a borda da nova estrutura
		<vila> OPCIONAL | é o numero da vila a qual a estrutura decorativa pertence
]]
sunos.estruturas.loja.construir = function(pos, dist, vila)
	
	-- Remover jogadores da area construida (evitar travar em paredes)
	sunos.ajustar_jogadores(pos)
	
	-- Armazena dados do antigo fundamento caso exista
	local old_meta_tb = nil
	if minetest.get_node(pos).name == "sunos:fundamento" then
		old_meta_tb = minetest.get_meta(pos):to_table()
		if old_meta_tb.tipo ~= "loja" then old_meta_tb = nil end
	end
	
	-- Variaveis auxiliares
	local largura = (dist*2)+1
	local pos1 = {x=pos.x-dist, y=pos.y, z=pos.z-dist}
	local pos2 = {x=pos.x+dist, y=pos.y+14, z=pos.z+dist}
	
	-- Limpar metadados dos nodes que possam estar la
	sunos.limpar_metadados(pos1, pos2)
	
	-- Criar estrutura
	
	-- Escolhe uma rotação aleatória ou pega a já existente
	local rotat = minetest.get_meta(pos):get_string("rotat")
	if rotat == "" then
		rotat = sunos.pegar_rotat()
	end
	
	-- Atualizar schem do nivel
	local schem = minetest.get_meta(pos):get_string("schem")
	if schem == "" then
		schem = "nivel_"..nivel
	end
	
	-- Caminho do arquivo da estrutura
	local caminho_arquivo = modpath.."/schems/loja/"..schem.."."..largura..".mts"
	
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
			tipo = "loja",
			dist = dist,
			num = sunos.nova_estrutura(vila),
			schem = schem,
			rotat = rotat,
		})
	end
	
	-- Ajustar baus
	set_bau(pos, vila, dist)
	
	-- Registros a serem salvos
	local registros = {
		tipo = "loja",
		estrutura = {
			dist = dist,
			largura = largura,
			pos = pos
		}
	}
	
	-- Salva no banco de dados
	sunos.bd.salvar("vila_"..vila, "loja", registros)
	
	-- Remover jogadores da area construida (evitar travar em paredes)
	sunos.ajustar_jogadores(pos)
	
	return true
end

-- Executado apos reestruturar loja
sunos.estruturas.loja.apos_restaurar_estrutura = function(pos)
	
	local meta = minetest.get_meta(pos)
	local dist = tonumber(meta:get_string("dist"))
	local vila = meta:get_string("dist")
	
	-- Configura novos baus
	set_bau({x=pos.x,y=pos.y,z=pos.z}, vila, dist)
end

-- Verificação de estrutura defendida
sunos.estruturas.loja.defendido = function(pos)
	
	-- Sempre protegido
	return true
	
end
