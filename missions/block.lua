
minetest.register_node("missions:mission", {
	description = "Mission block",
	tiles = {
		"default_gold_block.png",
		"default_gold_block.png",
		"default_gold_block.png^default_paper.png^missions_m_overlay.png",
		"default_gold_block.png^default_paper.png^missions_m_overlay.png",
		"default_gold_block.png^default_paper.png^missions_m_overlay.png",
		"default_gold_block.png^default_paper.png^missions_m_overlay.png"
	},
	groups = {
		cracky = 3,
		oddly_breakable_by_hand = 3,
		mesecon_needs_receiver = 1
	},
	sounds = default.node_sound_glass_defaults(),

	after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos)
		local playername = placer:get_player_name() or ""
		meta:set_string("owner", playername)
		meta:set_int("time", 300)
		meta:set_int("hidden", 0)
		meta:set_int("valid", 1)
		meta:set_string("validationresult", "")
		meta:set_string("name", "")
		meta:set_string("description", "")

		local inv = meta:get_inventory()
		inv:set_size("main", 8)
	end,

	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		if inv:get_stack(listname, index):get_count() == 0 then
			-- target inv empty

			local steps = missions.get_steps(pos)
			local selected_step = missions.get_selected_list_item(player)

			local step = steps[selected_step]
			if step == nil then
				-- no such step, get the first one
				missions.set_selected_list_item(player, 1)
				step = steps[1]

				if step == nil then
					-- something is wrong: inv put without a step...
					return 0
				end
			end

			local spec = missions.get_step_spec_by_type(step.type)

			if spec.allow_inv_stack_put then
				-- delegate to spec check
				if spec.allow_inv_stack_put(listname, index, stack) then
					return stack:get_count()
				else
					return 0
				end
			end

			return stack:get_count()
		else
			-- target inv not empty, disallow swapping
			return 0
		end
	end,

	on_metadata_inventory_put = function(pos, listname, index, stack, player)
		--copy items from player to local inv
		local inv = player:get_inventory()
		inv:add_item("main", stack)
	end,

	allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		--remove items if taken from inv
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_stack(listname, index, ItemStack(""))
		return 0
	end,

	can_dig = missions.only_owner_can_dig,

	on_construct = function(pos)
		missions.set_steps(pos, {})
	end,

	on_rightclick = missions.form.missionblock_main
})




minetest.register_craft({
	output = "missions:mission",
	recipe = {
		{"missions:wand", "", "missions:wand"},
		{"", "default:goldblock", ""},
		{"", "default:paper", ""}
	}
})
