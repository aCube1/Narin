extends State

var _last_direction: float

func enter(owner: Node) -> void:
	if not owner is Actor:
		push_error("Run can only be used with actors")
		return

func update(_delta: float, owner: Node) -> void:
	if owner.direction == 0:
		complete()

func physics_update(delta: float, owner: Node) -> void:
	if not owner is Actor:
		return

	owner.velocity.x += owner.acceleration * owner.direction * delta
	owner.velocity.x = clamp(owner.velocity.x, -owner.max_speed, owner.max_speed)
	if _last_direction != owner.direction:
		owner.velocity.x = lerp(owner.velocity.x, 0, owner.slip_friction * delta) as int

	_last_direction = owner.direction
