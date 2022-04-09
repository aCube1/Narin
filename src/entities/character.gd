extends KinematicBody2D
class_name Character

const SNAP_VECTOR := Vector2.DOWN * 32.0

var direction := Vector2.ZERO
var is_on_ground := true
var is_jumping := false

# Horizontal Movement
var _acceleration := 700
var _stop_friction := 24.0 # Stop walking friction
var _friction := 48.0 # Change direction friction
var _velocity := Vector2.ZERO
var _last_x_direction := direction.x
var _max_speed: float

# Vertical Movement
var _time_to_jump_peak := 0.3
var _jump_height := 82
var _jump_distance := 210
var _jump_force: float
var _gravity: float

var _current_snap := SNAP_VECTOR

func _ready() -> void:
	_gravity = (2.0 * _jump_height) / pow(_time_to_jump_peak, 2)
	_jump_force = _gravity * _time_to_jump_peak
	_max_speed = _jump_distance / (2.0 * _time_to_jump_peak)

func _physics_process(delta: float) -> void:
	move(delta)
	jump()
	
	_current_snap = SNAP_VECTOR if not is_jumping else Vector2.ZERO
	_velocity.y += _gravity * delta
	_velocity = move_and_slide_with_snap(_velocity, _current_snap, Vector2.UP)

func jump() -> void:
	is_on_ground = is_on_floor() # Improve on Coyote Timer Implementation
	
	if direction.y < 0 and not is_jumping and is_on_ground:
		_velocity.y = -_jump_force
		is_jumping = true

	if direction.y == 0:
		if is_on_ground:
			is_jumping = false
		elif is_jumping and _velocity.y < 0.0:
			_velocity.y -= _velocity.y / 2

func move(delta: float) -> void:
	direction.x = clamp(direction.x, -1, 1)

	if direction.x != 0:
		_velocity.x += _acceleration * direction.x * delta
		_velocity.x = clamp(_velocity.x, -_max_speed, _max_speed)
		if _last_x_direction != direction.x:
			_velocity.x = int(lerp(_velocity.x, 0, _friction * delta))

	if is_on_ground:
		if direction.x == 0:
			_velocity.x = int(lerp(_velocity.x, 0, _stop_friction * delta))

	_last_x_direction = direction.x if direction.x != 0 else _last_x_direction
	direction.x = 0
