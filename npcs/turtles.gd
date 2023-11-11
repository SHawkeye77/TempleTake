extends CharacterBody2D

@onready var world = get_tree().get_first_node_in_group("world")
var turtlesSpeed = -1

func _ready():
	velocity = Vector2(turtlesSpeed, 0)

func _physics_process(_delta):
	move_and_slide()
	# If the turtles are off the screen, destroy it
	if self.position.x < -1 * Global.GRID_SIZE:
		self.queue_free()
