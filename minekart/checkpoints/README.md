Minetest 5.2 mod: Checkpoints
========================================

This mod adds the checkpoints feature to the minetest, to work with minekart mod. In fact it could operate with any vehicle, just that in its register_entity it has the following extra fields, saving it on it's get_staticdata. If not save it, the vehicle will forget his status when the server restart:

    _last_checkpoint = "",
    _total_laps = -1,
    _race_id = "",


How to use?
You have 2 icons with flags, one white, the other a green. And a fuel pistol plus a black and white flag item. The white flag is a start checkpoint. The green is a race checkpoint. If ou know where you start the grid line, put the start icon 10 blocks ahead (it has 10 blocks radius, you can punch it to see). When you click with right button and it show a dialog, you can set the previous checkpoint (I suggest you put "last" here, see ahead) and a number of laps (default 10). When you click on Update (yes, click on Update or it will not save), it changes the start parameters and the race_id (later I explain it).
Now you can place the green flags in strategic places of your track to prevent cheaters getting shortcuts. With the right click, it shows you a dialog where you name the checkpoint and tell's it the name of the previous one. If this is the first, you can name it as "check_01" or whatever and the previous as "start", so you inform it and click on Update. The next checkpoint you name it "check_02" or as you desire and tell it the previous was "check_01". Do it until you come to the last. I suggest you to name the last checkpoint simply as "last", as you informed the "start" checkpoint. Now your circuit is ready, you can place a car and run it. The first to complete all the laps configured at start checkpoint, his name will be saved in first place of a ten fields list. To reset the race and the list you use the status_restarter flag, the checker flag icon. Punch it against the start icon (white flags), the race_id will change and winners list cleaned. You can place the basic_machines keypad to reset the start checkpoint, just config the target node at your start icon location and set the text to send as "start".
If a single kart need to be reseted, punch it with the status_restarter (only works with kart, unless you copy the activation routine to your vehicle code)
When a car passes through the start checkpoint zone, it will check the race_id of that car. If it's different, the car status is reseted and automatically it's on a new race. In case it's the same race_id, the lap count is incremented until the race ending.
And the fuel? Well, your kart starts with no fuel. If you are not in a race or your car was reseted by the black white flag, you can put biofuel on it. You need to attach himself to the car with the right button and punch the car with the biofuel gallon. Ok. But when you are in a race, you can only refuel at a refuel zone, marked by the fuel pistol icon. This zones have a radius of 5 blocks. To refuel you need stop, turn the engine off and punch the gallon against the kart. So you turn engine running again and go to the victory... or not!

-- advanced:
-the start checkpoint can be configured to show it's text on another node, like a remote sign, just inform the relative coordinate in target msg fields and click "Set Message Target". So any update on infotext of the node will be replicated at the informed node position.
-the start display can be placed the same way.
-if using basic machines, you can set a keypad to start a race, just configuring to send the string "start" to start node location.

-----------------------
It uses some pieces of code from Protector Redo 3.0 (by TenPlus1)

License of source code:
MIT (see file LICENSE) 

License of media (textures and sounds):
---------------------------------------
sounds from package NES 8-bit sound effects by shiru8bit CC-BY 3.0 and CC0 at opengameart.org

Icons by APercy. See License file

