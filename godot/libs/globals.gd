extends Node

signal update_journal(message: String)
signal initiate_chat(speaker : String, message: String)
signal continue_chat(speaker : String, message: String)
signal abort_chat()

func _ready():
	connect("update_journal", _debug_signal)
	
func _debug_signal(payload):
	print_debug(payload)

func chat(speaker : String, message : String):
	Globals.emit_signal("initiate_chat", speaker, message)

func add_to_chat(speaker : String, message : String):
	Globals.emit_signal("continue_chat", speaker, message)

func end_chat():
	Globals.emit_signal("abort_chat")
