local old_entities = {
"mobs_mc:skeleton",
"mobs_mc:wolf",
"mobs_mc:spider",
"mobs_mc:rabbit",
"mobs_mc:polar_bear",
"mobs_mc:squid",
"mobs_mc:guardian",
"mobs_mc:creeper",
"mobs_mc:slime_ball",
"mobs_mc:guardian_elder",
"mobs_mc:horse",
"mobs_mc:donkey",
"mobs_mc:zombie",
"mobs_mc:pig",
"mobs_mc:enderman",
"mobs_mc:bat",
"mobs_mc:baby_zombie",
"mobs_mc:ocelot",
"mobs_mc:slime_tiny",
"mobs_mc:slime_big",
"mobs_mc:slime_small",
"mobs_mc:cow",
"mobs_mc:sheep",
"mobs_mc:chicken"
}

for _,entity_name in ipairs(old_entities) do
    minetest.register_entity(":"..entity_name, {
        on_activate = function(self, staticdata)
            self.object:remove()
        end,
    })
end
