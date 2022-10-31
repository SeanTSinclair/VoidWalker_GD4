extends State

const SPEED = 300.0

var input_axis = Vector2.ZERO

var states = null

func enter_state(actor):
	super.enter_state(actor)
	actor.set_animation_state("walk")

func state_logic(delta):
	input_axis = state_machine.get_input_axis()
	if input_axis.x > 0: input_axis.x = 1
	elif input_axis.x < 0: input_axis.x = -1
	actor.velocity.x = input_axis.x * SPEED

func check_transitions():
	if states == null:
		states = state_machine.states
	var is_on_floor = state_machine.is_on_floor
	var is_dashing = state_machine.is_dashing
	
	if !is_dashing && state_machine.get_input_axis() == Vector2.ZERO:
		set_state(states.idle)
	if Input.is_action_just_pressed("jump") && is_on_floor:
		set_state(states.jump)
	if Input.is_action_just_pressed("dash") && !is_dashing:
		set_state(states.dash)
	if !is_on_floor:
		set_state(states.in_air)
