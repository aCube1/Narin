extends Character

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1

	if Input.is_action_just_pressed("move_jump"):
		direction.y -= 1
	if Input.is_action_just_released("move_jump"):
		direction.y = 0
