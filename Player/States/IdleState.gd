extends State

var states = null

func enter_state(actor):
	super.enter_state(actor)
	state_machine.can_air_attack = true

func state_logic(delta):
	super.state_logic(delta)
	actor.set_animation_state("idle")
	actor.velocity.x = move_toward(actor.velocity.x, 0, actor.stats.friction)

func check_transitions():
	super.check_transitions()
	if states == null:
		states = state_machine.states
	var is_on_floor = state_machine.is_on_floor
	var is_dashing = state_machine.is_dashing
	
	if !is_dashing && state_machine.get_input_axis() != Vector2.ZERO:
		set_state(states.move)
	if Input.is_action_just_pressed("jump") && is_on_floor:
		set_state(states.jump)
	if Input.is_action_just_pressed("dash") && !is_dashing:
		set_state(states.dash)
	if !is_on_floor:
		set_state(states.in_air)
	if Input.is_action_just_pressed("primary_attack"):
		set_state(states.attack)
