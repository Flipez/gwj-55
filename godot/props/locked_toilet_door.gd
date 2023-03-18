extends StaticBody2D

@export var interaction_id : String
@onready var interaction_area = $InteractionArea

func _ready():
	Globals.open_toilet_door.connect(open_door)

func open_door():
	$AnimatedSprite2D.play("default")
	$CollisionShape2D.set_deferred("disabled", true)
	interaction_area.hide()
