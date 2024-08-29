# Title

In the Forest: A Platformer Game

## Video demo

url

### Description

"In the Forest" is a classic platformer experience where you guide your character through various levels, collecting coins and avoiding obstacles. Traps and monsters lurk throughout the environment, requiring careful navigation and quick reflexes. Additionally, strategically placed crates can be pushed around to help you reach higher platforms. Subtle hints are scattered throughout the game through quotes.

Features:

Enemies exhibit two distinct movement patterns: walking and running, adding a layer of challenge.
The player character has three unique animations: idle, running, and jumping. The animation utilizes 27 individual images for a smooth and visually appealing effect.
Immerse yourself in a captivating background music track and experience the thrill of sound effects triggered by coin collection, enemy encounters, and player actions like jumping, taking damage and when the player dies.
Controls:

Navigate your character left and right using either the arrow keys or "A" and "D" keys.
Leap across platforms with the space bar, "W" key, or the up arrow key. You also possess the ability to double jump for extra height!
Feeling stuck? Simply press "R" to reset your position back to the beginning of the current level.
Project Breakdown

The project consists of several key folders and files, each playing a vital role in the game's functionality:

Assets: This folder houses all the visual and audio resources used within the game, including character sprites and tilesets.
Map: This folder contains the level layouts designed using Tiled software and saved as Lua files.
SFX: This dedicated folder stores the background music that loops throughout the game, as well as various sound effects for specific actions like coin collection, damage, death, and jumping.
STI: This folder holds a pre-built plugin called "Simple-Tiled-Implementation" (created by karai17). This plugin serves as a bridge between the Tiled map editor and the LOVE framework, facilitating the loading and rendering of map data within the game.
run.bat: This simple batch file executes the game after LOVE2D is installed in the specified directory (C:\Program Files\LOVE\lovec by default).
conf.lua: This file contains essential configuration settings for the game.
main.lua: This is the core script responsible for running the game. It manages the three key functions: drawing game elements, loading resources, and updating the game state. Additionally, it handles player jump and reset functionalities, object interactions, and key presses.
Camera.lua: This script controls the camera movement within the game, ensuring it remains focused on the player character.
(Enemy/Spike/Crate).lua Files: Each of these files defines the behavior and functionalities of the respective game object. The scripts manage object creation, physics simulation, drawing visuals, updating object states, and collision detection. The enemy script includes additional functionalities for changing directions, entering an enraged state, and applying damage to the player.
Player.lua: This script manages the player character's behavior, including loading character assets, animation functions, and interaction with objects within the game world. It shares some functionalities with the enemy script, like loading assets and animation loops.
gui.lua: This script is responsible for creating the game's user interface. It displays the player's collected coins, health points, and death count.
map.lua: This script handles level transitions. It loads the next level upon reaching the end of the current one, maintains background music loop, and manages level initialization and cleanup processes. It also includes functions for spawning objects based on data from the Tiled map and restarting the level loop after reaching the end of all levels.
Other Files: The project includes additional Lua files with specific functions and variables that govern various aspects of the game world, such as gravity, friction, and other gameplay mechanics.
Design Decisions

This platformer was designed to prioritize simplicity and ease of play. The intuitive control scheme and familiar gameplay mechanics make it accessible to players of all experience levels. The inclusion of subtle hints within the environment adds a layer of discovery and encourages exploration. The enemy behavior with two movement patterns introduces a slight challenge, keeping players engaged without becoming overly frustrating.
fun fact the princess at the end has red eyes because she is a vampire this could be the twist for part 2 if i wanted to make it
