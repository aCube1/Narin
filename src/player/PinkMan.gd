extends KinematicBody2D

const GRAVITY: int = 1200
const MAX_SPEED: int = 350

export(int) var jump_height := 320
export(int) var acceleration := 450
export(float) var friction := 0.4
export(float) var stop_friction := 0.8 

var velocity := Vector2.ZERO
var motion := Vector2.ZERO

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	movement(delta)
	
	velocity.y = move_and_slide(velocity, Vector2.UP).y

func movement(delta: float) -> void:
	var last_x = motion.x # Last X Motion
	motion.x = 0
	motion.y = 0

	if Input.is_action_pressed("move_right"):
		motion.x += 1
	if Input.is_action_pressed("move_left"):
		motion.x -= 1

	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		velocity.y = -jump_height

	if motion.x != 0:
		velocity.x += acceleration * motion.x * delta
		velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
		if last_x != motion.x:
			velocity.x = int(lerp(velocity.x, 0, stop_friction))

	if is_on_floor():
		if motion.x == 0:
			velocity.x = int(lerp(velocity.x, 0, friction))

	velocity.y += GRAVITY * delta
	if Input.is_action_just_released("move_jump") or is_on_ceiling():
		velocity.y = 0

#	velocity.y = motion.y if motion.y != 0 else velocity.y

