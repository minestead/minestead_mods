socialemote = {}

function socialemote.show_emote(player, coordx, coordy)
  local object = minetest.add_entity(player:get_pos(), "socialemote:bubble")
  object:set_attach(player, "Head", {x=-3.0, y=7.0, z=0.0}, {x=0, y=0, z=0})
  object:set_sprite({x=coordx, y=coordy}, 3, 0.3, false)
  minetest.after(5.0, function()
    object:remove()
  end)
end

minetest.register_entity("socialemote:bubble", {          
	visual = "sprite",
	textures = {"socialemote_all_animated.png"},
  spritediv = {x = 6, y = 12},
	visual_size={x=0.5, y=0.5, z=0.5},
})

minetest.register_chatcommand("love", {
	description = "Shows a beating heart for 5 seconds",
	func = function(name, param)
    socialemote.show_emote(minetest.get_player_by_name(name), 3, 0)
  end })
  
minetest.register_chatcommand("embarrassed", {
	description = "Shows a sweat drop in a bubble",
	func = function(name, param)
    socialemote.show_emote(minetest.get_player_by_name(name), 1, 6)
  end })

minetest.register_chatcommand("exclamation", {
	description = "Shows an excalmation mark animation in a bubble",
	func = function(name, param)
    socialemote.show_emote(minetest.get_player_by_name(name), 4, 0)
  end })

minetest.register_chatcommand("question", {
	description = "Shows a question mark animation in a bubble",
	func = function(name, param)
    socialemote.show_emote(minetest.get_player_by_name(name), 4, 3)
  end })

  
minetest.register_chatcommand("good", {
	description = "Shows a thumbs up animation in a bubble",
	func = function(name, param)
    socialemote.show_emote(minetest.get_player_by_name(name), 1, 0)
  end })

minetest.register_chatcommand("bad", {
	description = "Shows a thumbs down animation in a bubble",
	func = function(name, param)
    socialemote.show_emote(minetest.get_player_by_name(name), 1, 3)
  end })

minetest.register_chatcommand("idea", {
	description = "Shows a lightbulb animation in a bubble",
	func = function(name, param)
    socialemote.show_emote(minetest.get_player_by_name(name), 1, 9)
  end })
  
minetest.register_chatcommand("sleepy", {
	description = "Shows a sleepy animation in a bubble",
	func = function(name, param)
    socialemote.show_emote(minetest.get_player_by_name(name), 2, 6)
  end })

minetest.register_chatcommand("sad", {
	description = "Shows a black thoughts animation in a bubble",
	func = function(name, param)
    socialemote.show_emote(minetest.get_player_by_name(name), 0, 9)
  end })
