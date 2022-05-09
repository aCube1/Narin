extends KinematicBody2D
class_name Actor

const DIR_LEFT: int = -1
const DIR_RIGHT: int  = 1

export(int) var acceleration := 700
export(float) var ground_friction := 48.0
export(float) var slip_friction := 24.0
export(float) var air_friction := 8.0

export(float) var time_to_ascent := 0.40
export(float) var time_to_descent := 0.30
export(float) var jump_height := 128
export(float) var jump_distance := 210

var current_snap := Global.DEFAULT_SNAP
var velocity := Vector2.ZERO
var can_jump: bool = false
var direction: int

onready var normal_gravity: float = (2.0 * jump_height) / pow(time_to_ascent, 2)
onready var fall_gravity: float = (2.0 * jump_height) / pow(time_to_descent, 2)
onready var jump_force: float = (2.0 * jump_height) / time_to_ascent
onready var max_speed: float = jump_distance / (2.0 * time_to_ascent)

func _physics_process(_delta: float) -> void:
	velocity = move_and_slide_with_snap(velocity, current_snap, Vector2.UP)

func set_direction(dir: int) -> void:
	direction = dir
