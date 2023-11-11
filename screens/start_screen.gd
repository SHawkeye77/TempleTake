extends Control

var level = "res://screens/world.tscn"

func _on_play_button_pressed():
	var _level = get_tree().change_scene_to_file(level)
