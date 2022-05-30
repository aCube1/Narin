extends Node
class_name StateMachine

signal state_changed(new_state)

export(bool) var enabled := true

var current_state_id: int = NO_STATE
var initialized: bool = false

var states: Dictionary = {}
var current_state: Dictionary
var next_state: int = NO_STATE
var previous_state_id: int = NO_STATE
var initial_state: int

const NO_STATE: int = -2
const PREVIOUS: int = -1

func _process(delta: float) -> void:
	if !enabled:
		return

	if !initialized:
		change_to_initial_state()
		return

	if next_state != NO_STATE and next_state != current_state_id:
		if next_state == PREVIOUS:
			change_to_state(previous_state_id)
		elif states.get(next_state) != null:
			change_to_state(next_state)
		else:
			push_error("Next state doesn't exist") 
		next_state = NO_STATE

	if current_state.has("handler"):
		current_state.handler.update(delta, owner)

func _physics_process(delta: float) -> void:
	if current_state.has("handler"):
		current_state.handler.physics_update(delta, owner)

func _input(event: InputEvent) -> void:
	if current_state.has("handler"):
		current_state.handler.input(event, owner)

func setup(states_obj: Dictionary = {}, initial_state_id: int = 0) -> void:
	for key in states_obj:
		if states_obj[key] is Dictionary:
			states[key] = states_obj.get(key)
	initial_state = initial_state_id

func change_to_initial_state() -> void:
	initialized = true
	change_to_state(initial_state)

func change_to_next_state(change_key: String) -> void:
	if current_state.has("change_to") and (next_state == NO_STATE or next_state == current_state_id):
		if change_key != "" and current_state.change_to is Dictionary:
			if current_state.change_to.has(change_key):
				next_state = current_state.change_to[change_key]
		else:
			next_state = current_state.change_to

func change_to_state(id: int) -> void:
	if not states.has(id):
		return

	if current_state_id != NO_STATE:
		current_state.handler.exit(owner)
		previous_state_id = current_state_id

	set_current_state(id)
	current_state.handler.enter(owner)
	if not current_state.handler.is_connected("completed", self, "_on_CurrentState_completed"):
		current_state.handler.connect("completed", self, "_on_CurrentState_completed")
	emit_signal("state_changed", id)

func change_to(id: int) -> void:
	next_state = id

func set_current_state(id: int) -> void:
	current_state = states.get(id)
	current_state_id = id

func get_current_state() -> int:
	return current_state_id

func is_current_state(id: int) -> bool:
	return current_state_id == id

func _on_CurrentState_completed(change_key: String) -> void:
	change_to_next_state(change_key)
