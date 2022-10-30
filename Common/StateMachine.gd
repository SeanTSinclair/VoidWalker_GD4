extends Node
class_name StateMachine

signal state_changed(new_state)

var states = {}
var current_state = null

func _physics_process(delta):
	if current_state != null:
		tick(delta)
		current_state.state_logic(delta)
		transition_logic(delta)

func initialize():
	var children = get_children()
	for child in children:
		if child is State:
			states[child.state_name] = child
			child.state_machine = self
			
	print("State machine for %s initialized with states: %s" % [owner.name, states.keys()])
	

func set_state(state):
	if current_state != null:
		current_state.exit_state()
		
	current_state = state
	current_state.enter_state(owner)
	emit_signal("state_changed", current_state)

func tick(delta):
	pass

func transition_logic(delta):
	pass
