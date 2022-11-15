extends State

var stopping_distance = 100

func enter_state(parent):
	super.enter_state(parent)
	actor.set_animation_state("following")

func state_logic(delta):
	super.state_logic(delta)
	if actor.distance_to_player() > stopping_distance:
		actor.move(actor.direction_to_player())
	
func check_transitions():
	super.check_transitions()
	if actor.distance_to_player() < stopping_distance:
		set_state(state_machine.states.idle)
	elif actor.is_being_controlled: 
		set_state(state_machine.states.controlled)
