	  ____ _   _      _     _                         ____                      
	 / ___| | | |_ __(_)___| |_ _ __ ___   __ _ ___  |  _ \  ___  ___ ___  _ __ 
	| |   | |_| | '__| / __| __| '_ ` _ \ / _` / __| | | | |/ _ \/ __/ _ \| '__|
	| |___|  _  | |  | \__ \ |_| | | | | | (_| \__ \ | |_| |  __/ (_| (_) | |   
	 \____|_| |_|_|  |_|___/\__|_| |_| |_|\__,_|___/ |____/ \___|\___\___/|_|     ~By GreenDimond
	 
'Tis the season!  
This mod adds some Christmas decorations :D  

Depends on 3d_armor, homedecor, farming_redo, stairs_redo, mobs_redo, mobs_animal,  
dye, wool, bucket, vessels, xpanes, farming, and default.

This mod contains the following:  
* Stocking*  
* Christmas Lights (and craftitems)  
	* White  
	* Multicolor  
	* Icicle (white)  
	* Bulb (multicolor)  
	* Pane version of above  
* Garland  
* Garland with lights  
* Gingerbread Cookies (and craftitems)  
* Plate of cookies (decorational)  
* Glass of milk (decorational)  
* Candycane (edible)  
* Santa Claus mob (non-moving)  
* Reindeer mob (non-moving, has animations) 
* Santa hat (wearable)   
* Candycane (placeable - noncraftable)  
* Frosting nodes (noncraftable)  
* Candycane nodes (noncraftable)  
* Mistletoe  

*Stockings are pretty cool. They will automatically fill once Christmas arrives,  
or at least that is the idea. Extensive testing has supposedly confirmed this,  
but we'll see what happens :P The stocking by default is set to fill with  
200 gold ingots, 20 candycanes, and a full set of mese tools. These can  
be edited on lines 42-53 of stocking.lua. Each player is also only allowed  
to place one stocking, and there is bunches of stuff in place to make sure  
other players can't steal from stockings and can't dig other people's, etc...  

This is the part where I have to type out all the craft recipes.

* Stocking:  
(r = red wool, w = white wool)  
```
+-+-+-+
|w|w| |
+-+-+-+
|r|r| |
+-+-+-+
|r|r|r|
+-+-+-+
```
(reverse works too)  

* Christmas lights:  
Forget it, just look on these lines in the init.lua:  
L 123-161  
L 290-324  

* Garland:  
(p = pine needles)  
```
+-+-+-+
|p|p|p|
+-+-+-+
```
(combine with 3 white LED's to make garland with lights)  

* Ginger:  
(p = plastic sheeting, b = brown dye, o = orange dye)  
```
+-+-+-+
|p|o|p|
+-+-+-+
|p|b|p|
+-+-+-+
```
(orange and brown dye can switch places)  

* Cookiecutter:  
(s = steel ingot)  
```
+-+-+-+
| |s| |
+-+-+-+
|s|s|s|
+-+-+-+
|s| |s|
+-+-+-+
```

* Gingerbread dough:  
Combine ginger, bucket of water, flour, and sugar.  

* Raw Gingerbread Man:  
Combine cookiecutter and gingerbread dough.  
Cook to obtain gingerbread man.  
Combine gingerbread man with cutlery set to get a plate of cookies.  

* Glass of milk:  
Combine bucket of milk and a drinking glass.  

* Candycane:  
Combine candycane base with red and white dye.  

* Candycane base:  
(s = sugar)  
```
+-+-+-+
| |s| |
+-+-+-+
|s| |s|
+-+-+-+
|s| | |
+-+-+-+
```
(reverse works too)  

* Santa hat:  
(w = white wool, r = red wool)  
```
+-+-+-+
| |w| |
+-+-+-+
| |r| |
+-+-+-+
|r|r|r|
+-+-+-+
```

* Mistletoe:  
Combine 2 normal leaves and red dye.
