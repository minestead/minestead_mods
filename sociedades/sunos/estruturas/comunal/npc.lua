--[[
	Mod Sunos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	NPC das casas
  ]]

-- Tradução de strings
local S = sunos.S

-- Solo de barman (separa as areas do barman)
do
	-- Copiar tabela de definições do bau comum
	local def = {}
	for n,d in pairs(minetest.registered_nodes["default:cobble"]) do
		def[n] = d
	end
	-- Altera alguns paremetros
	def.description = S("Solo de Atendente Comunal dos Sunos")
	def.tiles = {"default_cobble.png^sunos_solo_atendente.png"}
	def.drop = "default:cobble"
	-- Registra o novo node
	minetest.register_node("sunos:solo_atendente_comunal", def)
end

-- Registrar NPC comunal (atendente)
sunos.npcs.npc.registrar("comunal", {
		
	drops = {
		{name = "default:wood", chance = 1, min = 1, max = 3},
		{name = "default:apple", chance = 2, min = 1, max = 2},
		{name = "default:axe_stone", chance = 5, min = 1, max = 1},
	},
	
	on_spawn = function(self)
		
		-- Fica observando o ambiente
		npc.exec.enqueue_program(self, "advanced_npc:idle", 
			{
				acknowledge_nearby_objs = true,
			},
			{},
			true
		)
	end,
})


