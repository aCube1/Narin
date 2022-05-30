extends State

func enter(_owner: Actor) -> void:
	pass

func update(_delta: float, owner: Actor) -> void:
	if owner.direction != 0:
		if !owner.running:
			complete("walk")
	if not owner.is_on_floor():
		complete("fall")

	if owner.can_jump and owner.jumpped:
		complete("jump")

func physics_update(delta: float, owner: Actor) -> void:
	owner.velocity.x = lerp(owner.velocity.x, 0, owner.ground_friction * delta) as int
