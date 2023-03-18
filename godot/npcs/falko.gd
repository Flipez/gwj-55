extends "res://npcs/npc.gd"

@onready var _follow :PathFollow2D = get_parent()

var old_pos = Vector2.ZERO

func _ready():
	InteractionHandler.connect("falko_forwards", _falko_forwards)
	InteractionHandler.connect("falko_backwards", _falko_backwards)
	super._ready()

	_follow.progress_ratio = 0


func _process(_delta):
	var pos_delta = old_pos - get_position_delta()
	
	if pos_delta.x < -0.2:
		$AnimatedSprite2D.play("Run_Right")
	elif pos_delta.x > 0.2:
		$AnimatedSprite2D.play("Run_Left")
	elif pos_delta.y < -0.2:
		$AnimatedSprite2D.play("Run_Down")
	elif pos_delta.y > 0.2:
		$AnimatedSprite2D.play("Run_Up")
		
	if pos_delta == Vector2.ZERO:
		var dir = $AnimatedSprite2D.animation.split("_")[1]
		$AnimatedSprite2D.play("Idle_" + dir)
	
	old_pos = get_position_delta()

func _falko_forwards():
	var tween :Tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(_follow, 'progress_ratio', 1, 10)
	
func _falko_backwards():
	var tween :Tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(_follow, 'progress_ratio', 0, 10)
