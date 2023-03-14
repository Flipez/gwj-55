extends Area2D

var interaction_id

func _ready():
	if get_parent().get("interaction_id"):
		interaction_id = get_parent().interaction_id
	else:
		interaction_id = "NOPE"

	$Label.text = interaction_id
