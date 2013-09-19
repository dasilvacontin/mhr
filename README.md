#MinecraftHarcoreReset.sh

Bash script that handles the best kind of Minecraft game difficulty: Hardcore.

The script's goal is to create an auto-resetting server based on the alive/dead players factor, perfect for playing Hardcore with friends!


#### The finished script should act the following way:

- Detect how many players are 'dead'. I do so by checking the banned players list.
- Detect how many players are 'alive' in the server. An 'alive' player is one that has (at least) entered the server in the last X hours (eg 24h).
- Ban players who have not been active in the last X hours. (The player will then be 'dead' instead of 'alive')
- Reset server based on the p_alive/(p_alive+p_dead) factor. (I basically delete the world folder and the banned_players file, and restart the server to generate them again)

#### What the script does right now:
- It detects how many players are 'dead'. Currently, those who are in the banned list.
- Every other player who is not banned is 'alive'. Even if they haven't entered the server during weeks.
- It resets the server when all the players are dead.
