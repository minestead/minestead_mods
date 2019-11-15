--[[
	Mod Sunos para Minetest
	Copyright (C) 2018 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Métodos para atualizar mundos tornandos compativeis 
	com as novas versões do projeto quando atualizada
  ]]

-- Verifica se a versao informada é compativel com a versao atual
sunos.verif_comp = function(versao)

	if not versao or versao == "" then return false end
	
	if versao == sunos.versao 
		or sunos.versao_comp[versao]
	then 
		return true 
	end
	
	return false
end 

-- LBM para remover nodes com versao errada
minetest.register_lbm({
	name = "sunos:compatibilidade_nodes",
	nodenames = {"sunos:fundamento"},
	run_at_every_load = true,
	action = function(pos, node)
		local meta = minetest.get_meta(pos)
		
		if sunos.verif_comp(meta:get_string("versao")) == false then
			local dist = meta:get_string("dist")
			if dist ~= "" then
				sunos.montar_ruinas(pos, tonumber(dist))
			end
			minetest.remove_node(pos)
			minetest.set_node(pos, {name="default:cobble"})
		end
	end,
})

