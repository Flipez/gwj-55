extends StaticBody2D

@export var interaction_id = "AAA"
@export var item_of_interest = false

@onready var shader = preload("res://shaders/shining.gdshader")

func _ready():
	Globals.connect("dream_mode_toggled", _dream_mode_toggled)
	$Sprite2D.material = ShaderMaterial.new()

func _dream_mode_toggled(state : bool):
	if state && item_of_interest:
		$Sprite2D.material.shader = shader
	else:
		$Sprite2D.material.shader = null

