extends State

@export var vertical_boost : float = 8

func enter_state(actor):
	super.enter_state(actor)
	actor.set_animation_state("air_attack")
	actor.velocity.y = vertical_boost
	state_machine.can_air_attack = false

func attack_finished():
	set_state(state_machine.states.in_air)
