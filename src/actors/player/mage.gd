extends Actor
class_name Player

enum States {
	IDLE,
	WALK,
	FALL,
	JUMP
}

# Test only, will be removed later
var current_state: String = ""

onready var Animator := $Sprites/Animation
onready var MoveStateMachine := $MoveStateMachine
onready var move_states := {
	"Idle": preload("./states/idle.gd").new(),
	"Walk": preload("./states/walk.gd").new(),
	"Fall": preload("./states/fall.gd").new(),
	"Jump": preload("./states/jump.gd").new(),
}

func _ready() -> void:
	setup_states()

func _process(_delta: float) -> void:
	direction = 0
	if Input.is_action_pressed("move_right"):
		direction += 1
		$Sprites.flip_h = false
	if Input.is_action_pressed("move_left"):
		direction -= 1
		$Sprites.flip_h = true
	
	if Input.is_action_just_pressed("move_jump"):
		jumpped = true
	if Input.is_action_just_released("move_jump"):
		jumpped = false

	update_animation()
	$DebugContainer/State.text = "%s" % current_state

func _physics_process(delta: float) -> void:
	apply_movement(delta)

func setup_states() -> void:
	var states := {
		States.IDLE: {
			"handler": move_states.Idle,
			"change_to": {
				"walk": States.WALK,
				"fall": States.FALL,
				"jump": States.JUMP,
			},
		},
		States.WALK: {
			"handler": move_states.Walk,
			"change_to": {
				"idle": States.IDLE,
				"jump": States.JUMP,
			}
		},
		States.FALL: {
			"handler": move_states.Fall,
			"change_to": States.IDLE,
		},
		States.JUMP: {
			"handler": move_states.Jump,
			"change_to": MoveStateMachine.PREVIOUS,
		},
	}
	MoveStateMachine.setup(states, States.IDLE)

func update_animation() -> void:
	match MoveStateMachine.get_current_state():
		States.IDLE:
			Animator.play("Idle")
			Animator.advance(0)
		States.WALK:
			Animator.play("Walk")
			Animator.advance(0)
		States.FALL:
			Animator.play("Fall")
			Animator.advance(0)
		States.JUMP:
			Animator.play("Jump")
			Animator.advance(0)
		_:
			Animator.play("RESET")
			Animator.advance(0)

func _on_MoveStateMachine_state_changed(new_state: int) -> void:
	current_state = States.keys()[new_state]
