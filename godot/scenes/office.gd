extends Node2D

@onready var toilet_roof = $Tiles/ToiletRoof
func _ready():
	Globals.open_toilet_door.connect(func(): toilet_roof.hide())
