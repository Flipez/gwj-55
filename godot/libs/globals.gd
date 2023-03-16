extends Node

signal update_journal(message: String)
signal initiate_chat(speaker : String, message: String)
signal continue_chat(speaker : String, message: String)
signal abort_chat()

func chat(speaker : String, message : String):
	emit_signal("initiate_chat", speaker, message)

func add_to_chat(speaker : String, message : String):
	emit_signal("continue_chat", speaker, message)

func end_chat():
	emit_signal("abort_chat")
	
func journal(message : String):
	emit_signal("update_journal", message)
