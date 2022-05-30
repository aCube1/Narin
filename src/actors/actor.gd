extends KinematicBody2D
class_name Actor

export(float) var ground_friction := 48.0
export(float) var slip_friction := 24.0
export(float) var air_friction := 8.0

export(float) var time_to_ascent := 0.40
export(float) var time_to_descent := 0.30
export(float) var jump_height := 128
export(float) var jump_distance := 256

var current_snap := Global.DEFAULT_SNAP
var velocity := Vector2.ZERO
var running := false
var jumpped := false
var can_jump := false
var acceleration: float
var direction: int

# Vertical Movement
onready var jump_gravity: float = (2.0 * jump_height) / pow(time_to_ascent, 2)
onready var fall_gravity: float = (2.0 * jump_height) / pow(time_to_descent, 2)
onready var jump_impulse: float = (2.0 * jump_height) / time_to_ascent
onready var current_gravity: float = fall_gravity
# Horizontal Movement
onready var walk_speed: float = jump_distance / (2.0 * time_to_ascent)
onready var run_speed: float = (jump_distance * 2.0) / (2.0 * time_to_ascent)
onready var current_speed: float = walk_speed

func apply_movement(delta: float) -> void:
	if is_on_floor():
		can_jump = true
	acceleration = current_speed * 1.5

	velocity.y += current_gravity * delta
	velocity.x += acceleration * direction * delta
	velocity.x = clamp(velocity.x, -current_speed, current_speed)
	
	velocity = move_and_slide_with_snap(velocity, current_snap, Vector2.UP)
