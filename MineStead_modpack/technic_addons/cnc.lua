if minetest.get_modpath("moreores") then

   technic_cnc.register_all("moreores:silver_block",
      {snappy = 1, bendy = 2, cracky = 1, melty = 2, level = 2, not_in_creative_inventory=1},
      {"moreores_silver_block.png"},
      "Silver"
   )
   technic_cnc.register_all("moreores:mithril_block",
      {snappy = 1, bendy = 2, cracky = 1, melty = 2, level = 2, not_in_creative_inventory=1},
      {"moreores_mithril_block.png"},
      "Mithril"
   )

end

-- technic

technic_cnc.register_all("technic:lead_block",
   {cracky=1, level=2, not_in_creative_inventory=1},
   {"technic_lead_block.png"},
   "Lead"
)
technic_cnc.register_all("technic:chromium_block",
   {cracky=1, level=2, not_in_creative_inventory=1},
   {"technic_chromium_block.png"},
   "Chromium"
)
technic_cnc.register_all("technic:stainless_steel_block",
   {cracky=1, level=2, not_in_creative_inventory=1},
   {"technic_stainless_steel_block.png"},
   "Stainless Steel"
)
technic_cnc.register_all("technic:carbon_steel_block",
   {cracky=1, level=2, not_in_creative_inventory=1},
   {"technic_carbon_steel_block.png"},
   "Carbon Steel"
)

-- defaults

technic_cnc.register_all("default:tinblock",
   {cracky = 1, level = 2, not_in_creative_inventory=1},
   {"default_tin_block.png"},
   "Tin"
)
technic_cnc.register_all("default:mese",
   {cracky = 1, level = 2, not_in_creative_inventory=1},
   {"default_mese_block.png"},
   "Mese"
)
technic_cnc.register_all("default:clay",
   {cracky = 1, level = 2, not_in_creative_inventory=1},
   {"default_clay.png"},
   "Clay"
)
technic_cnc.register_all("default:diamondblock",
   {cracky = 1, level = 2, not_in_creative_inventory=1},
   {"default_diamond_block.png"},
   "Diamond"
)

-- sandstones

technic_cnc.register_all("default:desert_cobble",
    {cracky=3, not_in_creative_inventory=1},
    {"default_desert_cobble.png"},
    "Desert Cobble"
)

technic_cnc.register_all("default:silver_sandstone",
    {crumbly=2, cracky=3, not_in_creative_inventory=1},
    {"default_silver_sandstone.png"},
    "Silver Sandstone"
)

technic_cnc.register_all("default:desert_sandstone",
    {crumbly=2, cracky=3, not_in_creative_inventory=1},
    {"default_desert_sandstone.png"},
    "Desert Sandstone"
)
