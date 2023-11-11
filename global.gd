extends Node

# Screen
var GRID_SIZE = 16  # Grid square size in pixels

# Player
var PLAYER_MOVEMENT_SPEED = 100
var PLAYER_START_OF_GAME_MOVEMENT_DELAY = 3
var PLAYER_STARTING_POSITION = Vector2(12, 42)
# Arrows
var ARROW_SPAWN_DELAY_LOWER = 1.0
var ARROW_SPAWN_DELAY_UPPER = 5.0

# Tigers
var TIGER_SPAWN_DELAY_LOWER = 1.0
var TIGER_SPAWN_DELAY_UPPER = 5.0

# Alligators
var ALLIGATOR_SPAWN_DELAY_LOWER = 1.0
var ALLIGATOR_SPAWN_DELAY_UPPER = 3.0

# Turtles
var TURTLES_SPAWN_DELAY_LOWER = 1.0
var TURTLES_SPAWN_DELAY_UPPER = 3.0

# End screen data
var timeAlive = ""
var gemsCollected = -1
