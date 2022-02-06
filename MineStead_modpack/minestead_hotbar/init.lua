local mod_storage = minetest.get_mod_storage()

local function validate_size(s)
	local size = s and tonumber(s) or 8
	return math.floor(0.5 + math.max(1, math.min(size, 32)))
end

local hotbar_size_default = 8

local base_img = "gui_hb_bg_1.png"
local imgref_len = string.len(base_img) + 8 -- accounts for the stuff in the string.format() below.

local img = {}
for i = 0, 31 do
	img[i+1] = string.format(":%04i,0=%s", i*64, base_img)
end
local hb_img = table.concat(img)

local function set_hotbar_size(player, s)
	local hotbar_size = validate_size(s)
	player:hud_set_hotbar_itemcount(hotbar_size)
	player:hud_set_hotbar_selected_image("gui_hotbar_selected.png")
	player:hud_set_hotbar_image("[combine:"..(hotbar_size*64).."x64"..string.sub(hb_img, 1, hotbar_size*imgref_len))
	return hotbar_size
end

minetest.register_on_joinplayer(function(player)
	minetest.after(0.5,function()
	    local size = mod_storage:get_int(player:get_player_name())
	    if size == 0 then
		  size = hotbar_size_default
		end
		set_hotbar_size(player, size)
	end)
end)

minetest.register_chatcommand("hotbar", {
	params = "[size]",
	description = "Sets the size of your hotbar, from 1 to 32 slots, default 8",
	privs = { hotbar = true },
	func = function(name, slots)
		local size = set_hotbar_size(minetest.get_player_by_name(name), slots)
		minetest.chat_send_player(name, "[_] Hotbar size set to " ..size.. ".")
		mod_storage:set_int(name, size)
	end,
})

minetest.register_privilege("hotbar", {
    description = "Allows to set hotbar size"
})
