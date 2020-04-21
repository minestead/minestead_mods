local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)

local ccompass_modpath = minetest.get_modpath("ccompass")
local compassgps_modpath = minetest.get_modpath("compassgps")
local default_modpath = minetest.get_modpath("default")
local unified_inventory_modpath = minetest.get_modpath("unified_inventory")
local sfinv_buttons_modpath = minetest.get_modpath("sfinv_buttons")
local sfinv_modpath = minetest.get_modpath("sfinv")

local modstore = minetest.get_mod_storage()

local ccompass_recalibration_allowed = minetest.settings:get_bool("ccompass_recalibrate", true)
local ccompass_restrict_target = minetest.settings:get_bool("ccompass_restrict_target", false)
local ccompass_description_prefix = "^Compass to "

local S = minetest.get_translator(modname)

local categories = {
	S("Location"),
	S("Event"),
	S("General"),
}

local LOCATION_CATEGORY = 1
local EVENT_CATEGORY = 2
local GENERAL_CATEGORY = 3

-- used for determining if an item is a ccompass
local ccompass_prefix = "ccompass:"
local ccompass_prefix_length = #ccompass_prefix

--------------------------------------------------------
-- Data store

local function get_state(player_name)
	local state = modstore:get(player_name .. "_state")
	if state then
		state = minetest.deserialize(state)
	end
	if not state then
		state = {category=LOCATION_CATEGORY, entry_selected={0,0,0}, entry_counts={0,0,0}}
	end
	return state
end

local function save_state(player_name, state)
	modstore:set_string(player_name .. "_state", minetest.serialize(state))
end

local function save_entry(player_name, category_index, entry_index, entry_text, topic_text)
	if topic_text then
		topic_text = topic_text:gsub("\r\n", "\n"):gsub("\r", "\n"):gsub("\n", " ")
		modstore:set_string(player_name .. "_category_" .. category_index .. "_entry_" .. entry_index .. "_topic",
			topic_text)
	end
	entry_text = entry_text:gsub("\r\n", "\n"):gsub("\r", "\n")
	modstore:set_string(player_name .. "_category_" .. category_index .. "_entry_" .. entry_index .. "_content",
		entry_text)
end

local function swap_entry(player_name, state, direction)
	local category_index = state.category
	local entry_index = state.entry_selected[category_index]
	local next_index = entry_index + direction
	if next_index < 1 or next_index > state.entry_counts[category_index] then
		return
	end
	
	local current_topic = modstore:get_string(player_name .. "_category_" .. category_index .. "_entry_" .. entry_index .. "_topic")
	local current_content = modstore:get_string(player_name .. "_category_" .. category_index .. "_entry_" .. entry_index .. "_content")
	local next_topic = modstore:get_string(player_name .. "_category_" .. category_index .. "_entry_" .. next_index .. "_topic")
	local next_content = modstore:get_string(player_name .. "_category_" .. category_index .. "_entry_" .. next_index .. "_content")

	save_entry(player_name, category_index, entry_index, next_content, next_topic)
	save_entry(player_name, category_index, next_index, current_content, current_topic)
	state.entry_selected[category_index] = next_index
	save_state(player_name, state)
end

local function delete_entry(player_name, state)
	local category_index = state.category
	local entry_count = state.entry_counts[category_index]
	if entry_count == 0 then
		return
	end
	local entry_index = state.entry_selected[category_index]

	for i = entry_index + 1, entry_count do
		local topic = modstore:get_string(player_name .. "_category_" .. category_index .. "_entry_" .. i .. "_topic")
		local content = modstore:get_string(player_name .. "_category_" .. category_index .. "_entry_" .. i .. "_content")
		save_entry(player_name, category_index, i-1, content, topic)
	end

	modstore:set_string(player_name .. "_category_" .. category_index .. "_entry_" .. entry_count .. "_topic", "")
	modstore:set_string(player_name .. "_category_" .. category_index .. "_entry_" .. entry_count .. "_content", "")
	entry_count = entry_count - 1
	state.entry_counts[category_index] = entry_count
	if entry_index > entry_count then
		state.entry_selected[category_index] = entry_count
	end
	save_state(player_name, state)
end

