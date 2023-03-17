extends Node

@onready var pixel_art = $PixelArt
@onready var menu = $Menu
func _ready():
	pixel_art.show()
	menu.show()
