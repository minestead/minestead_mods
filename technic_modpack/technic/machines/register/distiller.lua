
local S = technic.getter

function technic.register_distiller(data)
	data.typename = "distilling"
	data.machine_name = "distiller"
	data.machine_desc = S("%s Distiller")
	technic.register_base_machine(data)
end
