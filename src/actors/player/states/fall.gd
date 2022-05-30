extends State

func enter(owner: Actor) -> void:
	owner.current_snap = Vector2.ZERO
	owner.current_gravity = owner.fall_gravity

func exit(owner: Actor) -> void:
	owner.current_snap = Global.DEFAULT_SNAP

func update(_delta: float, owner: Actor) -> void:
	if owner.is_on_floor():
		complete()

func physics_update(delta: float, owner: Actor) -> void:
	owner.velocity.x = lerp(owner.velocity.x, 0, owner.air_friction * delta) as int
