--[[
	Mod Sovagxas para Minetest
	Copyright (C) 2018 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Métodos para atualizar mundos tornandos compativeis 
	com as novas versões do projeto quando atualizada
  ]]

-- Verifica se a versao informada é compativel com a versao atual
sovagxas.verif_comp = function(versao)

	if not versao or versao == "" then return false end
	
	if versao == sovagxas.versao 
		or sovagxas.versao_comp[versao]
	then 
		return true 
	end
	
	return false
end 

-- LBM para remover nodes com versao errada
minetest.register_lbm({
	name = "sovagxas:compatibilidade_nodes",
	nodenames = {"sovagxas:bau"},
	run_at_every_load = true,
	action = function(pos, node)
		local meta = minetest.get_meta(pos)
		
		if sovagxas.verif_comp(meta:get_string("versao")) == false then
			local node = minetest.get_node(pos)
			minetest.set_node(pos, {name="default:chest", param2 = node.param2})
		end
	end,
})

