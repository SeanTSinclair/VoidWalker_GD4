extends State

var friction = 150
var max_distance_to_target = 150

func enter_state(parent):
	super.enter_state(parent)
	actor.call_deferred("set_animation_state", "idle")

func state_logic(delta):
	super.state_logic(delta)
	actor.velocity.x = move_toward(actor.velocity.x, 0, friction)
	
func check_transitions():
	super.check_transitions()
	if actor.distance_to_player() > max_distance_to_target:
		set_state(state_machine.states.follow)
	elif actor.is_being_controlled: 
		set_state(state_machine.states.controlled)
