
missions.register_step({

	type = "limitedtries",
	name = "Limited tries",

	create = function()
		return {maxcount=1, counts={}} -- "xy"=1
	end,

	edit_formspec = function(ctx)
		local stepdata = ctx.step.data
		local stepnumber = ctx.stepnumber

		local formspec = "size[8,8;]" ..
			"label[0,0;Limited tries (Step #" .. stepnumber .. ")]" ..

			"field[0,2;8,1;maxcount;Count;" .. stepdata.maxcount ..  "]" ..
			"button[0,7;8,1;save;Save]"

		return formspec;
	end,

	update = function(ctx)
		local fields = ctx.fields
		local stepdata = ctx.step.data

		if fields.maxcount then
			local maxcount = tonumber(fields.maxcount)
			if maxcount and maxcount > 0 then
				stepdata.maxcount = maxcount
			end
		end

		if fields.save then
			ctx.show_mission()
		end
	end,

	on_step_enter = function(ctx)
		local player = ctx.player
		local playername = player:get_player_name()
		local stepdata = ctx.step.data

		local count_map_str = ctx.block_meta:get_string("limitedtries")
		local count_map = {}

		if count_map_str ~= nil and count_map_str ~= "" then
			count_map = minetest.deserialize(count_map_str)
		end

		local tries = count_map[playername] or 0

		count_map[playername] = tries + 1
		ctx.block_meta:set_string("limitedtries", minetest.serialize(count_map))

		if tries < stepdata.maxcount then
			ctx.on_success()
		else
			ctx.on_failed("Number of tries exceeded!")
		end
	end

})
