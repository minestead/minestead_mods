Minetest mission mod (missions)
======

Minetest mod for in-game mission creation (for players and admins)
Adds a mission block to create missions and a mission-wand to mark positions and chests

* Github: [https://github.com/thomasrudin-mt/missions](https://github.com/thomasrudin-mt/missions)
* Forum Topic: [https://forum.minetest.net/viewtopic.php?f=9&t=20125](https://forum.minetest.net/viewtopic.php?f=9&t=20125)

Obligatory screenshot
![](screenshots/intro.png?raw=true)

Features:
* In-game mission builder
* Craftable mission-block and wand
* Create epic quests or mazes
* Missions can span multiple days, even weeks
* Running missions persist across login/logout and server-restart

Supported mission-steps:
* Build (place any nodes)
* Build specific nodes (e.g: Stone)
* Dig nodes (any)
* Dig specific nodes (e.g: Meseblock)
* Put items in Chest at position (e.g: 99xStone)
* Waypoint (hidden and visible in hud)
* Teleport player to position (requires the **missions_teleport** priv)
* Reward player with items from a chest
* Reward player with items (mission-build must have the **give** priv)
* Message (show a message with a title)
* Grant priviliege (requires the **priv** privilege)

Extended mission-steps (dependent on other mods):
* Spawn a mob at position (requires the **missions_mobs** priv)
* Check xp (if xp mod enabled)
* Give xp (if xp mod enabled and privs available)

# Install

* Unzip/Clone it to your worldmods folder

# Crafting

Mission-Block:
![](screenshots/craft_mission.png?raw=true)

Mission wand:
![](screenshots/craft_wand1.png?raw=true)

**Note:** Used (position and chest) wands can be mixed back to a plain wand again

# Manual

## Create missions (in-game)

Craft yourself a mission wand (missions:wand) and mark your waypoints and chests with it:
![](screenshots/screenshot_20180724_205841.png?raw=true)

Give them a name so you find them later in the inventory.
The wand converts either to a position wand or a chest wand, depending on what you are pointing it to.
* **Position wand**: Marks waypoints for a mission
* **Chest wand**: Marks chests for taking or putting inventory (default and morechests supported for now)

Properly named chest-wand:
![](screenshots/screenshot_20180724_205926.png?raw=true)


When you are finished marking the places and chests you want in your mission
you can craft a mission-block (missions:mission) and place it where you want the mission to start.
The Mission block can only be dug from the owner or an admin with protector_bypass privilege.

Rightclick on the mission to open the editor dialog:
![](screenshots/screenshot_20180724_205947.png?raw=true)

On the left you can add and order the mission steps.
On the right you can edit its name, description and the time allowed to finish it.

Now click on **add** to create your first mission step:
![](screenshots/screenshot_20180724_205958.png?raw=true)

Choose your first step in the mission:
* Could be a waypoint to which the player has to go
* Or a chest which has to be filled with a given amount and type of item
* Or a simple welcome message to brief the player

Example of a step in which the player has to place 99 stones in the chest
![](screenshots/screenshot_20180724_210022.png?raw=true)

This is just an example, the player could take out the items as soon as the step or the mission is finished.
In reality you would use a dropbox from the morechests mod or inject the items into some tubes with mesecons and pipeworks.

Example of a waypoint step:
![](screenshots/screenshot_20180724_210049.png?raw=true)

The visibility of the waypoint can be toggled if you want the player to search for it (after you gave him some hints of course)


Example of a Message step:
![](screenshots/screenshot_20180724_210108.png?raw=true)

The player has to click the message away in order to execute the next step

An example of a finished mission with waypoints and messages:
![](screenshots/screenshot_20180724_210112.png?raw=true)

now you can click on **Save and Validate** to check if the mission is valid:
* Enough items to give the player as reward
* Enough room in chests for the player to put in

An example of an invalid mission:
![](screenshots/screenshot_20180724_210145.png?raw=true)

The mission will be validated every time a player wants to start it.

Of course a reward upon finishing the mission would always be a good idea...
For this, create a **Reward from Chest** step and place the marked wand to the chest in the **target** field.
The chest has to contain the items in order to start the mission.

## Play missions

To play a mission do a rightclick on a mission-block or as the owner of it click on **User** in the edit dialog:
![](screenshots/screenshot_20180724_210206.png?raw=true)

After carefully reading the text (or not at all) you can click **Start** to accept the mission.
Only one mission can be active at the same time.

After the start the configured wapyoints will guide you through the mission (or not if so configured)
![](screenshots/screenshot_20180724_210221.png?raw=true)

For item collection a status-text on the upper right will tell you how much you have to collect:
![](screenshots/screenshot_20180724_210232.png?raw=true)


An example message from the mission-creator to the player:
![](screenshots/screenshot_20180724_210243.png?raw=true)

## Create more mission-steps (specs)

See the existing steps in the **steps** folder for some guidelines.

# Depends

* default
* [xp_redo](https://github.com/thomasrudin-mt/xp_redo)?
* [more_chests](https://github.com/minetest-mods/more_chests)?
* [mobs_redo](https://notabug.org/TenPlus1/mobs_redo)?
* [mobs_monster](https://notabug.org/TenPlus1/mobs_monster)?
* [mobs_horse](https://notabug.org/TenPlus1/mob_horse)?
* [mobs_animal](https://notabug.org/TenPlus1/mobs_animal)?
* [mobs_npc](https://notabug.org/TenPlus1/mobs_npc)?
* mobs_xenomorph?
* mobs_fish?
* mobs_crocs?
* mobs_jellyfish?
* mobs_sharks?
* mobs_turtles?
* mesecon?

# Pull requests / bugs

I'm happy for any bug reports or pull requests (code and textures)

