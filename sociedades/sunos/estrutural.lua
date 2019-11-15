--[[
	Mod Sunos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Algoritimos de formação de estruturas
  ]]

-- Tabela de metodos
sunos.estrutural = {}

-- Preenche uma area com um node
sunos.estrutural.preencher = function(minp, maxp, node)
	sunos.checkvar(minp, maxp, "Coordenadas maior e/ou menor invalidas ao preencher uma area")
	sunos.checkvar(node, "Nenhum node de preenchimento informado ao preencher uma area")
	
	for x = minp.x, maxp.x, 1 do
		for y = minp.y, maxp.y, 1 do
			for z = minp.z, maxp.z, 1 do
				minetest.set_node({x=x,y=y,z=z}, {name=node})
			end 
		end 
	end 
	
	-- Retorna sem erros
	return true
end



