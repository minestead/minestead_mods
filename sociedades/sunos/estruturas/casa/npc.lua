--[[
	Mod Sunos para Minetest
	Copyright (C) 2018 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	NPC das casas
  ]]


-- Tradução de strings
local S = sunos.S

-- Envia uma formspec simples de aviso
local avisar = function(player, texto)
	if not player then
		minetest.log("error", "[Sunos] player nulo (em avisar do script interface.lua)")
		return false
	end
	if not texto then
		minetest.log("error", "[Sunos] texto nulo (em avisar do script interface.lua)")
		return false
	end
	
	minetest.show_formspec(player:get_player_name(), "sunos:npc", "size[12,1]"
		..default.gui_bg
		..default.gui_bg_img
		.."label[0.5,0;"..S("Aviso").." \n"..texto.."]")
	return true
end

-- Nodes andaveis para os NPC caseiros
sunos.estruturas.casa.walkable_nodes = {
	"sunos:carpete_palha",
	"sunos:carpete_palha_nodrop",
	"sunos:torch_nodrop",
	"sunos:torch_ceiling_nodrop",
	"sunos:torch_wall_nodrop"
}

-- Busca todos os nodes de um determinada lista de tipos na casa
local pegar_nodes_casa = function(pos, dist, nodes)
	return minetest.find_nodes_in_area(
		{x=pos.x-dist, y=pos.y, z=pos.z-dist}, 
		{x=pos.x+dist, y=pos.y+14, z=pos.z+dist}, 
		nodes)
end

-- Registra mobilias
sunos.nodes_de_mobilias["bau_primario"] = {"sunos:bau_casa"}
sunos.nodes_de_mobilias["caixa_de_musica"] = {"sunos:caixa_de_musica_nodrop"}
sunos.nodes_de_mobilias["cama"] = {"beds:bed_bottom"}
sunos.nodes_de_mobilias["forno"] = {"default:furnace", "default:furnace_active"}
sunos.nodes_de_mobilias["compostagem"] = {"sunos:wood_barrel_nodrop"}
sunos.nodes_de_mobilias["tear"] = {"sunos:tear_palha_nodrop"}
sunos.nodes_de_mobilias["bancada_de_trabalho"] = {"sunos:bancada_de_trabalho_nodrop"}
sunos.nodes_de_mobilias["kit_culinario"] = {"sunos:kit_culinario_nodrop"}
-- Replica para alternativos
for mobilia,copias in pairs({
	["cama"] = 3,
	["forno"] = 4,
	["compostagem"] = 3,
	["tear"] = 3,
	["bancada_de_trabalho"] = 3,
	["kit_culinario"] = 3,
	["caixa_de_musica"] = 3,
}) do
	for n=1, copias do
		sunos.nodes_de_mobilias[mobilia.."_"..n] = sunos.nodes_de_mobilias[mobilia]
	end
end


-- Configurar lugares do npc
local set_npc_places = function(self)
	local pf = self.sunos_fundamento
	if not pf then return end
	local dist = tonumber(minetest.get_meta(pf):get_string("dist"))
	if not dist then return end
	
	-- Coleta nodes de mobilia para interação na casa
	local nodes = {}
	
	-- Bau
	do
		local bau = sunos.copy_tb(self.mypos)
		local v = minetest.facedir_to_dir(minetest.get_node(bau).param2)
		local acesso = vector.subtract(bau, v)
		npc.locations.add_shared(self, "bau_primario", "mobilia", bau, acesso)
	end
	
	-- Cama
	for n,node in ipairs(pegar_nodes_casa(pf, dist, {"beds:bed_bottom"})) do
		if minetest.get_meta(node):get_string("advanced_npc:owner") == "" then
			local v = minetest.facedir_to_dir(minetest.get_node(node).param2)
			local acesso = vector.subtract(node, v)
			npc.locations.add_shared(self, "cama_"..n, "bed_shared", node, acesso)
		end
	end
	
	-- Interior e exterior da casa
	local portas = pegar_nodes_casa(pf, dist, {"doors:door_wood_a"})
	if portas[1] then
		local porta = portas[1]
		local v = minetest.facedir_to_dir(minetest.get_node(porta).param2)
		local dentro = vector.subtract(porta, v)
		local fora = vector.add(porta, v)
		npc.locations.add_shared(self, "casa_dentro_1", "home_inside", dentro, nil)
		npc.locations.add_shared(self, "casa_fora_1", "home_outside", fora, nil)
	end
	
	local nodes
	
	-- Forno
	nodes = pegar_nodes_casa(pf, dist, {"default:furnace"})
	for n,node in ipairs(nodes) do
		local v = minetest.facedir_to_dir(minetest.get_node(node).param2)
		local acesso = vector.subtract(node, v)
		npc.locations.add_shared(self, "forno_"..n, "furnace_shared", node, acesso)
	end
	
	-- Compostagens
	nodes = pegar_nodes_casa(pf, dist, {"sunos:wood_barrel_nodrop"})
	for n,node in ipairs(nodes) do
		local v = minetest.facedir_to_dir(minetest.get_node(node).param2)
		local acesso = vector.subtract(node, v)
		npc.locations.add_shared(self, "compostagem_"..n, "mobilia", node, acesso)
	end
	
	-- Tear
	nodes = pegar_nodes_casa(pf, dist, {"sunos:tear_palha_nodrop"})
	for n,node in ipairs(nodes) do
		local v = minetest.facedir_to_dir(minetest.get_node(node).param2)
		local acesso = vector.subtract(node, v)
		acesso.y = acesso.y-1
		npc.locations.add_shared(self, "tear_"..n, "mobilia", node, acesso)
	end
	
	-- Bancada de Trabalho
	nodes = pegar_nodes_casa(pf, dist, {"sunos:bancada_de_trabalho_nodrop"})
	for n,node in ipairs(nodes) do
		local v = minetest.facedir_to_dir(minetest.get_node(node).param2)
		local acesso = vector.subtract(node, v)
		npc.locations.add_shared(self, "bancada_de_trabalho_"..n, "mobilia", node, acesso)
	end
	
	-- Kit culinario
	nodes = pegar_nodes_casa(pf, dist, {"sunos:kit_culinario_nodrop"})
	for n,node in ipairs(nodes) do
		local v = minetest.facedir_to_dir(minetest.get_node(node).param2)
		local acesso = vector.subtract(node, v)
		acesso.y = acesso.y-1
		npc.locations.add_shared(self, "kit_culinario_"..n, "mobilia", node, acesso)
	end
	
	-- Caixa de Musica
	nodes = pegar_nodes_casa(pf, dist, {"sunos:caixa_de_musica_nodrop"})
	for n,node in ipairs(nodes) do
		local v = minetest.facedir_to_dir(minetest.get_node(node).param2)
		local acesso = vector.subtract(node, v)
		npc.locations.add_shared(self, "caixa_de_musica_"..n, "mobilia", node, acesso)
	end
