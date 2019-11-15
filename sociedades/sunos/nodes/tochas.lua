--[[
	Mod Sunos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Itens para vendas
  ]]


-- Tradução de strings
local S = sunos.S


-- Criar cópia sem Drop das tochas (para evitar furtos em estruturas dos sunos, ou apagamento de tochas por outros mods)
do
	for original, novo in pairs({
		["default:torch"] = "sunos:torch_nodrop",
		["default:torch_ceiling"] = "sunos:torch_ceiling_nodrop",
		["default:torch_wall"] = "sunos:torch_wall_nodrop"
	}) do
		-- Copiar tabela de definições
		local def = {}
		for n,d in pairs(minetest.registered_nodes[original]) do
			def[n] = d
		end
		-- Mantem a tabela groups separada
		def.groups = minetest.deserialize(minetest.serialize(def.groups))
		
		-- Evita todas chamadas
		def.on_use = nil
		def.on_place = nil
		def.after_place_node = nil
		def.on_dig = nil
		
		-- Altera alguns paremetros
		def.description = minetest.registered_nodes[original].description .. " ("..S("Sem Drop")..")"
		def.groups.not_in_creative_inventory = 1
		def.drop = "default:torch"
		
		-- Registra o novo node
		minetest.register_node(novo, def)
	end
end
