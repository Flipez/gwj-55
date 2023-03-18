extends StaticBody2D

@export var interaction_id : String

func interaction_callback():
	$AnimatedSprite2D.play("default")
	$CollisionShape2D.set_deferred("disabled", true)
