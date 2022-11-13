extends State

func enter_state(actor):
	super.enter_state(actor)
	actor.set_animation_state("death")
