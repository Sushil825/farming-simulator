extends Node
class_name FiniteStateMachine

var states: Dictionary = {}
var current_state: State
@export var initial_state: State

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.state_transition.connect(change_state)
	
	if initial_state:
		initial_state.Enter()
		current_state = initial_state

func _process(delta: float) -> void:
	if current_state:
		current_state.Update(delta)

func change_state(last_state: State, new_state_name: String) -> void:
	if last_state != current_state:
		return

	var new_state = states.get(new_state_name.to_lower())

	if !new_state:
		print("Error: State not found - ", new_state_name)
		return

	if current_state:
		current_state.Exit()

	new_state.Enter()
	current_state = new_state
