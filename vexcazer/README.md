# vexcazer

License: code: LGPL-2.1, media: CC BY-SA-4.0  
Version: 10 
Created by: AiTechEye  

All info you need will be fund when you using the tools.  
type /vexcazer in game to see advanced info & version  

when you using a unused vexcazer:default, and have privs like vexcazer and vexcazer_ad, you will be given mod/admin stuff (if its not in your inventory and if auto_ad_mod is on)  

vexcazer:admin vex_ad  
vexcazer:mod vex_mod  
vexcazer:default vex_def  
vexcazer:controler vex_con  
vexcazer_adpick:pick vex_adpick  
vexcazer_telepad:pad  


The modes  
Undo		undo last change
PlaceDig xz:	place/dig xz  
Replace xz:	like PlaceDig, but relacing (2 modes)  
Autoswith:	using blocks from more slots on hotbar at same time.  
Travel1/2:	set position1/2 like a /sethome1/2 (will not works if the postion are protected)  
Teleport:		yourself or an object  
MassivePlaceDig:	place or dig N*N*N  
Gravity control:	(same code from the gravitygun mod)  
Flashlight:	(works in water+turns of in daylight)  
Copy:		(copy basic structures)  
Con:		Dig/Replace blocks that are connected to each other  
SelectiveRadio:	dig/place selected block in radio  
Regen:		regenerate area (same as /deleteblocks)  


vexcazer_adpick:	the admin pickaxe [/giveme vex_adpick] (will be given to moderators / admins)  
vexcazer_auto_ad_mod:	enables benefits with give/creative + autoget ad/mod vex when using an unused common-vexcazer [/giveme vex_ad, /giveme vex_mod]  
vexcazer_copy:		copy mode  
vexcazer_flashlight:	flashlight mode  
vexcazer_gravity:	gravitycontrol mode  
vexcazer_massive:	MassivePlaceDig  
vexcazer_powergen:	powergenerator / charger  
vexcazer_teleport:	teleport mode  
vexcazer_travel:	travle modes  
vexcazer_radio		radio/selective radio  
vexcazer_regen		Regen  (danger)
vexcazer_con:		connected blocks  

======For moders:====== (all registry settings and functions can be nil)  
How do i add modes?  
make a new mod/folder, with the depends.txt/vexcazer and init.lua then use this functions  


vexcazer.registry_mode({  
	name="Mode name",  
	info="Mode info",  
	info_mod="",			--show info for:__  
	info_admin="",  
	info_default="",  
	wear_on_use=1,			--takes power to use (default power amount = 1000)  
	wear_on_place=2  
	hide_mode_mod=false,		-- hide mode for:__  
	hide_mode_admin=false,  
	hide_mode_default=true,  
	disallow_damage_on_use=false	-- disable hurt-on-hit object and place when using this mode  
	on_place=function(itemstack, user, pointed_thing,input) end,  
	on_use=function(itemstack, user, pointed_thing,input) end,  
})

input={			the input variable  
	mode_name	name of the mode  
	itemstack  
	default=true	the default tool  
	mod=false	moderator like default but 50% default & 50% admin  
	admin=false	admin can destroy everything & no drops  
	mode=1		the mode  
	max_amount	amount of the tool  
	user		the user  
	user_name	user:get_player_name()  
	creative=true	have creative or give, or creative mode
	on_use=true  
	on_place=false  
	index		user:get_wield_index()  
	lazer		vexcazer:lazer1  
}

vexcazer.place({pos=pos,node={name=name}},input)-- returns true if successful or false  
vexcazer.dig(pos,input,nolazer)-- returns true if successful or false  
vexcazer.replace({pos=pos, stack=stack,replace=replace,invert=invert},input)-- returns true if successful or false, (invert: dig   evyerthing except the stack/name, can be nil)  
vexcazer.lazer_damage(pos,input,size)-- makes damage in a area, default is 1, size can be nil  
vexcazer.round(number)-- round  
vexcazer.save(input,string,value,global) -- saves value in the tool (will use modename.string) (global is used outside the functions / itemstack [global=true])  
vexcazer.load(input,string) -- load saved string in the tool (will use modename.string)  
