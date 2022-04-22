extends KinematicBody2D
class_name Character

const SNAP_VECTOR := Vector2.DOWN * 8.0

export(float) var coyote_time := 0.10
export(float) var jump_buffer_timer := 0.30

# Horizontal Movement
export(int) var acceleration := 700
export(float) var stop_friction := 24.0 # Stop walking friction
export(float) var friction := 48.0 # Change direction friction

# Vertical Movement
export(float) var time_to_jump_peak := 0.40
export(float) var time_to_jump_descent := 0.20
export(float) var jump_height := 128
export(float) var jump_distance := 210

var is_grounded := true
var is_jumping := false
var is_falling := false
var jumpped := false

var _velocity := Vector2.ZERO
var _last_direction: float

var _can_jump := false
var _jumping := false
var _current_snap := SNAP_VECTOR

onready var _gravity: float = (2.0 * jump_height) / pow(time_to_jump_peak, 2)
onready var _fall_gravity: float = (2.0 * jump_height) / pow(time_to_jump_descent, 2)
onready var _jump_force: float = (2.0 * jump_height ) / time_to_jump_peak
onready var _max_speed: float = jump_distance / (2.0 * time_to_jump_peak)
onready var CoyoteTimer := Timer.new()
onready var JumpBuffer := Timer.new()

func _ready() -> void:
	CoyoteTimer.wait_time = coyote_time
	CoyoteTimer.one_shot = true

	JumpBuffer.wait_time = jump_buffer_timer
	JumpBuffer.one_shot = true

	assert(CoyoteTimer.connect("timeout", self, "_on_CoyoteTimer_timeout") == OK)
	add_child(JumpBuffer)
	add_child(CoyoteTimer)

func _physics_process(delta: float) -> void:
	if CoyoteTimer.is_stopped():
		_velocity.y += get_current_gravity() * delta
	_current_snap = SNAP_VECTOR if not is_jumping else Vector2.ZERO

	_velocity = move_and_slide_with_snap(_velocity, _current_snap, Vector2.UP)
	if is_on_floor():
		is_grounded = CoyoteTimer.is_stopped()
		is_jumping = false
		_jumping = false
		_can_jump = true
	else:
		is_grounded = false

func _process(_delta: float) -> void:
	is_falling = _velocity.y > 0.0 and not is_jumping

	if _can_jump and is_falling and CoyoteTimer.is_stopped():
		CoyoteTimer.start()
	if jumpped:
		CoyoteTimer.stop()

func _on_CoyoteTimer_timeout() -> void:
	_can_jump = false

func jump() -> void:
	if jumpped:
		if not is_grounded and JumpBuffer.is_stopped():
			JumpBuffer.start()
		_jumping = true

	if not jumpped and not JumpBuffer.is_stopped():
		_jumping = false

	if _jumping and _can_jump:
		_velocity.y = -_jump_force
		_can_jump = false
		_jumping = true
		is_jumping = true

	if not jumpped and not _jumping and _velocity.y < 0.0:
		_velocity.y -= _velocity.y / 2

func move(direction: float) -> void:
	var delta := get_physics_process_delta_time()
	direction = clamp(direction, -1.0, 1.0)

	if direction != 0:
		_velocity.x += acceleration * direction * delta
		_velocity.x = clamp(_velocity.x, -_max_speed, _max_speed)
		if _last_direction != direction:
			_velocity.x = int(lerp(_velocity.x, 0, friction * delta))

	if is_grounded or not CoyoteTimer.is_stopped():
		if direction == 0:
			_velocity.x = int(lerp(_velocity.x, 0, stop_friction * delta))

	_last_direction = direction if direction != 0 else _last_direction

func get_current_gravity() -> float:
	return _fall_gravity if is_falling else _gravity
