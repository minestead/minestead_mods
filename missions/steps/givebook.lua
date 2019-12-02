


missions.register_step({

	type = "givebook",
	name = "Give a book",

	privs = {missions_book=true},

	create = function()
		return {title="", message=""}
	end,

	edit_formspec = function(ctx)
		local stepdata = ctx.step.data

		local formspec = "size[8,8;]" ..
			"label[0,0;Give a book]" ..
			"field[0,1;8,1;title;Title;" .. stepdata.title ..  "]" ..
			"textarea[0,2;8,4;message;Message;" .. stepdata.message ..  "]" ..
			"button[0,7;8,1;save;Save]"

		return formspec;
	end,

	update = function(ctx)
		local fields = ctx.fields
		local stepdata = ctx.step.data

		if fields.title then
			stepdata.title = fields.title
		end

		if fields.message then
			stepdata.message = fields.message
		end

		ctx.show_mission()
	end,

	on_step_enter = function(ctx)
		local player = ctx.player
		local stepdata = ctx.step.data

		local new_stack = ItemStack("default:book_written")

		local data = {}

		data.owner = "Mission"
		data.title = stepdata.title
		data.description = stepdata.title
		data.text = stepdata.message
		data.page = 1
		data.page_max = 1

		new_stack:get_meta():from_table({ fields = data })

		local player_inv = player:get_inventory()
		player_inv:add_item("main", new_stack)

		ctx.on_success()
	end

})

