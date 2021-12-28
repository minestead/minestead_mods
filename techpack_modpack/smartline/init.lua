--[[

	SmartLine
	=========
	
	Copyright (C) 2017-2020 Joachim Stolberg

	AGPL v3
	See LICENSE.txt for more information

]]--

smartline = {}

-- Load support for I18n
smartline.S = minetest.get_translator("smartline")

local MP = minetest.get_modpath("smartline")

dofile(MP.."/display.lua")
dofile(MP.."/button.lua")
dofile(MP.."/signaltower.lua")
dofile(MP.."/playerdetector.lua")
dofile(MP.."/sequencer.lua")
dofile(MP.."/timer.lua")
dofile(MP.."/repeater.lua")
dofile(MP.."/collector.lua")
dofile(MP.."/controller.lua")
dofile(MP.."/commands.lua")
-- ICTA Controller
dofile(MP.."/icta/submenu.lua")
dofile(MP.."/icta/condition.lua")
dofile(MP.."/icta/action.lua")
dofile(MP.."/icta/formspec.lua")
dofile(MP.."/icta/controller.lua")
dofile(MP.."/icta/commands.lua")
dofile(MP.."/icta/edit.lua")
dofile(MP.."/icta/battery.lua")
dofile(MP.."/icta/balancer.lua")
dofile(MP.."/icta/stopwatch.lua")
