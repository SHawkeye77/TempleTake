extends CharacterBody2D

var arrowSpeed = -1

func _ready():
	velocity = Vector2(-1 * arrowSpeed, 0)

func _physics_process(_delta):
	move_and_slide()
	
	# If the arrow is off the screen, destroy it
	if self.position.x < -1 * Global.GRID_SIZE:
		self.queue_free()

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		body.death()
