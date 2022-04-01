extends KinematicBody2D

onready var Sprites := $Sprites
onready var Animator := $Sprites/Animator
onready var StateMachine: AnimationNodeStateMachinePlayback = $Sprites/AnimatorTree.get("parameters/playback")
onready var JumpTimer := $JumpTimer

export(int) var acceleration := 450
export(float) var friction := 24.0
export(float) var stop_friction := 48.0 
export(float) var time_to_jump_peak := 0.3
export(int) var jump_height := 64
export(int) var jump_distance := 128

const SNAP_VECTOR := Vector2.DOWN * 32.0

var max_speed: float
var gravity: float
var jump_force: float
var velocity := Vector2.ZERO
var motion := Vector2.ZERO
var current_snap := SNAP_VECTOR
var last_x_motion := motion.x
var can_jump := false

func _ready() -> void:
	gravity = (2 * jump_height) / pow(time_to_jump_peak, 2)
	jump_force = gravity * time_to_jump_peak
	max_speed = jump_distance / (2.0 * time_to_jump_peak)

func _on_JumpTimer_timeout() -> void:
	can_jump = false

func _physics_process(delta: float) -> void:
	movement(delta)
	velocity.y = move_and_slide_with_snap(velocity, current_snap, Vector2.UP).y

func _process(_delta: float) -> void:
	last_x_motion = motion.x
	motion.x = 0

	if is_on_floor():
		can_jump = true
	elif not can_jump and JumpTimer.is_stopped():
		JumpTimer.start()

	if Input.is_action_pressed("move_right"):
		motion.x += 1
	if Input.is_action_pressed("move_left"):
		motion.x -= 1

	if Input.is_action_just_pressed("move_jump") and can_jump:
		velocity.y = -jump_force
	if Input.is_action_just_released("move_jump"):
		velocity.y -= velocity.y / 2

	animation()

func animation() -> void:
	if motion.x < 0:
		Sprites.flip_h = true
	elif motion.x > 0:
		Sprites.flip_h = false

	if motion.x != 0 and is_on_floor():
		StateMachine.travel("run")
	elif velocity.y != 0:
		if velocity.y < 0:
			StateMachine.travel("jump")
		else:
			StateMachine.travel("fall")
	else:
		StateMachine.travel("idle")

func movement(delta: float) -> void:
	if motion.x != 0:
		velocity.x += acceleration * motion.x * delta
		velocity.x = clamp(velocity.x, -max_speed, max_speed)
		if last_x_motion != motion.x:
			velocity.x = int(lerp(velocity.x, 0, stop_friction * delta))

	if is_on_floor():
		if motion.x == 0:
			velocity.x = int(lerp(velocity.x, 0, friction * delta))

	current_snap = SNAP_VECTOR if velocity.y > 0 else Vector2.ZERO
	velocity.y += gravity * delta
