extends State

var dash_time = 0
var has_dashed : bool = false
var dash_direction : Vector2 = Vector2.RIGHT

var states = null
	

func state_logic(delta):
	super.state_logic(delta)
	
	if state_machine.is_dashing:
		dash_time += 1
		if dash_time >= int(0.25 * 1 / delta):
			state_machine.is_dashing = false
			dash_time = 0

func check_transitions():
	super.check_transitions()
	if states == null:
		states = state_machine.states
	var is_on_floor = state_machine.is_on_floor
	var is_dashing = state_machine.is_dashing
	
	if !is_dashing:
		if is_on_floor:
			set_state(states.idle)
		else:
			set_state(states.in_air)

func enter_state(parent):
	super.enter_state(parent)
	actor.set_animation_state("dash")
	dash_direction = state_machine.get_input_axis()
	if dash_direction == Vector2.ZERO:
		dash_direction = state_machine.facing_direction()
	actor.velocity = dash_direction * actor.stats.dash_speed
	Input.start_joy_vibration(0, 1, .4, 0.2)
	state_machine.is_dashing = true
	state_machine.input_enabled(false)

func exit_state():
	state_machine.is_dashing = false
	state_machine.input_enabled(true)
	super.exit_state()
