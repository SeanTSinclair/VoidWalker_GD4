extends State

func enter_state(parent):
	super.enter_state(parent)
	actor.set_animation_state("death")
