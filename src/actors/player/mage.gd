extends Actor
class_name Player

enum States {
	IDLE,
	RUN,
}

onready var StateMachine := $StateMachine
onready var IdleState: State = preload("./states/idle.gd").new()
onready var RunState: State = preload("./states/run.gd").new()

var	_directions := {
	"left": DIR_LEFT,
	"right": DIR_RIGHT,
}

func _ready() -> void:
	var states := {
		States.IDLE: {
			"handler": IdleState,
			"change_to": States.RUN,
		},
		States.RUN: {
			"handler": RunState,
			"change_to": StateMachine.PREVIOUS,
		},
	}
	StateMachine.configure(states, States.IDLE)

func _process(_delta: float) -> void:
	direction = 0
	for dir in _directions.keys():
		if Input.is_action_pressed("move_%s" % dir):
			direction = _directions[dir]

func _on_StateMachine_state_changed(new_state) -> void:
	var text: String = ""
	match new_state:
		States.IDLE:
			text = "Idle"
		States.RUN:
			text = "Run"
		_:
			text = "Undefined State"

	$DebugContainer/State.text = text
