
local S = technic.getter

function technic.register_transmutator(data)
	data.typename = "transmutating"
	data.machine_name = "transmutator"
	data.machine_desc = S("%s Transmutator")
	technic.register_base_machine(data)
end
