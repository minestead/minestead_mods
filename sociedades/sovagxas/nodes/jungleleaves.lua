--[[
	Mod Sovagxas para Minetest
	Copyright (C) 2018 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Jungle Leaves
  ]]

-- Tradução de strings
local S = sovagxas.S

-- Criar cópia sem Drop (para evitar furtos em estruturas dos sunos)
do
	-- Copiar tabela de definições
	local def = {}
	for n,d in pairs(minetest.registered_nodes["default:jungleleaves"]) do
		def[n] = d
	end
	-- Mantem a tabela groups separada
	def.groups = minetest.deserialize(minetest.serialize(def.groups))
	
	-- Altera alguns paremetros
	def.description = def.description .. " ("..S("de arvore sovagxa")..")"
	def.groups.not_in_creative_inventory = 1
	def.drop = ""
	-- Registra o novo node
	minetest.register_node("sovagxas:jungleleaves", def)
end


