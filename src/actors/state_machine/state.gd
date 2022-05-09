extends Reference
class_name State

signal completed(change_key)

func enter(_owner: Node) -> void:
	pass

func exit(_owner: Node) -> void:
	pass

func update(_delta: float, _owner: Node) -> void:
	pass

func physics_update(_delta: float, _owner: Node) -> void:
	pass

func input(_event: InputEvent, _owner: Node) -> void:
	pass

# Call this to trigger StateMachine transition to next state
func complete(change_key: String = "") -> void:
	emit_signal("completed", change_key)
