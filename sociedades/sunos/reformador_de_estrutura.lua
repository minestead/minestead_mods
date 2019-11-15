--[[
	Mod Sunos para Minetest
	Copyright (C) 2018 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Reformador de estruturas
  ]]

-- Caminho do diretório do mod
local modpath = minetest.get_modpath("sunos")

-- Restaurar estrutura
sunos.restaurar_estrutura = function(pos)
	
	local meta = minetest.get_meta(pos)
	local table = meta:to_table() -- salva metadados numa tabela
	local vila = meta:get_string("vila")
	local tipo = meta:get_string("tipo")
	local dist = tonumber(meta:get_string("dist"))
	local schem = meta:get_string("schem")
	local rotat = meta:get_string("rotat")
	
	if sunos.estruturas[tipo].antes_restaurar_estrutura then
		sunos.estruturas[tipo].antes_restaurar_estrutura(pos)
	end
	
	local pos1 = {x=pos.x-dist, y=pos.y, z=pos.z-dist}
	local pos2 = {x=pos.x+dist, y=pos.y+14, z=pos.z+dist}
	
	-- Limpar metadados dos nodes que possam estar la
	sunos.limpar_metadados(pos1, pos2)
	
	-- Remonta estrutura
	sunos.montar_estrutura(pos, dist, tipo, rotat, schem)
	
	-- Estantes se mantem altomaticamente por sobreposição
	
	-- Ajustar fornos
	sunos.ajustar_fornos(pos, dist)
	
	-- Reestabelece fundamento
	minetest.set_node(pos, {name="sunos:fundamento"})
	minetest.get_meta(pos):from_table(table) -- recoloca metadados no novo fumdamento
	
	if sunos.estruturas[tipo].apos_restaurar_estrutura then
		sunos.estruturas[tipo].apos_restaurar_estrutura(pos)
	end
end

-- Reforma as estruturas
minetest.register_abm({
	label = "Reforma de estruturas",
	nodenames = {"sunos:fundamento"},
	interval = sunos.var.tempo_verif_restauro,
	chance = 3,
	action = function(pos)
		
		-- Verifica se a casa está muito destruida
		if sunos.contar_blocos_destruidos(pos) ~= 0 then
			local meta = minetest.get_meta(pos)
			local dist = tonumber(meta:get_string("dist"))
			local vila = tonumber(meta:get_string("vila"))
			
			-- Verifica se tem jogadores no interior da estrutura
			for _,obj in ipairs(minetest.get_objects_inside_radius({x=pos.x, y=pos.y+7, z=pos.z}, 7)) do
				if obj:is_player() then
					return -- Cancela
				end
			end
			
			-- Verificando estrutura
			sunos.verificar_fundamento(pos)
			
			-- Restaura estrutura
			sunos.restaurar_estrutura(pos)
		end
	end,
})
