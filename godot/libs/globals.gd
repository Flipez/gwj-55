extends Node

var dream_mode = false

var dream_on_sound = preload("res://sounds/dream_on.mp3")
var dream_off_sound = preload("res://sounds/dream_off.mp3")

var audio_player = AudioStreamPlayer.new()

signal update_journal(message: String)
signal initiate_chat(speaker : String, message: String)
signal continue_chat(speaker : String, message: String)
signal continue_chat_event(event : Callable)
signal abort_chat()
signal dream_mode_toggled(state : bool)
signal new_game()
signal game_over(score : int)
signal open_toilet_door()
const max_milestones = 19

func _ready():
	get_parent().add_child.call_deferred(audio_player)

func end_chat():
	emit_signal("abort_chat")

func toggle_dream():
	if dream_mode:
		dream_mode = false
		audio_player.stream = dream_off_sound
		audio_player.play()
	else:
		dream_mode = true
		audio_player.stream = dream_on_sound
		audio_player.play()
	emit_signal("dream_mode_toggled", dream_mode)
	InteractionHandler.emit_signal("interaction_stopped")
