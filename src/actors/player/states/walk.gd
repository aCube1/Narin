extends State

var _time_to_stop := 0.10
var _last_direction: int
var _stop_timer: float

func enter(owner: Actor) -> void:
	owner.current_speed = owner.walk_speed

func update(delta: float, owner: Actor) -> void:
	# Wait before switch to Idle State
	if owner.direction == 0:
		_stop_timer += delta
	else:
		_stop_timer = 0.0

	if _stop_timer >= _time_to_stop:
		complete("idle")
	if owner.can_jump and owner.jumpped:
		complete("jump")

func physics_update(delta: float, owner: Actor) -> void:
	if _last_direction != owner.direction:
		owner.velocity.x = lerp(owner.velocity.x, 0, owner.slip_friction * delta) as int

	_last_direction = owner.direction
