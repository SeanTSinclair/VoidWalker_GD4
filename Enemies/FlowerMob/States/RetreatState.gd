extends State

@export var stop_distance : float = 5.0

func enter_state(parent):
	super.enter_state(parent)
	actor.target = null

func state_logic(delta):
	super.state_logic(delta)
	actor.move_towards_point(actor.spawn_position)
	
func check_transitions():
	super.check_transitions()
	if actor.distance_to_spawn() < stop_distance:
		set_state(state_machine.states.idle)
	elif actor.target != null: 
		set_state(state_machine.states.chase)
