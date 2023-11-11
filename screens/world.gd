extends Node2D

@onready var gemScene = preload("res://items/gem.tscn")
@onready var player = get_tree().get_first_node_in_group("player")
@onready var timerLabel = get_node("%TimerLabel")
@onready var gemsCollectedLabel = get_node("%GemsCollectedLabel")
@onready var startingWordsLabel = get_node("%StartingWordsLabel")
@onready var startingWordsTimer = get_node("%StartingWordsTimer")
@onready var waterArea = get_node("%WaterArea")
@onready var gemIcon = get_node("%GemIcon")
var startingWordsIteration = 0
var time = 0  # Time in seconds
var timeFormatted = "00:00"
var gemsCollected = 0
var rng = RandomNumberGenerator.new()

func _ready():
	# Resetting global data
	Global.timeAlive = ""
	Global.gemsCollected = 0
	startingWordsLabel.text = "On your marks..."
	startingWordsTimer.start(Global.PLAYER_START_OF_GAME_MOVEMENT_DELAY / 3)
	startingWordsIteration += 1
	
	# Hiding the gem icon since you don't start with a gem
	gemIcon.visible = false
	
	# Spawning gem
	spawnGem()
	
	updateGUI()

func _on_clock_timer_timeout():
	# Updating the time
	time += 1
	var mins = int(time/60.0)
	var secs = time % 60
	# Ensuring there's always leading zeros
	if mins < 10:
		mins = str(0,mins)
	if secs < 10:
		secs = str(0,secs)
	timeFormatted = str(mins, ":", secs)
	updateGUI()

func _on_starting_words_timer_timeout():
	if startingWordsIteration == 1:
		startingWordsLabel.text = "Get set..."
		startingWordsTimer.start(Global.PLAYER_START_OF_GAME_MOVEMENT_DELAY / 3)
		startingWordsIteration += 1
	elif startingWordsIteration == 2:
		startingWordsLabel.text = "Go!"
		startingWordsTimer.start(Global.PLAYER_START_OF_GAME_MOVEMENT_DELAY / 3)
		startingWordsIteration += 1
	elif startingWordsIteration == 3:
		startingWordsLabel.text = ""

func spawnGem():
	var spotIndex = rng.randi_range(0,5)  # Inclusive
	var newGem = gemScene.instantiate()
	newGem.position.x = (2 * Global.GRID_SIZE) + (spotIndex * Global.GRID_SIZE * 4)
	newGem.position.y = 2.5 * Global.GRID_SIZE
	add_child(newGem)

func updateGUI():
	gemsCollectedLabel.text = "Gems Collected: " + str(gemsCollected)
	timerLabel.text = timeFormatted
