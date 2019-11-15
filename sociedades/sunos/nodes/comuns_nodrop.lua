--[[
	Mod Sunos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Bancada dos sunos
  ]]

-- Tradução de strings
local S = sunos.S

-- Tabela de nodes
local nodes_trocaveis_nodrop = {
	["default:tree"] = {name="sunos:tree_nodrop"},
	["default:glass"] = {name="sunos:glass_nodrop"},
	["default:cobble"] = {name="sunos:cobble_nodrop"},
	["default:wood"] = {name="sunos:wood_nodrop"},
	["farming:straw"] = {name="sunos:straw_nodrop"},
	["default:stonebrick"] = {name="sunos:stonebrick_nodrop"},
	-- Stairs
	["stairs:stair_straw"] = {name="sunos:stair_straw_nodrop"},
	["stairs:slab_straw"] = {name="sunos:slab_straw_nodrop"},
	["stairs:stair_inner_straw"] = {name="sunos:stair_inner_straw_nodrop"},
	["stairs:stair_outer_straw"] = {name="sunos:stair_outer_straw_nodrop"},
	["stairs:stair_wood"] = {name="sunos:stair_wood_nodrop"},
	["stairs:slab_wood"] = {name="sunos:slab_wood_nodrop"},
	["stairs:stair_inner_wood"] = {name="sunos:stair_inner_wood_nodrop"},
	["stairs:stair_outer_wood"] = {name="sunos:stair_outer_wood_nodrop"},
	["stairs:stair_cobble"] = {name="sunos:stair_cobble_nodrop"},
	["stairs:slab_cobble"] = {name="sunos:slab_cobble_nodrop"},
	["stairs:stair_inner_cobble"] = {name="sunos:stair_inner_cobble_nodrop"},
	["stairs:stair_outer_cobble"] = {name="sunos:stair_outer_cobble_nodrop"},
	
}

-- Criar cópia sem Drop (para evitar furtos em estruturas dos sunos)
for nodename,dados in pairs(nodes_trocaveis_nodrop) do
	
	if minetest.registered_nodes[nodename] then 
		-- Copiar tabela de definições
		local def = {}
		for n,d in pairs(minetest.registered_nodes[nodename]) do
			def[n] = d
		end
		
		-- Mantem a tabela groups separada
		def.groups = minetest.deserialize(minetest.serialize(def.groups))
		
		-- Altera alguns paremetros
		def.description = def.description .. " ("..S("Sem Drop")..")"
		def.groups.not_in_creative_inventory = 1
		def.drop = ""
		
		-- Registra o novo node
		minetest.register_node(dados.name, def)
	end
end
