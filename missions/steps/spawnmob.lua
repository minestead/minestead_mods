
local mob_names = {} -- list<name>

for i,item in pairs(minetest.registered_items) do
	if item.groups.spawn_egg == 1 then
		-- TODO: is this even reliable: item-name == mob-name?
		table.insert(mob_names, item.name)
	end
end

missions.register_step({

	type = "spawnmob",
	name = "Spawn mob",

	privs = {missions_mobs=true},

	create = function()
		return {mobname="", pos=nil}
	end,

	validate = function(ctx)
		local stepdata = ctx.step.data

		if stepdata.pos == nil then
			return {
				success=false,
				failed=true,
				msg="No position defined"
			}
		end
		if stepdata.mobname == "" then
			return {
				success=false,
				failed=true,
				msg="No mobname defined"
			}
		end
		if not minetest.registered_items[stepdata.mobname] then
			return {
				success=false,
				failed=true,
				msg="No such mob: '" .. stepdata.mobname .. "'"
			}
		end
		return {success=true}
	end,

	allow_inv_stack_put = function(listname, index, stack)
		-- allow position wand on pos 1 of main inv
		if listname == "main" and index == 1 and stack:get_name() == "missions:wand_position" then
			return true
		end

		return false
	end,

	edit_formspec = function(ctx)
		local stepdata = ctx.step.data
		local pos = ctx.pos
		local name = ""

		if stepdata.pos then
			local distance = vector.distance(pos, stepdata.pos)
			name = name .. "Position(" .. stepdata.pos.x .. "/" ..
				stepdata.pos.y .. "/" .. stepdata.pos.z ..") " ..
				"Distance: " .. math.floor(distance) .. " m"
		end


		local selected = 1
		local list = ""
		for i,mname in ipairs(mob_names) do
			if mname == stepdata.mobname then
				selected = i
			end

			list = list .. minetest.formspec_escape(mname)
			if i < #mob_names then
				-- not end of list
				list = list .. ","
			end
		end

		local formspec = "size[8,9;]" ..
			"label[0,0;Spawn mob]" ..
			"textlist[0,1;8,5;mobname;" .. list .. ";" .. selected .. "]" ..

			"list[nodemeta:" .. pos.x .. "," .. pos.y .. "," .. pos.z .. ";main;0,6;1,1;0]" ..
			"label[2,6;" .. name .. "]" ..

			"list[current_player;main;0,7;8,1;]" ..

			"button[0,8;8,1;save;Save]"

		return formspec;
	end,

	update = function(ctx)
		local fields = ctx.fields
		local stepdata = ctx.step.data
		local inv = ctx.inv

		if fields.mobname then
			local parts = fields.mobname:split(":")
			if parts[1] == "CHG" then
				local selected_mob = tonumber(parts[2])
				stepdata.mobname = mob_names[selected_mob]
			end
		end

		if fields.save then
			local stack = inv:get_stack("main", 1)

			if not stack:is_empty() then
				local meta = stack:get_meta()
				local pos = minetest.string_to_pos(meta:get_string("pos"))

				stepdata.pos = pos
			end

			ctx.show_mission()
		end


	end,

	on_step_enter = function(ctx)
		local stepdata = ctx.step.data
		local pos = stepdata.pos
		pos.y = pos.y + 1

		minetest.add_entity(pos, stepdata.mobname)
		ctx.on_success()
	end

})


