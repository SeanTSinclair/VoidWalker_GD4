extends State

var states = null

func enter_state(parent):
	super.enter_state(parent)
	state_machine.can_air_attack = true

func state_logic(delta):
	super.state_logic(delta)
	actor.set_animation_state("idle")
	actor.slow_to_stop()

func check_transitions():
	super.check_transitions()
	if states == null:
		states = state_machine.states
	var is_on_floor = state_machine.is_on_floor
	var is_dashing = state_machine.is_dashing
	
	if Input.is_action_just_pressed("jump") && is_on_floor:
		set_state(states.jump)
	elif Input.is_action_just_pressed("dash") && !is_dashing:
		if is_on_floor:
			set_state(states.roll)
		else: 
			set_state(states.dash)
	elif !is_on_floor:
		set_state(states.in_air)
	elif Input.is_action_just_pressed("primary_attack"):
		set_state(states.attack)
	elif Input.is_action_just_pressed("block"):
		set_state(states.block)
	elif Input.is_action_just_pressed("control_drone"):
		set_state(states.control_drone)
	elif !is_dashing && state_machine.get_input_axis() != Vector2.ZERO:
		set_state(states.move)
