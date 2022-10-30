extends State

const SPEED = 300.0

@onready var stats : PlayerStats = preload("res://Player/PlayerStats.tres")

@onready var jump_gravity : float = ((-2.0 * stats.jump_height) / (stats.time_to_reach_peak * stats.time_to_reach_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * stats.jump_height) / (stats.time_to_reach_peak * stats.time_to_reach_peak)) * -1.0

var input_axis = Vector2.ZERO

func state_logic(delta):
	input_axis = state_machine.get_input_axis()
	actor.velocity.x = input_axis.x * SPEED
	
	if !state_machine.is_on_floor && !state_machine.is_dashing:
		actor.velocity.y += get_gravity() * delta

func get_gravity() -> float:
	return jump_gravity if actor.velocity.y < 0.0 else fall_gravity
