extends CharacterBody2D

const SPEED = 300.0
func _physics_process(delta):
	pass

func _ready():
	$Name.hide()

func _on_interaction_area_2_area_entered(area):
	$Name.show()

func _on_interaction_area_2_area_exited(area):
	$Name.hide()
