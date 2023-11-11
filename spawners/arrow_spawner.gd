extends Node2D

@onready var arrowScene = preload("res://npcs/arrow.tscn")
@onready var spawnTimer = get_node("Timer")
@export var rowsFromBottom = -1  # Number of rows up from the bottom
@export var arrowSpeed = 100
var rng = RandomNumberGenerator.new()

func _ready():
	# Starting the timer
	var randomWaitTime = rng.randf_range(Global.ARROW_SPAWN_DELAY_LOWER, Global.ARROW_SPAWN_DELAY_UPPER)
	spawnTimer.start(randomWaitTime)

func _on_timer_timeout():
	# Spawning an arrow
	var arrow = arrowScene.instantiate()
	var arrowXPos = get_viewport_rect().size.x + Global.GRID_SIZE
	var arrowYPos = get_viewport_rect().size.y - (rowsFromBottom - 0.5) * Global.GRID_SIZE
	arrow.position = Vector2(arrowXPos, arrowYPos)
	arrow.arrowSpeed = arrowSpeed
	add_child(arrow)
	# Restarting the timer
	var randomWaitTime = rng.randf_range(Global.ARROW_SPAWN_DELAY_LOWER, Global.ARROW_SPAWN_DELAY_UPPER)
	spawnTimer.start(randomWaitTime)
