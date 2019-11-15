
if minetest.get_modpath("technic") then
	table.insert(jumpdrive.blacklist, "technic:forcefield_emitter_on")
end

if minetest.get_modpath("advtrains") then
	table.insert(jumpdrive.blacklist, "advtrains:dtrack_atc_st")
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
	table.insert(jumpdrive.blacklist, "advtrains:platform_high_stonebrick")
	table.insert(jumpdrive.blacklist, "advtrains:platform_low_stonebrick")
end

-- TODO bedrock, advtrains tracks