extends State

var input_axis = Vector2.ZERO

var states = null
var move_speed = 0

func enter_state(actor):
	super.enter_state(actor)
	move_speed = actor.stats.move_speed

func state_logic(delta):
	super.state_logic(delta)
	if Input.is_action_pressed("run"): 
		actor.set_animation_state("run")
		move_speed = actor.stats.run_speed
	else:
		actor.set_animation_state("walk")
		actor.stats.move_speed
	input_axis = state_machine.get_input_axis()
	if input_axis.x > 0: input_axis.x = 1
	elif input_axis.x < 0: input_axis.x = -1
	actor.velocity.x = input_axis.x * move_speed

func check_transitions():
	super.check_transitions()
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
	if Input.is_action_just_pressed("primary_attack"):
		set_state(states.attack)
	if !is_on_floor:
		set_state(states.in_air)