end

-- Criar entidade NPC
sunos.npcs.npc.registrar("caseiro", {
	max_dist = 100,	
	node_spawner = "sunos:bau_casa",
	drops = {
		{name = "default:apple", chance = 2, min = 1, max = 2},
	},
	
	on_spawn = function(self)
		-- Salva ocupação informando que está sendo usada
		if self.sunos_occupation == nil then
			local meta = minetest.get_meta(self.mypos)
			self.sunos_occupation = meta:get_string("sunos_npc_occupation")
			-- Realiza atribuições do npcnode ao npc spawnado
			sunos.npcnode.atribuir_npc(self.mypos, self)
			
			-- Verifica se ja tem lugares salvos
			if not npc.locations.get_by_type(self, "bau")[1] then
				-- Configurar lugares
				set_npc_places(self)
			end
		end
	end,
})

-- Escolhe uma tarefa para o npc
sunos.estruturas.casa.select_occupation = function(pos, vila)
	
	-- Escolha padrao "caseiro"
	local occupation = "sunos_npc_caseiro"
	
	-- Checkin padrão
	local checkin = {
		["0"] = pos,
		["1"] = pos,
		["2"] = pos,
		["3"] = pos,
		["4"] = pos,
		["5"] = pos,
		["6"] = pos,
		["7"] = pos,
		["8"] = pos,
		["9"] = pos,
		["10"] = pos,
		["11"] = pos,
		["12"] = pos,
		["13"] = pos,
		["14"] = pos,
		["15"] = pos,
		["16"] = pos,
		["17"] = pos,
		["18"] = pos,
		["19"] = pos,
		["20"] = pos,
		["21"] = pos,
		["22"] = pos,
		["23"] = pos,
	}
	
	-- Pega população
	local pop = sunos.bd.verif("vila_"..vila, "pop_total")
	if pop == true then
		pop = tonumber(sunos.bd.pegar("vila_"..vila, "pop_total"))
	else
		pop = 1 -- considera 1 para fins estatisticos caso nao existam dados ainda
	end 
	
	-- Verifica se tem loja
	local loja = sunos.bd.verif("vila_"..vila, "loja")
	
	-- Tenta limitar a 2 lojista em toda a vila
	local chance_lojista = math.ceil((2/pop)*100)
	-- Limita chance a 30%
	if chance_lojista > 30 then chance_lojista = 30 end
	
	-- CASEIRO 40%
	local s = math.random(1, 100)
	-- LOJISTA 1 a 30% (dependendo da população)
	if s >= 1 and s <= chance_lojista and loja == true then 
		
		local dados_loja = sunos.bd.pegar("vila_"..vila, "loja")
		checkin["8"] = dados_loja.estrutura.pos
		checkin["9"] = dados_loja.estrutura.pos
		checkin["10"] = dados_loja.estrutura.pos
		checkin["11"] = dados_loja.estrutura.pos
		checkin["12"] = dados_loja.estrutura.pos
		checkin["13"] = dados_loja.estrutura.pos
		checkin["14"] = dados_loja.estrutura.pos
		return "sunos_npc_caseiro_lojista", checkin
	end
	
	-- Se nao houver o escolhido, vira caseiro
	return occupation, checkin
end

-- Atividades estruturadas
dofile(minetest.get_modpath("sunos").."/estruturas/casa/atividades.lua") 

-- Carregar roteiros
dofile(minetest.get_modpath("sunos").."/estruturas/casa/occupations/lojista.lua") 
dofile(minetest.get_modpath("sunos").."/estruturas/casa/occupations/caseiro.lua") 
