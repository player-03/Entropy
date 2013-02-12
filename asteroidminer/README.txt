Asteroid Miner

by
Thomas Anesta, programming
Laquanna Cook, graphics
Joseph Cloutier, programming
Phelan Lemieux, programming

copyright 2013 to
Thomas Anesta
Laquana Cook
Joseph Cloutier
Phelan Lemieux

HOW TO PLAY: 

Move Mouse: highlight different options
Left Click: Select
Right Click: Deselect (activate valve or launchpad when positioned over it)
Q: switch view to previous robot
W: switch view to next robot

select spdr robot-
-move options
--hover your mouse over an adjacent hexagon then left click to move the spdr robot into that hexagon if the robot can move or dig there (moving returns to move options)
-select spdr robot
--build options
---option 1: build valve menu
----hover the mouse over either the space that the spdr robot is on or 

HOW TO BUILD A LEVEL: 

the level format is as follows.  each level is made up of a header and a footer.  The header describes the size of the map, how many asteroids there are and their positions, how many robots there are and their positions, how many launchpads there are and their positions, the player's goals and starting resources.  the footer describes what is in each hexagon.  in the default format, hexagons are read first left to right and then top to bottom, and staggered so every second hexagon that does not transfer to a newline is positioned to the right and below the hexagon preceding it (the hexagon following is positioned to the right and above this lower hexagon).

the general syntax of delimiting between items in the text file is :-: denotes separation at the top level, :*: denotes separation at the next level (preceded by a statement stating what objects are being described), :^: is the third level of nesting, and . denotes separation of parts of the same object.  &&& denotes the separation between header and footer information

DISCLAIMER: at this time we only have support for single robots and single launchpads and single asteroids

the codes for hexagons is as follows

space:s
asteroid undug:a.1
asteroid dug:a.2
gas spawn hexagon:g.(number of gas particles to spawn)
valve (open)=v.1
valve (closed)=v.2
turbine (default orientation up)=t.1
turbine (default orientation down)=t.2
turbine (default orientation upleft)=t.3
turbine (default orientation downleft)=t.4
turbine (default orientation upright)=t.5
turbine (default origentation downright)=t.6

the following is an example of a level
the items within double quotations are not to be in double quotations when writing a level, but they stand for what should go in their place.

HEADER:-:SIZE:*:"mapwidthinhexagons"."mapheightinhexagons":-:ROBOT:*:"robot1xlocation"."robot1ylocation":*:"robot2xlocation"."robot2ylocation":-:ASTEROID:*:"asteroid1xcenter"."asteroid1ycenter":*:"asteroid2xcenter"."asteroid2ycenter":-:MAX:*:GAS:^:"maximumgasasinteger":*:ENERGY:^:"maximumenergyasinteger:-:GOAL:*:GAS:^:"thegasgoalasinteger":*:ENERGY:^:"theenergygoalasinteger:-:STARTR:*:GAS:^:"startinggasasinteger":*:ENERGY:^:"startingenergyasinteger":-:&&&FOOTER:-:DATA:*:"row1column1tiletypeasinteger":*:"row1column2tiletypeasinteger":*:"row1column3tiletypeasinteger":*:"etc":*:"row2column1tiletypeasinteger":*:"row2column2tyletypeasinteger":*:"etc":-:END


