extends "res://props/office/generic_interaction.gd"

func _ready():
	super._ready()
	
	InteractionHandler.connect("fridge_open", _fridge_open)
	InteractionHandler.connect("fridge_close", _fridge_close)
	
func _fridge_open():
	$Sprite2D2.visible = true
	
func _fridge_close():
	$Sprite2D2.visible = false
