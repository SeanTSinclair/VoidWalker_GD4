extends State
	
func enter_state(parent):
	super.enter_state(parent)
	actor.set_animation_state("idle")
	
func check_transitions():
	super.check_transitions()
	if actor.target != null:
		set_state(state_machine.states.chase)
