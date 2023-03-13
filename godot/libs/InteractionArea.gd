extends Area2D

@export var interaction_id = "AAA"

func _ready():
	$Label.text = interaction_id
