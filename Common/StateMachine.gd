extends Node
class_name StateMachine

signal state_changed(new_state)

var states = {}
var current_state = null
var previous_state = null

func _physics_process(delta):
	if current_state != null:
		current_state.state_logic(delta)
		current_state.check_transitions()

func initialize():
	var children = get_children()
	for child in children:
		if child is State:
			states[child.state_name] = child
			child.state_machine = self
			
	print("State machine for %s initialized with states: %s" % [owner.name, states.keys()])
	

func set_state(old_state, new_state):
	if !new_state.unlocked: return
	if current_state != null:
		current_state.exit_state()
	previous_state = old_state
	current_state = new_state
	current_state.enter_state(owner)
	emit_signal("state_changed", current_state)

