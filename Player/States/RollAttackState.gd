extends State

func enter_state(actor):
	super.enter_state(actor)
	actor.set_animation_state("roll_attack")

func state_logic(delta):
	super.state_logic(delta)
	actor.slow_to_stop()

func attack_finished():
	set_state(state_machine.states.idle)
