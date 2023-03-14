extends CharacterBody2D

const SPEED = 300.0
func _physics_process(_delta):
	pass

func _ready():
	$Name.hide()

func _on_interaction_area_2_area_entered(area):
	if area.name == "Tooltip":
		$Name.show()
		
func _on_interaction_area_2_area_exited(area):
	if area.name == "Tooltip":
		$Name.hide()
		Globals.end_chat()
