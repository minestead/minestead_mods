--[[
	Mod Sunos para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Verificação de variaveis
	
	Isso serve para auxiliar no rastreamento de erros
  ]]

-- Verificar uma variavel
-- O argumento final deve ser a mensagem de erro
sunos.checkvar = function(...)
	local vars = {...}
	local msg = vars[table.maxn(vars)]
	for i=1, table.maxn(vars)-1, 1 do
		if not vars[i] then
			minetest.log("error", "[Sunos] "..msg)
			return false
		end
	end
	return true
end
