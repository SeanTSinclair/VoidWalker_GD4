extends State

const SPEED = 300.0
const MAX_SPEED = 500.0

@onready var stats : PlayerStats = preload("res://Player/PlayerStats.tres")

@onready var jump_gravity : float = ((-2.0 * stats.jump_height) / (stats.time_to_reach_peak * stats.time_to_reach_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * stats.jump_height) / (stats.time_to_reach_peak * stats.time_to_reach_peak)) * -1.0

var input_axis = Vector2.ZERO

var states = null

func state_logic(delta):
	input_axis = state_machine.get_input_axis()
	actor.velocity.x += input_axis.x * SPEED
	actor.velocity.x = clamp(actor.velocity.x, -MAX_SPEED, MAX_SPEED)
	
	var vertical_velocity = actor.velocity.normalized().y
	if vertical_velocity < -0.1:
		actor.set_animation_state("jump_up")
	elif vertical_velocity > -0.1 && vertical_velocity < 0.1 && !actor.is_on_floor():
		actor.set_animation_state("jump_apex")
	elif vertical_velocity > 0.1:
		actor.set_animation_state("fall")
	
	if !state_machine.is_on_floor && !state_machine.is_dashing:
		actor.velocity.y += get_gravity() * delta

	
func check_transitions():
	if states == null:
		states = state_machine.states
	var is_on_floor = state_machine.is_on_floor
	var is_dashing = state_machine.is_dashing
	
	if is_on_floor:
		state_machine.dash_count = 0
		set_state(states.idle)
	if Input.is_action_just_pressed("dash") && state_machine.dash_count < actor.stats.max_dashes:
		state_machine.dash_count += 1
		set_state(states.dash)

func get_gravity() -> float:
	return jump_gravity if actor.velocity.y < 0.0 else fall_gravity
