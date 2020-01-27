
-- create formspec from text file
local function get_formspec()
	local news_file = io.open(minetest.get_worldpath().."/news.txt", "r")
	local news_fs = 'size[12,8.25]'..
		"button_exit[-0.05,7.8;2,1;exit;Close]"
	if news_file then
		local news = news_file:read("*a")
		news_file:close()
		news_fs = news_fs.."textarea[0.25,0;12.1,9;;;"..news.."]"
	else
		news_fs = news_fs.."textarea[0.25,0;12.1,9;;;No current news.]"
	end
	return news_fs
end

-- show news formspec on player join, unless player has bypass priv
minetest.register_on_joinplayer(function (player)
	local name = player:get_player_name()
        local meta = player:get_meta()
	if meta:get_int("servernews:disabled") == 1 then
		minetest.chat_send_player(name, "Новости сервера можно посмотреть командой /news")
		return
	else
		minetest.show_formspec(name, "news", get_formspec())
	end
end)

-- command to display server news at any time
minetest.register_chatcommand("news", {
	params = "[on/off]",
	description = "Shows server news to the player. Disable news at join: '/news off', enable again: '/news on'",
	func = function (name, param)
		local player = minetest.get_player_by_name(name)
		if not player then
		    return false, "Player not found"
		end
		if param == "off" then
			local meta = player:get_meta()
			meta:set_int("servernews:disabled", 1)
			minetest.chat_send_player(name, "Disabled server news at join.")
		elseif param == "on" then
			local meta = player:get_meta()
			meta:set_int("servernews:disabled", 0)
			minetest.chat_send_player(name, "Enabled server news at join.")
		else
		    minetest.show_formspec(name, "news", get_formspec())
		end
	end
})
