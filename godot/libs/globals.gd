extends Node

signal update_journal(message: String)
signal initiate_chat(speaker : String, message: String)
signal continue_chat(speaker : String, message: String)
signal abort_chat()

func end_chat():
	emit_signal("abort_chat")
