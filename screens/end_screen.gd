extends Control

@onready var timeLabel = get_node("%TimeLabel")
@onready var scoreLabel = get_node("%ScoreLabel")
var mainMenu = "res://screens/start_screen.tscn"

func _ready():
	timeLabel.text = "Time alive: " + Global.timeAlive
	scoreLabel.text = str(Global.gemsCollected) + " gems collected"
	

func _on_main_menu_button_pressed():
	var _level = get_tree().change_scene_to_file(mainMenu)
