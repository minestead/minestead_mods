# Better Fences

A Minetest mod which solves the fence connection problem.

Recently I was building a house and was quite frustrated that my fence nodes wouldn't connect to the mossy cobblestone:

![image](https://i.imgur.com/2oCkkbq.jpg)

So, I submitted [a PR](https://github.com/minetest/minetest_game/issues/2205) to make fences connect to all nodes, and it was promptly closed because running fences along a cobble wall would look terrible. This made total sense, but it was still frustrating because the only 2 options (fences that connect to all nodes and fences that connect to only fences) both look terrible in some situations.

## My Solution

Better fences overrides default fences and walls and replaces them with 2 fence types, one which connects to all nodes and one which only connects to other fences and walls.

Whenever you place or dig a fence, this mod will determine if the fence you just placed will connect to 2 or more adjacent fences or walls, if it will it places the fence which only connects to fences, otherwise it places the fence which connects to all nodes. Every dig and place will result in the surrounding 4 fences (if they exist) being checked and updated if necessary as well.

This behaviour results in only the fences at the end of a line of fences connecting to all nodes:

![image](https://github.com/ChimneySwift/better_fences/blob/master/screenshot.png?raw=true)

So you get the best of both worlds, ability to connect to nodes like stone, and also to not have a line of fences running along a wall look like trash:

![image](https://github.com/ChimneySwift/better_fences/blob/master/screenshot_2.png?raw=true)

**Code License:** LGPL 2.1+

**Dependencies:** default

**Optional Dependencies:** walls