extends StaticBody2D

@export var interaction_id : String

var door_open = false

func interaction_callback():
	if door_open:
		$AnimatedSprite2D.play_backwards("default")
		$CollisionShape2D.set_deferred("disabled", false)
		door_open = false
	else:
		$AnimatedSprite2D.play("default")
		$CollisionShape2D.set_deferred("disabled", true)
		door_open = true
