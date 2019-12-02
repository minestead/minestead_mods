local has_xp_redo_mod = minetest.get_modpath("xp_redo")
local has_mobs_mod = minetest.get_modpath("mobs")
local has_unified_inv = minetest.get_modpath("unified_inventory")
local has_mesecons = minetest.get_modpath("mesecons")

local MP = minetest.get_modpath("missions")

missions = {
	form = {},
	hud = {
		posx = tonumber(minetest.settings:get("missions.hud.offsetx") or 0.7),
		posy = tonumber(minetest.settings:get("missions.hud.offsety") or 0.2)
	},
	MISSION_ATTRIBUTE_NAME = "currentmission",
	CURRENT_MISSION_SPEC_VERSION = 2, -- see executor.lua:missions.start()

	SMALLFORMBG = "bgcolor[#f4d142BB]" ..
		"listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF]",

	FORMBG = "bgcolor[#f4d142BB]" ..
		"image[7,0;missions_block_preview.png]" ..
		"listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF]"
}

-- forms
dofile(MP.."/form.missionblock_main.lua")
dofile(MP.."/form.missionblock_stepeditor.lua")
dofile(MP.."/form.missionblock_config.lua")
dofile(MP.."/form.missionblock_user.lua")
dofile(MP.."/form.missionblock_stats.lua")
dofile(MP.."/form.missionblock_help.lua")
dofile(MP.."/form.newstep.lua")
dofile(MP.."/form.wand.lua")

dofile(MP.."/migrate.lua")
dofile(MP.."/privs.lua")
dofile(MP.."/chat.lua")
dofile(MP.."/functions.lua")
dofile(MP.."/validate.lua")
dofile(MP.."/hud.lua")
dofile(MP.."/block.lua")
dofile(MP.."/wand.lua")

if has_unified_inv then
	dofile(MP.."/ui.lua")
end

-- executor
dofile(MP.."/executor.lua")
dofile(MP.."/executor.hud.lua")

-- step register
dofile(MP.."/register_step.lua")

-- step specs
dofile(MP.."/steps/waypoint.lua")
dofile(MP.."/steps/dig.lua")
dofile(MP.."/steps/digspecific.lua")
dofile(MP.."/steps/build.lua")
dofile(MP.."/steps/buildspecific.lua")
dofile(MP.."/steps/chestput.lua")
dofile(MP.."/steps/chestreward.lua")
dofile(MP.."/steps/givereward.lua")
dofile(MP.."/steps/message.lua")
dofile(MP.."/steps/teleport.lua")
dofile(MP.."/steps/grant.lua")
dofile(MP.."/steps/revokeinteract.lua")
dofile(MP.."/steps/givebook.lua")
dofile(MP.."/steps/checkpriv.lua")
dofile(MP.."/steps/limitedtries.lua")
-- dofile(MP.."/steps/followup.lua")

if has_mesecons then
	dofile(MP.."/steps/mesecons_receptor_on.lua")
end

if has_xp_redo_mod then
	dofile(MP.."/steps/checkxp.lua")
	dofile(MP.."/steps/givexp.lua")
end

if has_mobs_mod then
	dofile(MP.."/steps/spawnmob.lua")
end

print("[OK] Missions")
