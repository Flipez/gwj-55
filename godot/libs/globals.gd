extends Node

signal update_journal(message: String)
signal initiate_chat(message: String)

func _ready():
	connect("update_journal", _debug_signal)
	
func _debug_signal(payload):
	print_debug(payload)
