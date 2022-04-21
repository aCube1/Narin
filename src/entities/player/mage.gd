extends Character

var _direction := 0.0

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	_direction = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")

	if Input.is_action_just_pressed("move_jump"):
		jumpped = true
	if Input.is_action_just_released("move_jump"):
		jumpped = false

	move(_direction)
	jump()
