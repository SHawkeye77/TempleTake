extends Node2D

@onready var turtlesScene = preload("res://npcs/turtles.tscn")
@onready var spawnTimer = get_node("Timer")
@export var rowsFromBottom = -1  # Number of rows up from the bottom
@export var turtlesSpeed = 100
var rng = RandomNumberGenerator.new()

func _ready():
	# Starting the timer
	var randomWaitTime = rng.randf_range(Global.TURTLES_SPAWN_DELAY_LOWER, Global.TURTLES_SPAWN_DELAY_UPPER)
	spawnTimer.start(randomWaitTime)

func _on_timer_timeout():
	# Spawning an alligator
	var turtles = turtlesScene.instantiate()
	var turtlesXPos = -1.0 * Global.GRID_SIZE
	var turtlesYPos = get_viewport_rect().size.y - (rowsFromBottom - 0.5) * Global.GRID_SIZE
	turtles.position = Vector2(turtlesXPos, turtlesYPos)
	turtles.turtlesSpeed = turtlesSpeed
	add_child(turtles)

	# Restarting the timer
	var randomWaitTime = rng.randf_range(Global.TURTLES_SPAWN_DELAY_LOWER, Global.TURTLES_SPAWN_DELAY_UPPER)
	spawnTimer.start(randomWaitTime)