----------------------------------------------------------------------------------------
-- String functions

local truncate_string = function(target, length)
	if target:len() > length then
		return target:sub(1,length-2).."..."
	end
	return target
end

local first_line = function(target)
	local first_return = target:find("\n")
	if not first_return then
		first_return = #target
	else
		first_return = first_return - 1 -- trim the hard return off
	end
	return target:sub(1, first_return)
end


---------------------------------------
-- Reading and writing stuff to items


----------------------------------------------------------------
-- Export

-- Book parameters
local lpp = 14
local max_text_size = 10000
local max_title_size = 80
local short_title_size = 35
local function write_book(player_name)
	local state = get_state(player_name)
	local category = state.category
	local entry_selected = state.entry_selected[category]
	local content = modstore:get_string(player_name .. "_category_" .. category .. "_entry_" .. entry_selected .. "_content")
	local topic = modstore:get_string(player_name .. "_category_" .. category .. "_entry_" .. entry_selected .. "_topic")
	if state.category ~= 3 then
		-- If it's a location or an event, add a little context to the title
		topic = topic .. ": " .. first_line(content)
	end
	
	local new_book = ItemStack("default:book_written")
	local meta = new_book:get_meta()
	
	meta:set_string("owner", player_name)
	meta:set_string("title", topic:sub(1, max_title_size))
	meta:set_string("description", S("\"@1\" by @2", truncate_string(topic, short_title_size), player_name))
	meta:set_string("text", content:sub(1, max_text_size))
	meta:set_int("page", 1)
	meta:set_int("page_max", math.ceil((#content:gsub("[^\n]", "") + 1) / lpp))
	return new_book
end

local function write_cgpsmap(player_name)
	local state = get_state(player_name)
	local category = state.category
	if category ~= LOCATION_CATEGORY then
		return
	end
	local entry_selected = state.entry_selected[category]
	local content = modstore:get_string(player_name .. "_category_" .. category .. "_entry_" .. entry_selected .. "_content")
	local pos_string = modstore:get_string(player_name .. "_category_" .. category .. "_entry_" .. entry_selected .. "_topic")
	local meta = minetest.string_to_pos(pos_string)
	if not meta then
		return
	end
	meta.bkmrkname = content
	local new_map = ItemStack("compassgps:cgpsmap_marked")
	-- TODO: set_metadata is a deprecated function, but it is necessary because that's what cgpsmap uses.
	new_map:set_metadata(minetest.serialize(meta))
	return new_map
end

local function write_ccompass(player_name, old_compass)
	local state = get_state(player_name)
	local category = state.category
	if category ~= LOCATION_CATEGORY then
		return
	end
	local entry_selected = state.entry_selected[category]
	
	local topic = modstore:get_string(player_name .. "_category_" .. category .. "_entry_" .. entry_selected .. "_topic")
	local pos = minetest.string_to_pos(topic)
	if not pos then
		return
	end

	local content = modstore:get_string(player_name .. "_category_" .. category .. "_entry_" .. entry_selected .. "_content")
	content = truncate_string(first_line(content), max_title_size)
	local new_ccompass = ItemStack("ccompass:0")
	local param = {
		target_pos_string = topic,
		target_name = content,
		playername = player_name
	}
	ccompass.set_target(new_ccompass, param)
	return new_ccompass
end

local function write_item(player_name, itemstack)
	local item_name = itemstack:get_name()
	if item_name == "default:book" then
		return write_book(player_name)
	end
	if item_name == "compassgps:cgpsmap" then
		return write_cgpsmap(player_name)
	end
	if item_name:sub(1,ccompass_prefix_length) == ccompass_prefix then
		return write_ccompass(player_name, itemstack)
	end
end

----------------------------------------------------------------------------------------
-- Import

local function read_book(itemstack, player_name)
	local meta = itemstack:get_meta()
	local topic = meta:get_string("title")
	local content = meta:get_string("text")

	local date_string = topic:match("^%d%d%d%d%-%d%d%-%d%d")
	local pos_string = topic:match("^%(%-?[0-9]+,%-?[0-9]+,%-?[0-9]+%)")
	
	local category = GENERAL_CATEGORY
	if date_string then
		topic = date_string
		category = EVENT_CATEGORY
	elseif pos_string then
		topic = pos_string
		category = LOCATION_CATEGORY
	end
	
	local state = get_state(player_name)
	local entry_index = state.entry_counts[category] + 1
	state.entry_counts[category] = entry_index
	save_entry(player_name, category, entry_index, content, topic)
	save_state(player_name, state)
end

local function read_ccompass(itemstack, player_name)
	local meta = itemstack:get_meta()
	local topic = meta:get_string("target_pos")
	local content = meta:get_string("description")
	local prefix_start, prefix_end = content:find(ccompass_description_prefix)
	if prefix_end then
		content = content:sub(prefix_end+1)
	end	
	local state = get_state(player_name)
	local entry_index = state.entry_counts[LOCATION_CATEGORY] + 1
	state.entry_counts[LOCATION_CATEGORY] = entry_index
	save_entry(player_name, LOCATION_CATEGORY, entry_index, content, topic)
	save_state(player_name, state)
end

local function read_cgpsmap(itemstack, player_name)
	-- TODO: get_metadata is a deprecated function, but it is necessary because that's what cgpsmap uses.
	local meta = minetest.deserialize(itemstack:get_metadata())
	if not (meta and meta.x and meta.y and meta.z) then
		return
	end
	local content = meta.bkmrkname or ""
	local topic = minetest.pos_to_string(meta)
	local state = get_state(player_name)
	local entry_index = state.entry_counts[LOCATION_CATEGORY] + 1
	state.entry_counts[LOCATION_CATEGORY] = entry_index
	save_entry(player_name, LOCATION_CATEGORY, entry_index, content, topic)
	save_state(player_name, state)
end

local function read_item(itemstack, player_name)
	local item_name = itemstack:get_name()
	if item_name == "default:book_written" then
		read_book(itemstack, player_name)
	elseif item_name == "compassgps:cgpsmap_marked" then
		read_cgpsmap(itemstack, player_name)
	elseif item_name:sub(1,ccompass_prefix_length) == ccompass_prefix then
		read_ccompass(itemstack, player_name)
	end
end

--------------------------------------------------------------------------
-- Detached inventory

-- Allow or disallow ccompasses based on whether they've got target info in their meta
local function ccompass_permitted_target(itemstack)
	if ccompass_restrict_target then
		-- We have no idea whether there's an allowed node at this location, so don't allow
		-- setting compasses when node type restriction is enabled.
		return false
	end
	if not itemstack:get_name():sub(1,ccompass_prefix_length) == ccompass_prefix then
		return false
	end
	local meta = itemstack:get_meta()
	local has_pos = minetest.string_to_pos(meta:get_string("target_pos"))
	if has_pos and not ccompass_recalibration_allowed then
		return false
	end
	return true	
end
local function ccompass_permitted_source(itemstack)
	if not itemstack:get_name():sub(1,ccompass_prefix_length) == ccompass_prefix then
		return false
	end
	local meta = itemstack:get_meta()
	local has_pos = minetest.string_to_pos(meta:get_string("target_pos"))
	if not has_pos then
		return false
	end
	return true
end

local detached_callbacks = {
	allow_put = function(inv, listname, index, stack, player)
		local stack_name = stack:get_name()
		if listname == "export_item" then
			if stack_name == "default:book" then
				return 1
			end
			local player_name = player:get_player_name()
			local state = get_state(player_name)
			local category = state.category
			if category == LOCATION_CATEGORY and 
				(stack_name == "compassgps:cgpsmap" or
				ccompass_permitted_target(stack)) then
				return 1
			end
			return 0
		elseif listname == "import_item" then
			if stack_name == "default:book_written" or
				stack_name == "compassgps:cgpsmap_marked" or
				ccompass_permitted_source(stack) then
				return 1
			end
			return 0
		end
	end,
    on_put = function(inv, listname, index, stack, player)
		local player_name = player:get_player_name()
		if listname == "export_item" then
			local new_item = write_item(player_name, stack)
			inv:remove_item(listname, stack)		
			inv:add_item(listname, new_item)
		elseif listname == "import_item" then
			read_item(stack, player_name)
		end
	end,
}

local item_invs = {}
local function ensure_detached_inventory(player_name)
	if item_invs[player_name] or not(default_modpath or ccompass_modpath or compassgps_modpath) then
		return
	end
	local inv = minetest.create_detached_inventory("personal_log_"..player_name, detached_callbacks)
	inv:set_size("export_item", 1)
	inv:set_size("import_item", 1)
	item_invs[player_name] = true
end

-- if a player leaves stuff in their detached inventory, try giving it to them when they exit
local function try_return(detached_inv, player_inv, listname)
	local item = detached_inv:get_stack(listname, 1)
	item = player_inv:add_item("main", item)
	detached_inv:set_stack(listname, 1, item) -- if it didn't fit, put it back in detached and hope the player comes back
end
local function return_all_items(player)
	local player_name = player:get_player_name()
	if item_invs[player_name] then
		local player_inv = minetest.get_inventory({type="player", name=player_name})
		local detached_inv = minetest.get_inventory({type="detached", name="personal_log_"..player_name})
		try_return(detached_inv, player_inv, "export_item")
		try_return(detached_inv, player_inv, "import_item")
	end
end

------------------------------------------------------------------------
-- Import/export formspec

local import_mods = {}
local export_generic_mods = {}
local export_location_mods = {}
if default_modpath then
	table.insert(import_mods, S("a book"))
	table.insert(export_generic_mods, S("a book"))
	table.insert(export_location_mods, S("a book"))
end
if ccompass_modpath then
	table.insert(import_mods, S("a calibrated compass"))
	if not ccompass_restrict_target then
		table.insert(export_location_mods, S("a compass"))
	end
end
if compassgps_modpath then
	table.insert(import_mods, S("a GPS compass map"))
	table.insert(export_location_mods, S("a GPS compass map"))
end

local function aggregate_localized_string(list)
	if #list == 1 then
		return S("@1", list[1])
	end
	if #list == 2 then
		return S("@1 or @2", list[1], list[2])
	end
	if #list == 3 then
		return S("@1, @2 or @3", list[1], list[2], list[3])
	end
end

local import_label = aggregate_localized_string(import_mods)
local export_generic_label = aggregate_localized_string(export_generic_mods)
local export_location_label = aggregate_localized_string(export_location_mods)

local function item_formspec(player_name, category, listname, topic)
	local label
	if listname == "import_item" then
		label = S("Import an entry from @1", import_label)
	else
		if category == LOCATION_CATEGORY then
			label = S('Export "@1" to @2', topic, export_location_label)
		else
			label = S('Export "@1" to @2', topic, export_generic_label)
		end
	end

	local formspec = "size[8,6]"
		.. "label[0,1;" .. label .. "]"
		.. "list[detached:personal_log_"..player_name..";"..listname..";3.5,0;1,1;]"
		.. "list[current_player;main;0,1.5;8,4;]"
		.. "listring[]"
		.. "button[3.5,5.5;1,1;back;"..S("Back").."]"
		
	return formspec
end

---------------------------------------------------------------
-- Main formspec

local function make_personal_log_formspec(player)
	local player_name = player:get_player_name()

	local state = get_state(player_name)
	local category_index = state.category
	
	ensure_detached_inventory(player_name)
	
	local formspec = {
		"formspec_version[2]"
		.."size[10,10]"
		.."button_exit[9.0,0.25;0.5,0.5;close;X]"
		.."dropdown[1.5,0.25;2,0.5;category_select;"
		.. table.concat(categories, ",") .. ";"..category_index.."]"
		.. "label[0.5,0.5;"..S("Category:").."]"
		.. "label[4.5,0.5;"..S("Personal Log Entries").."]"
	}
	
	local entries = {}
	for i = 1, state.entry_counts[category_index] do
		table.insert(entries, modstore:get_string(player_name .. "_category_" .. category_index .. "_entry_" .. i .. "_content"))
	end
	local entry = ""
	local entry_selected = state.entry_selected[category_index]
	if entry_selected > 0 then
		entry = entries[entry_selected]
	end

	local topics = {}
	for i = 1, state.entry_counts[category_index] do
		table.insert(topics, modstore:get_string(player_name .. "_category_" .. category_index .. "_entry_" .. i .. "_topic"))
	end
	local topic = ""
	if entry_selected > 0 then
		topic = topics[entry_selected]
	end
	
	formspec[#formspec+1] = "tablecolumns[text;text]table[0.5,1.0;9,4.75;log_table;"
	for i, entry in ipairs(entries) do
		formspec[#formspec+1] = minetest.formspec_escape(truncate_string(topics[i], 30)) .. ","
		formspec[#formspec+1] = minetest.formspec_escape(truncate_string(first_line(entry), 30))
		formspec[#formspec+1] = ","
	end
	formspec[#formspec] = ";"..entry_selected.."]" -- don't use +1, this overwrites the last ","
	
	if category_index == GENERAL_CATEGORY then
		formspec[#formspec+1] = "textarea[0.5,6.0;9,0.5;topic_data;;" .. minetest.formspec_escape(topic) .. "]"
		formspec[#formspec+1] = "textarea[0.5,6.5;9,1.75;entry_data;;".. minetest.formspec_escape(entry) .."]"
	else
		formspec[#formspec+1] = "textarea[0.5,6.0;9,2.25;entry_data;;".. minetest.formspec_escape(entry) .."]"
	end

	formspec[#formspec+1] = "container[0.5,8.5]"
		.."button[0,0;2,0.5;save;"..S("Save").."]"
		.."button[2,0;2,0.5;create;"..S("New").."]"
		.."button[4.5,0;2,0.5;move_up;"..S("Move Up").."]"
		.."button[4.5,0.75;2,0.5;move_down;"..S("Move Down").."]"
		.."button[7,0;2,0.5;delete;"..S("Delete") .."]"

	if category_index == LOCATION_CATEGORY and minetest.check_player_privs(player_name, "teleport") then
		formspec[#formspec+1] = "button[7,0.75;2,0.5;teleport;"..S("Teleport") .."]"
	end

	if default_modpath or ccompass_modpath or compassgps_modpath then
		formspec[#formspec+1] = "button[0,0.75;2.0,0.5;copy_to;"..S("Export").."]"
			.."button[2,0.75;2.0,0.5;copy_from;"..S("Import").."]"
	end

	formspec[#formspec+1] = "container_end[]"

	return table.concat(formspec)
end

-------------------------------------------
-- Input handlers

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "personal_log:item" then
		return
	end
	if fields.back then
		return_all_items(player)
		minetest.show_formspec(player:get_player_name(),"personal_log:root", make_personal_log_formspec(player))
		return
	end
	if fields.quit then
		return_all_items(player)
		return
	end
end)

local function on_player_receive_fields(player, fields, update_callback)
	local player_name = player:get_player_name()
	local state = get_state(player_name)
	local category = state.category
	local entry_selected = state.entry_selected[category]
	local valid_entry_selected = entry_selected > 0 and entry_selected <= state.entry_counts[category]

	if fields.log_table then
		local table_event = minetest.explode_table_event(fields.log_table)
		if table_event.type == "CHG" then
			state.entry_selected[category] = table_event.row
			save_state(player_name, state)
			update_callback(player)
			return
		end
	end
	
	if fields.save then
		if category == GENERAL_CATEGORY then
			save_entry(player_name, category, entry_selected, fields.entry_data, fields.topic_data)
		else
			save_entry(player_name, category, entry_selected, fields.entry_data)
		end
		update_callback(player)
		return
	end
	
	if fields.create then
		local content = ""
		local general_topic = ""
		if entry_selected == 0 then
			content = fields.entry_data
			general_topic = fields.topic_data
		end
		
		local entry_index = state.entry_counts[category] + 1
		state.entry_counts[category] = entry_index
		state.entry_selected[category] = entry_index
		if category == LOCATION_CATEGORY then
			local pos = vector.round(player:get_pos())
			save_entry(player_name, category, entry_index, content, minetest.pos_to_string(pos))
		elseif category == EVENT_CATEGORY then
			local current_date = os.date("%Y-%m-%d")
			save_entry(player_name, category, entry_index, content, current_date)
		else
			save_entry(player_name, category, entry_index, content, general_topic)
		end
		save_state(player_name, state)
		update_callback(player)
		return
	end
	
	if fields.move_up then
		swap_entry(player_name, state, -1)
		update_callback(player)
		return
	end
	if fields.move_down then
		swap_entry(player_name, state, 1)
		update_callback(player)
		return
	end
	if fields.delete then
		delete_entry(player_name, state)
		update_callback(player)
		return
	end
	
	if fields.teleport
		and category == LOCATION_CATEGORY
		and valid_entry_selected
		and minetest.check_player_privs(player_name, "teleport") then
		local pos_string = modstore:get_string(player_name .. "_category_" .. category .. "_entry_" .. entry_selected .. "_topic")
		local pos = minetest.string_to_pos(pos_string)
		if pos then
			player:set_pos(pos)
		end
	end

	if fields.copy_to then
		if valid_entry_selected then
			local topic = modstore:get_string(player_name .. "_category_" .. category .. "_entry_" .. entry_selected .. "_topic")
			if category ~= 3 then
				-- If it's a location or an event, add a little context to the title
				local content = modstore:get_string(player_name .. "_category_" .. category .. "_entry_" .. entry_selected .. "_content")
				topic = S("@1: @2", topic, truncate_string(first_line(content), short_title_size))
			end
			minetest.show_formspec(player_name, "personal_log:item",
				item_formspec(player_name, category, "export_item", topic))
		end
		return
	end
	if fields.copy_from then
		minetest.show_formspec(player_name, "personal_log:item",
			item_formspec(player_name, category, "import_item"))
		return
	end

	-- Do this one last, since it should always be true and we don't want to do it if we don't have to
	if fields.category_select then
		for i, category in ipairs(categories) do
			if category == fields.category_select then
				if state.category ~= i then
					state.category = i
					save_state(player_name, state)
					update_callback(player)
					return
				else
					break
				end
			end
		end
	end
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "personal_log:root" then
		return
	end
	on_player_receive_fields(player, fields, function(player)
		minetest.show_formspec(player:get_player_name(), "personal_log:root", make_personal_log_formspec(player))
	end)
end)

-------------------------------------------------------------------------------------------------------
-- Inventory interface

if minetest.settings:get_bool("personal_log_inventory_button", true) then

-- Unified Inventory
if unified_inventory_modpath then
	unified_inventory.register_button("personal_log", {
		type = "image",
		image = "personal_log_open_book.png",
		tooltip = S("Your personal log for keeping track of what happens where"),
		action = function(player)
			local name = player:get_player_name()
			minetest.show_formspec(name,"personal_log:root", make_personal_log_formspec(player))
		end,
	})
end

-- sfinv_buttons
if sfinv_buttons_modpath then
	sfinv_buttons.register_button("personal_log", {
		image = "personal_log_open_book.png",
		tooltip = S("Your personal log for keeping track of what happens where"),
		title = S("Log"),
		action = function(player)
			local name = player:get_player_name()
			minetest.show_formspec(name,"personal_log:root", make_personal_log_formspec(player))
		end,
	})
elseif sfinv_modpath then
	sfinv.register_page("personal_log:personal_log", {
		title = S("Log"),
		get = function(_, player, context)
			local name = player:get_player_name()
			minetest.show_formspec(name,"personal_log:root", make_personal_log_formspec(player))
			return sfinv.make_formspec(player, context, "button[2.5,3;3,1;open_personal_log;"..S("Open personal log").."]", false)
		end,
		on_player_receive_fields = function(_, player, _, fields)
			local name = player:get_player_name()
			if fields.open_personal_log then
				minetest.show_formspec(name,"personal_log:root", make_personal_log_formspec(player))
				return true
			end
		end
	})
end

end

-----------------------------------------------------------------------------------------------------
-- Craftable item

if minetest.settings:get_bool("personal_log_craftable_item", false) then

minetest.register_craftitem("personal_log:book", {
	description = S("Personal Log"),
	inventory_image = "personal_log_open_book.png",
	groups = {book = 1, flammable = 3},
	on_use = function(itemstack, user, pointed_thing)
		local name = user:get_player_name()
		minetest.show_formspec(name,"personal_log:root", make_personal_log_formspec(user))
	end,
})

minetest.register_craft({
	output = "personal_log:book",
	recipe = {{"default:book", "default:book"}}
})

end