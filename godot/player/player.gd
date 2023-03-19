extends CharacterBody2D

@export var ACCELERATION = 0.1
@export var FRICTION = 1
@export var MAX_SPEED = 100

@onready var animated_sprite = $AnimatedSprite2D
@onready var interaction_shape = $InteractionArea/InteractionShape
@onready var dream_shader_rect = $Camera2D/CanvasLayer/DreamShaderRect
@onready var dream_shader_rect_2 = $Camera2D/CanvasLayer/DreamShaderRect2

enum {
	RUN,
	INTERACT,
}

var direction_vector = Vector2.RIGHT
var state = INTERACT
var targets = []
var direction = Vector2.ZERO
	
func _ready():
	Globals.connect("dream_mode_toggled", _dream_mode_toggled)
	InteractionHandler.connect("interaction_started", _interaction_started)
	InteractionHandler.connect("interaction_stopped", _interaction_stopped)
	interaction_shape.disabled = true
	_play_animation("Idle")

func _physics_process(delta):	
	interaction_shape.rotation_degrees = rad_to_deg(direction_vector.angle()) - 90
	match state:
		RUN:	
			run_state(delta)
	
func run_state(_delta):
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
	
	if Input.is_action_just_pressed("ui_interact"):
		interaction_shape.disabled = false
	else:
		interaction_shape.disabled = true
	

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
	
	if angle_deg > -45.0 and angle_deg < 45.0:
		interaction_shape.position.x = 6
		interaction_shape.position.y = 10
		return "Right"
	elif angle_deg >= 45.0 and angle_deg <= 135.0:
		interaction_shape.position.y = 20
		interaction_shape.position.x = 0
		return "Down"
	elif angle_deg <= -45.0 and angle_deg >= -135.0:
		interaction_shape.position.x = 0
		interaction_shape.position.y = -2
		return "Up"
	
	interaction_shape.position.y = 10
	interaction_shape.position.x = -6
	return "Left"

func _play_animation(animation_type: String) -> void:
	var animation_name = animation_type + "_" + _get_direction_string(direction_vector.angle())
	animated_sprite.play(animation_name)

func _on_interaction_area_area_entered(area):
	InteractionHandler.interact(area.interaction_id)
	area.interaction_callback()

func _dream_mode_toggled(dream_state : bool):
	if dream_state:
		animated_sprite.modulate.a = 0.5
		dream_shader_rect.modulate.a = 1
		dream_shader_rect_2.modulate.a = 1
	else:
		animated_sprite.modulate.a = 1
		dream_shader_rect.modulate.a = 0
		dream_shader_rect_2.modulate.a = 0

func _interaction_started():
	state = INTERACT
	
func _interaction_stopped():
	state = RUN
