extends State

func enter(owner: Node) -> void:
	if not owner is Actor:
		push_error("Idle can only be used with actors")
		return

func update(_delta: float, owner: Node) -> void:
	if owner.direction != 0:
		complete("run")

func physics_update(delta: float, owner: Node) -> void:
	owner.velocity.x = lerp(owner.velocity.x, 0, owner.ground_friction * delta) as int
