extends CharacterBody2D

@onready var world = get_tree().get_first_node_in_group("world")
@onready var sprite = get_node("Sprite2D")
@onready var collisionShape2D = get_node("CollisionShape2D")
@onready var playerMovementDelay = get_node("%PlayerMovementDelay")
var canMove = false
var endScreen = "res://screens/end_screen.tscn"
var onMovingPlatform = false
var canInteractWithChest = false
var canInteractWithGem = false

func _ready():
	playerMovementDelay.start(Global.PLAYER_START_OF_GAME_MOVEMENT_DELAY)
	self.position = gridToPixels(Global.PLAYER_STARTING_POSITION)
	
func _input(event):
	# Checking for interactions
	interaction(event)

	# Checking for movement
	if canMove:
		movement(event)

func _physics_process(delta):
	# Checking for drowning death
	call_deferred("checkForDrowning")

	# Checking for going off screen death
	if (self.global_position.x > get_viewport_rect().size.x + Global.GRID_SIZE / 2) || (self.global_position.x < -1 * Global.GRID_SIZE / 2):
		death()

func checkForDrowning():
	# Check for player drowning
	if overWater() and !onMovingPlatform:
		death()

func interaction(event):
	if event.is_action_released("interact"):
		# Chest
		if canInteractWithChest:
			# If we have a gem, deposit it
			if world.gemIcon.visible:
				world.gemsCollected += 1
				world.gemIcon.visible = false
				world.updateGUI()
				world.spawnGem()
		# Gem
		if canInteractWithGem:
			# Collect the gem
			canInteractWithGem = false
			world.gemIcon.visible = true
			get_tree().get_first_node_in_group("gem").queue_free()

func movement(event):
	
	# Calculating the prospective position
	var proPos = Vector2(-1,-1)
	if event.is_action_released("right"):
		# TOOD: Fix if you want - Can't move laterally when on a moving platform
		if onMovingPlatform:
			return
		proPos = getClosestCell(self.global_position + Vector2(Global.GRID_SIZE,0))
		sprite.look_at(self.global_position + Vector2(0,1))
		collisionShape2D.look_at(self.global_position + Vector2(0,1))
	elif event.is_action_pressed("left"):
		# TODO: Fix if you want - It's set so you can't move laterally when on a moving platform
		if onMovingPlatform:
			return
		proPos = getClosestCell(self.global_position + Vector2(-1 * Global.GRID_SIZE,0))
		sprite.look_at(self.global_position + Vector2(0,-1))
		collisionShape2D.look_at(self.global_position + Vector2(0,-1))
	elif event.is_action_pressed("up"):
		proPos = getClosestCell(self.global_position + Vector2(0,-1 * Global.GRID_SIZE))
		sprite.look_at(self.global_position + Vector2(1,0))
		collisionShape2D.look_at(self.global_position + Vector2(1,0))
	elif event.is_action_pressed("down"):
		proPos = getClosestCell(self.global_position + Vector2(0, Global.GRID_SIZE))
		sprite.look_at(self.global_position + Vector2(-1,0))
		collisionShape2D.look_at(self.global_position + Vector2(-1,0))
	
	# If no directional buttons were hit, don't move
	if proPos == Vector2(-1, -1):
		return

	# If the prospective position is out of bounds, don't move
	if proPos.x > 23 || proPos.x < 0 || proPos.y > 42 || proPos.y < 0:
		return

	# Seeing if there would be any collisions at the prospective position
	var query = PhysicsPointQueryParameters2D.new()
	query.collide_with_areas = true
	query.position = gridToPixels(proPos)
	var results = get_world_2d().direct_space_state.intersect_point(query)

	# Getting any collisions in the group "movingPlatform"
	var movingPlatforms = []
	var areaType = ""
	for result in results:
		var collider = result["collider"]
		# Checking if its the left or right area of the moving platform
		if collider.is_in_group("leftArea"):
			areaType = "left"
		elif collider.is_in_group("rightArea"):
			areaType = "right"
		# Returning so we are unable to move into the chest
		if collider.is_in_group("chest"):
			return
		if collider.get_parent().is_in_group("movingPlatform"):
			movingPlatforms.append(collider.get_parent())

	### Moving from ground to ground ###
	if !onMovingPlatform && len(movingPlatforms) == 0:
		onMovingPlatform = false
		self.position = gridToPixels(proPos)
	### Moving from ground to moving platform ###
	if !onMovingPlatform && len(movingPlatforms) != 0:
		onMovingPlatform = true
		var movingPlatform = movingPlatforms[0]
		# Reparenting to the moving platform
		if self.get_parent():
			self.get_parent().remove_child(self)
		movingPlatform.add_child(self)
		if areaType == "left":
			self.position = Vector2(-1 * Global.GRID_SIZE / 2, 0)
		else:
			self.position = Vector2(Global.GRID_SIZE / 2, 0)
	### Moving from moving platform to ground ###
	if onMovingPlatform && len(movingPlatforms) == 0:
		onMovingPlatform = false
		# Reparenting to the world scene
		if self.get_parent():
			self.get_parent().remove_child(self)
		world.add_child(self)
		var proPosClosestCell = getClosestCell(gridToPixels(proPos))
		self.position = gridToPixels(proPosClosestCell)
	### Moving from moving platform to moving platform ###
	if onMovingPlatform && len(movingPlatforms) != 0:
		onMovingPlatform = true
		var movingPlatform = movingPlatforms[0]
		# Reparenting to the new moving platform
		if self.get_parent():
			self.get_parent().remove_child(self)
		movingPlatform.add_child(self)
		if areaType == "left":
			self.position = Vector2(-1 * Global.GRID_SIZE / 2, 0)
		else:
			self.position = Vector2(Global.GRID_SIZE / 2, 0)

func death():
	# Setting end screen data then ending the game
	Global.timeAlive = world.timeFormatted
	Global.gemsCollected = world.gemsCollected
	var _level = get_tree().change_scene_to_file(endScreen)

func _on_player_movement_delay_timeout():
	canMove = true

# Takes a Vector2 with (x,y) grid coordinates and returns the equivalent Vector2 with (x,y) pixel coordinates
func gridToPixels(g):
	return Vector2(g[0] * Global.GRID_SIZE + Global.GRID_SIZE / 2, g[1] * Global.GRID_SIZE + Global.GRID_SIZE / 2)
	
# Takes a Vector2 with (x,y) pixel coordinates and returns the closest cell of format Vector2 (x,y)
func getClosestCell(p):
	return Vector2(round((p.x - Global.GRID_SIZE / 2) / Global.GRID_SIZE), round((p.y - Global.GRID_SIZE / 2) / Global.GRID_SIZE))

func overWater():
	var query = PhysicsPointQueryParameters2D.new()
	query.collide_with_areas = true
	query.position = self.global_position
	var results = get_world_2d().direct_space_state.intersect_point(query)
	
	# See if the position is over the water area
	for result in results:
		var collider = result["collider"]
		# Checking if its the left or right area of the moving platform
		if collider.is_in_group("waterArea"):
			return true

	return false

func _on_interaction_area_body_entered(body):
	if (body.is_in_group("gem")):
		canInteractWithGem = true
	if (body.is_in_group("chest")):
		canInteractWithChest = true

func _on_interaction_area_body_exited(body):
	if (body.is_in_group("gem")):
		canInteractWithGem = false
	if (body.is_in_group("chest")):
		canInteractWithChest = false
