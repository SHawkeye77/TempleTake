extends CharacterBody2D

var tigerSpeed = -1

func _ready():
	velocity = Vector2(tigerSpeed, 0)

func _physics_process(_delta):
	move_and_slide()
	
	# If the tiger is off the screen, destroy it
	if self.position.x > get_viewport_rect().size.x + Global.GRID_SIZE:
		self.queue_free()

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		body.death()
