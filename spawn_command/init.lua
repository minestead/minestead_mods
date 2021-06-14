
spawn_command = {}
spawn_command.pos = {x=0, y=3, z=0}
local cursed_world_exists = minetest.get_modpath("cursed_world")

if minetest.setting_get_pos("static_spawnpoint") then
    spawn_command.pos = minetest.setting_get_pos("static_spawnpoint")
end

function teleport_to_spawn(name)
    local player = minetest.get_player_by_name(name)
    if player == nil then
        -- just a check to prevent the server crashing
        return false
    end
    local pos = player:get_pos()
    if math.abs(spawn_command.pos.x-pos.x)<20 and math.abs(spawn_command.pos.z-pos.z)<20 then
        minetest.chat_send_player(name, "Already close to spawn!")
    elseif cursed_world_exists and _G['cursed_world'] ~= nil and    --check global table for cursed_world mod
        cursed_world.location_y and cursed_world.dimension_y and
        pos.y < (cursed_world.location_y + cursed_world.dimension_y) and    --if player is in cursed world, stay in cursed world
        pos.y > (cursed_world.location_y - cursed_world.dimension_y)
    then   --check global table for cursed_world mod
        --minetest.chat_send_player(name, "T"..(cursed_world.location_y + cursed_world.dimension_y).." "..(cursed_world.location_y - cursed_world.dimension_y))
        local spawn_pos = vector.round(spawn_command.pos);
        spawn_pos.y = spawn_pos.y + cursed_world.location_y;
        player:set_pos(spawn_pos)
        minetest.chat_send_player(name, "Teleported to spawn!")
    else
        player:set_pos(spawn_command.pos)
        minetest.chat_send_player(name, "Teleported to spawn!")
    end
end

minetest.register_chatcommand("spawn", {
    description = "Teleport you to spawn point.",
    func = teleport_to_spawn,
})
