
if minetest.get_modpath("technic") then
	table.insert(jumpdrive.blacklist, "technic:forcefield_emitter_on")
end

if minetest.get_modpath("advtrains") then
	table.insert(jumpdrive.blacklist, "advtrains:dtrack_atc_st")
	table.insert(jumpdrive.blacklist, "advtrains:dtrack_bumper_st")

	table.insert(jumpdrive.blacklist, "advtrains:dtrack_cr")
	table.insert(jumpdrive.blacklist, "advtrains:dtrack_cr_30")
	table.insert(jumpdrive.blacklist, "advtrains:dtrack_cr_45")
	table.insert(jumpdrive.blacklist, "advtrains:dtrack_cr_60")
	table.insert(jumpdrive.blacklist, "advtrains:dtrack_detector_off_st")
	table.insert(jumpdrive.blacklist, "advtrains:dtrack_st")
	table.insert(jumpdrive.blacklist, "advtrains:dtrack_st_30")
	table.insert(jumpdrive.blacklist, "advtrains:dtrack_st_45")
	table.insert(jumpdrive.blacklist, "advtrains:dtrack_st_60")
	table.insert(jumpdrive.blacklist, "advtrains:dtrack_vst1")
	table.insert(jumpdrive.blacklist, "advtrains:dtrack_vst2")
	table.insert(jumpdrive.blacklist, "advtrains:dtrack_swlcr")
	table.insert(jumpdrive.blacklist, "advtrains:dtrack_swlcr_30")
	table.insert(jumpdrive.blacklist, "advtrains:dtrack_swlcr_60")
	table.insert(jumpdrive.blacklist, "advtrains:dtrack_swrcr")
	table.insert(jumpdrive.blacklist, "advtrains:dtrack_swrcr_30")
	table.insert(jumpdrive.blacklist, "advtrains:dtrack_swrcr_60")
	table.insert(jumpdrive.blacklist, "advtrains:dtrack_swlst")
	table.insert(jumpdrive.blacklist, "advtrains:dtrack_swlst_30")
	table.insert(jumpdrive.blacklist, "advtrains:dtrack_swlst_60")
	table.insert(jumpdrive.blacklist, "advtrains:dtrack_swrst")
	table.insert(jumpdrive.blacklist, "advtrains:dtrack_swrst_30")
	table.insert(jumpdrive.blacklist, "advtrains:dtrack_swrst_60")
	table.insert(jumpdrive.blacklist, "advtrains:dtrack_vst1")
	table.insert(jumpdrive.blacklist, "advtrains:dtrack_vst2")
	table.insert(jumpdrive.blacklist, "advtrains:dtrack_vst31")
	table.insert(jumpdrive.blacklist, "advtrains:dtrack_vst32")
	table.insert(jumpdrive.blacklist, "advtrains:dtrack_vst33")
	table.insert(jumpdrive.blacklist, "advtrains:platform_high_sandstonebrick")
	table.insert(jumpdrive.blacklist, "advtrains:platform_low_sandstonebrick")
	table.insert(jumpdrive.blacklist, "advtrains:platform_high_stonebrick")
	table.insert(jumpdrive.blacklist, "advtrains:platform_low_stonebrick")
	table.insert(jumpdrive.blacklist, "advtrains:signal_on")
	table.insert(jumpdrive.blacklist, "advtrains:signal_off")
	table.insert(jumpdrive.blacklist, "advtrains_interlocking:tcb_node")
	table.insert(jumpdrive.blacklist, "advtrains_line_automation:dtrack_stop_st")
end

if minetest.get_modpath("moremesecons_wireless") then
	table.insert(jumpdrive.blacklist, "moremesecons_wireless:wireless")
	table.insert(jumpdrive.blacklist, "moremesecons_wireless:wireless_on")
	table.insert(jumpdrive.blacklist, "moremesecons_wireless:wireless_off")
	table.insert(jumpdrive.blacklist, "moremesecons_wireless:jammer")
	table.insert(jumpdrive.blacklist, "moremesecons_wireless:jammer_on")
	table.insert(jumpdrive.blacklist, "moremesecons_wireless:jammer_off")
end

if minetest.get_modpath("tubelib_addons3") then
	table.insert(jumpdrive.blacklist, "tubelib_addons3:teleporter")
	table.insert(jumpdrive.blacklist, "tubelib:forceload")
end

-- TODO bedrock, advtrains tracks
