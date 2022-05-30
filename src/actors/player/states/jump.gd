extends State

const MAX_JUMP_TIME: float = 0.20

var _jump_timer := MAX_JUMP_TIME

func enter(owner: Actor) -> void:
	owner.current_snap = Vector2.ZERO
	owner.current_gravity = owner.jump_gravity

func exit(owner: Actor) -> void:
	owner.current_snap = Global.DEFAULT_SNAP
	owner.jumpped = false

func update(_delta: float, _owner: Actor) -> void:
	pass

func physics_update(delta: float, owner: Actor) -> void:
	if _jump_timer > 0.0 and owner.jumpped:
		owner.can_jump = false
		owner.velocity.y = -owner.jump_impulse
		_jump_timer -= delta
	else:
		_jump_timer = MAX_JUMP_TIME
		complete()
