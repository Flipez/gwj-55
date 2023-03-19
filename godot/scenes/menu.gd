extends Control

@onready var help_screen = $HelpScreen
@onready var action = $Action
@onready var game_over = $GameOver
@onready var game_over_score = $GameOver/Box/Lines/Score

func _ready():
	game_over.hide()
	Globals.connect("game_over", _game_over)

#func _on_help_pressed():
#	help_screen.show()

#func _unhandled_input(_event):
	# TODO, fix "H"-bug. Right now when you press H in the start-menu you "skip" the new game part
	# and just close the entire screen
	#help_screen.hide()

func _on_new_game_pressed():
	action.hide()
	help_screen.show()
	
	$Background.hide()
	action.hide()
	$Title.hide()
	$Footer.hide()
	
	
	Globals.new_game.emit()

func _game_over(score : int):
	help_screen.hide()
	
	var perc = float(score) / Globals.max_milestones * 100
	game_over_score.text = ("You have found %d of %d clues (%.1f%%)" % [score, Globals.max_milestones, perc])
	game_over.show()
	
	$Background.show()
	$Title.show()
	$Footer.show()
	
	show()

func toggle_help():
	help_screen.visible = !help_screen.visible
