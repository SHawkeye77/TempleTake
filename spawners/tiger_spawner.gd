extends Node2D

@onready var tigerScene = preload("res://npcs/tiger.tscn")
@onready var spawnTimer = get_node("Timer")
@export var rowsFromBottom = -1  # Number of rows up from the bottom
@export var tigerSpeed = 100
var rng = RandomNumberGenerator.new()

func _ready():
	# Starting the timer
	var randomWaitTime = rng.randf_range(Global.TIGER_SPAWN_DELAY_LOWER, Global.TIGER_SPAWN_DELAY_UPPER)
	spawnTimer.start(randomWaitTime)

func _on_timer_timeout():
	# Spawning a tiger
	var tiger = tigerScene.instantiate()
	var tigerXPos = -1.0 * Global.GRID_SIZE
	var tigerYPos = get_viewport_rect().size.y - (rowsFromBottom - 0.5) * Global.GRID_SIZE
	tiger.position = Vector2(tigerXPos, tigerYPos)
	tiger.tigerSpeed = tigerSpeed
	add_child(tiger)
	# Restarting the timer
	var randomWaitTime = rng.randf_range(Global.TIGER_SPAWN_DELAY_LOWER, Global.TIGER_SPAWN_DELAY_UPPER)
	spawnTimer.start(randomWaitTime)
