--[[
	Mod Sunos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Diretrizes das casas
  ]]

-- Tabela de variaveis da estrutura personalizadas
sunos.estruturas.casa.var = {}

-- Nodes decorativos simples
sunos.estruturas.casa.var.decor_simples = {
	"flowers:mushroom_brown",
	"vessels:glass_bottle",
	"vessels:drinking_glass",
	"sunos:nectar_node_nodrop",
}

-- Tabela de população por tamanho de casa
sunos.estruturas.casa.var.tb_pop_casa = {
	-- Largura da casa	População
	["5"] = 		1,
	["7"] =			2,
	["9"] =			3,
}

-- Tabela de tempo para construir por tamanho de casa
sunos.estruturas.casa.var.tb_tempo_construindo_casa = {
	-- Largura da casa	Dias
	["5"] = 		1,
	["7"] =			2,
	["9"] =			3,
}

-- Itens que aparecem nas estantes de livros
sunos.estruturas.casa.var.estante_livros = {
	"default:book",
}


-- Itens que aparecem nas estantes de frascos
sunos.estruturas.casa.var.estante_frascos = {
	"vessels:glass_bottle"
}
