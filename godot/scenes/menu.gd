extends Node

@onready var help_screen = $HelpScreen

func _on_help_pressed():
	help_screen.show()

func _unhandled_input(_event):
	help_screen.hide()

func _on_new_game_pressed():
	get_tree().change_scene_to_file("res://scenes/game.tscn")
