Wine mod for Minetest

by TenPlus1

Depends: Farming Redo

This mod adds a barrel used to ferment grapes into glasses of wine, 9 of which can then be crafted into a bottle of wine.  It can also ferment honey into mead, barley into beer, wheat into weizen (wheat beer), corn into bourbon and apples into cider.

Change log:

- 0.1 - Initial release
- 0.2 - Added protection checks to barrel
- 0.3 - New barrel model from cottages mod (thanks Napiophelios), also wine glass can be placed
- 0.4 - Added ability to ferment barley from farming redo into beer and also honey from mobs redo into honey mead
- 0.5 - Added apple cider
- 0.6 - Added API so drinks can easily be added, also added wheat beer thanks to h-v-smacker and support for pipeworks/tubelib
- 0.7 - Blue Agave now appears in desert areas and spreads very slowly, can me fermented into tequila
- 0.8 - Barrel and Agave both use node timers now thanks to h-v-smacker, added sake
- 0.9 - Added Glass of Rum and Bottle of Rum thanks to acm :) Added {alcohol=1} groups
- 1.0 - Added glass and bottle or Bourbon made by fermenting corn
- 1.1 - Added glass and bottle of Vodka made by fermenting baked potato, Added MineClone2 support and spanish translation
- 1.2 - Added Unified Inventory support for barrel recipes (thanks to realmicu)
- 1.3 - Translations updated and French added thanks to TheDarkTiger
- 1.4 - Added bottle of beer and bottle of wheat beer (thanks Darkstalker for textures)
- 1.5 - Added bottle of sake (texture by Darkstalker), code tidy & tweaks, resized bottles and glasses, added some new lucky blocks, support for Thirst mod
- 1.6 - Added bottle of Mead and Cider (textures by Darkstalker), re-arranged 
code, tweaked lucky blocks, updated translations

Lucky Blocks: 14


Wine Mod API
------------

wine:add_item(list)

e.g.

wine:add_item({
	{"farming:barley", "wine:glass_beer"},
	{"default:apple", "wine:glass_cider"},
})
