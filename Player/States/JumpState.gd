extends State

@onready var stats : PlayerStats = preload("res://Player/PlayerStats.tres")
@onready var jump_velocity : float = ((2.0 * stats.jump_height) / stats.time_to_reach_peak) * -1.0

func enter_state(actor):
	self.actor = actor
	actor.velocity.y = jump_velocity
