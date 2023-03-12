extends CharacterBody2D

@export var ACCELERATION = 0.1
@export var FRICTION = 1.01
@export var MAX_SPEED = 100

@onready var animated_sprite = $AnimatedSprite2D

enum {
	RUN,
}

var direction_vector = Vector2.DOWN
var state = RUN
var targets = []
var direction = Vector2.ZERO
	
func _physics_process(delta):
	match state:
		RUN:	
			run_state(delta)
	
func run_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		direction_vector = input_vector
		velocity = velocity.lerp(direction_vector * MAX_SPEED, ACCELERATION)
		_play_animation("Run")
	else:
		velocity = velocity.lerp(Vector2.ZERO, FRICTION)
		_play_animation("Idle")
		
	move_and_slide()
	

func animation_finished():	
	if !Input.is_action_pressed("action"):
		state = RUN
		velocity = Vector2.ZERO
	
func on_target_hit() -> void:
	for target in targets:
		target.hit()

func _on_Hitbox_body_entered(body):
	targets.append(body)

func _on_Hitbox_body_exited(body):
	targets.erase(body)
	
func _get_direction_string(angle: float) -> String:
	var angle_deg = round(rad_to_deg(angle))
	print(angle_deg)
	
	if angle_deg > -45.0 and angle_deg < 45.0:
		return "Right"
	elif angle_deg >= 45.0 and angle_deg <= 135.0:
		return "Down"
	elif angle_deg <= -45.0 and angle_deg >= -135.0:
		return "Up"
	return "Left"

func _play_animation(animation_type: String) -> void:
	var animation_name = animation_type + "_" + _get_direction_string(direction_vector.angle())
	animated_sprite.play(animation_name)
