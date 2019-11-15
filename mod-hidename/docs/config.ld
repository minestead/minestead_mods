title = 'Hide Name mod for Minetest'
project = 'Hide Name'
format = 'markdown'
not_luadoc = true

file = {'api.lua', 'command.lua'}

local function italic(value)
	return '<i>' .. value .. '</i>'
end

new_type('setting', 'Settings')
new_type('chatcmd', 'Chat Commands', false, 'option')
custom_tags = {
	{
		'chatparam',
		hidden = true,
	},
	{
		'option',
		title = 'Options',
		--[[
		format = function(item, handler)
			print(type(handler))
			print(type(item))
			print(item)
			return '<b><i>' .. name .. '</i></b>'
		end,
		]]
	},
	{'settype',
		title = 'Type',
		format = italic,
	},
	{'default',
		title = 'Default',
		format = italic,
	},
}

custom_display_name_handler = function(item, default_handler)
	if item.type == 'chatcmd' and item.tags.chatparam then
		return item.name .. ' [option]'
	end
	return default_handler(item)
end
