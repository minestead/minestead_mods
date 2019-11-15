--Simple head-up display for current position, time and server lag.

-- Origin:
--ver 0.2.1 minetest_time

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-------Minetest Time--kazea's code tweaked by cg72 with help from crazyR--------
----------------Zeno` simplified some math and additional tweaks ---------------
--------------------------------------------------------------------------------

poshud = {
	-- Position of hud
	posx = tonumber(minetest.settings:get("poshud.hud.offsetx") or 0.8),
	posy = tonumber(minetest.settings:get("poshud.hud.offsety") or 0.95),
	enable_mapblock = minetest.settings:get_bool("poshud.mapblock.enable")
}

--settings

colour = 0xFFFFFF  --text colour in hex format default is white
enable_star = true


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- hud id map (playername -> hud-id)
local player_hud = {}

-- hud enabled map (playername -> bool)
local player_hud_enabled = {}

local function generatehud(player)
	local name = player:get_player_name()

	if player_hud[name] then
		-- already set up
		return
	end

	local hud = {}
	hud.id = player:hud_add({
		hud_elem_type = "text",
		name = "poshud",
		position = {x=poshud.posx, y=poshud.posy},
		offset = {x=8, y=-8},
		text = "Initializing...",
		scale = {x=100,y=100},
		alignment = {x=1,y=0},
		number = colour, --0xFFFFFF,
	})
	player_hud[name] = hud
end

local function updatehud(player, text)
	local name = player:get_player_name()

	if player_hud_enabled[name]~=true then
		-- check if the player enabled the hud
		return
	end

	if not player_hud[name] then
		generatehud(player)
	end
	local hud = player_hud[name]
	if hud and text ~= hud.text then
		player:hud_change(hud.id, "text", text)
		hud.text = text
	end
end

local function removehud(player)
	local name = player:get_player_name()
	if player_hud[name] then
		player:hud_remove(player_hud[name].id)
		player_hud[name] = nil
	end
end

local function removecache(name)
	if player_hud[name] then
		player_hud[name] = nil
	end
end

minetest.register_on_leaveplayer(function(player)
	local name = player:get_player_name()
	minetest.after(1, removecache, name)
end)

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- hud enabled/disable


minetest.register_chatcommand("poshud", {
	params = "on|off",
	description = "Turn poshud on or off",
	func = function(name, param)
		local player = minetest.get_player_by_name(name)

		if param == "on" then
			player_hud_enabled[name] = true
			generatehud(player)

		elseif param == "off" then
			player_hud_enabled[name] = false
			removehud(player)

		else
			return true, "Usage: poshud [on|off]"

		end
	end
})


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- time
-- from https://gitlab.com/Rochambeau/mthudclock/blob/master/init.lua

local function floormod ( x, y )
	return (math.floor(x) % y);
end

local function get_time()
	local secs = (60*60*24*minetest.get_timeofday());
	local s = floormod(secs, 60);
	local m = floormod(secs/60, 60);
	local h = floormod(secs/3600, 60);
	return ("%02d:%02d"):format(h, m);
end

-- rotating star
local star={"\\", "|", "/", "-"}

-- New lagometry algorithm:
-- Make a list of N samples
-- Every sample is time from last step, therefore "lag"
-- Since time distance between samples is not equal, every sample needs
-- to be weighted by... time, which is itself. This results in:
-- avg_lag = sum(xi^2) / sum(xi)
-- Results of sums are cached for performance (subtract old sample, add new sample)

local l_time = 0
local l_N = 2048
local l_samples = {}
local l_ctr = 0
local l_sumsq = 0
local l_sum = 0
local l_max = 0.1


local h_text = "Initializing..."
local h_int = 2
local h_tmr = 0

local starc = 0

minetest.register_globalstep(function (dtime)
	-- make a lag sample
	
	local news = os.clock() - l_time
	if l_time == 0 then
		news = 0.1
	end
	l_time = os.clock()
	
	local olds = l_samples[l_ctr+1] or 0
	l_sumsq = l_sumsq - olds*olds + news*news
	l_sum = l_sum - olds + news
	
	l_samples[l_ctr+1] = news
	l_max = math.max(l_max, news)
	
	l_ctr = (l_ctr + 1) % l_N
	
	if l_ctr == 0 then
		-- recalculate from scratch
		l_sumsq = 0
		l_sum = 0
		l_max = 0
		for i=1,l_N do
			local sample = l_samples[i]
			l_sumsq = l_sumsq + sample*sample
			l_sum = l_sum + sample
			l_max = math.max(l_max, sample)
		end
	end
	
	-- update hud text when necessary
	if h_tmr <= 0 then
		local l_avg = l_sumsq / l_sum
		-- Update hud text that is the same for all players
		local s_lag = string.format("Lag: %.2f avg: %.2f peak: %.2f", news, l_avg, l_max)
		local s_time = "Time: "..get_time()
		
		local s_rwt = ""
		if advtrains and advtrains.lines and advtrains.lines.rwt then
			s_rwt = "\nRailway Time: "..advtrains.lines.rwt.to_string(advtrains.lines.rwt.now(), true)
		end
		
		local s_star = ""
		if enable_star then
			s_star = star[starc+1]
            starc = (starc + 1) % 4
		end
		
		h_text = s_time .. "   " .. s_star .. s_rwt .. "\n" .. s_lag
		
		h_tmr = h_int
	else
		h_tmr = h_tmr - news
	end
	
	for _,player in ipairs(minetest.get_connected_players()) do
		updatehud(player,  h_text)
	end
end);
