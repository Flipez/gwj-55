extends CharacterBody2D

@export var interaction_id : String
@export_enum("Up", "Right", "Down", "Left") var view_direction = "Left"


const SPEED = 300.0
func _physics_process(_delta):
	pass

func _ready():
	$Name.hide()
	$AnimatedSprite2D.play("Idle_" + view_direction)

func _on_interaction_area_2_area_entered(area):
	if area.name == "Tooltip":
		$Name.show()
		
func _on_interaction_area_2_area_exited(area):
	if area.name == "Tooltip":
		$Name.hide()
		Globals.end_chat()
