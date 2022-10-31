extends State

@onready var stats : PlayerStats = preload("res://Player/PlayerStats.tres")
@onready var jump_velocity : float = ((2.0 * stats.jump_height) / stats.time_to_reach_peak) * -1.0

func enter_state(actor):
	super.enter_state(actor)
	actor.velocity.y = jump_velocity

func check_transitions():
	super.check_transitions()
	set_state(state_machine.states.in_air)
