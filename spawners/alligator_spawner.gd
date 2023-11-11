extends Node2D

@onready var alligatorScene = preload("res://npcs/alligator.tscn")
@onready var spawnTimer = get_node("Timer")
@export var rowsFromBottom = -1  # Number of rows up from the bottom
@export var alligatorSpeed = 100
var rng = RandomNumberGenerator.new()

func _ready():
	# Starting the timer
	var randomWaitTime = rng.randf_range(Global.ALLIGATOR_SPAWN_DELAY_LOWER, Global.ALLIGATOR_SPAWN_DELAY_UPPER)
	spawnTimer.start(randomWaitTime)

func _on_timer_timeout():
	# Spawning an alligator
	var alligator = alligatorScene.instantiate()
	var alligatorXPos = get_viewport_rect().size.x + Global.GRID_SIZE
	var alligatorYPos = get_viewport_rect().size.y - (rowsFromBottom - 0.5) * Global.GRID_SIZE
	alligator.position = Vector2(alligatorXPos, alligatorYPos)
	alligator.alligatorSpeed = alligatorSpeed
	add_child(alligator)

	# Restarting the timer
	var randomWaitTime = rng.randf_range(Global.ALLIGATOR_SPAWN_DELAY_LOWER, Global.ALLIGATOR_SPAWN_DELAY_UPPER)
	spawnTimer.start(randomWaitTime)
