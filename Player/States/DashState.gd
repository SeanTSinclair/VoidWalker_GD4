extends State

var dash_time = 0
var has_dashed : bool = false
var dash_direction : Vector2 = Vector2.RIGHT

var states = null

func state_logic(delta):
	super.state_logic(delta)
	if !has_dashed:
		var dash_direction = state_machine.get_input_axis()
		if dash_direction == Vector2.ZERO:
			dash_direction = state_machine.facing_direction()
		actor.velocity = dash_direction * actor.stats.dash_speed
		Input.start_joy_vibration(0, 1, .4, 0.2)
		state_machine.is_dashing = true
		has_dashed = true
	
	if state_machine.is_dashing:
		dash_time += 1
		if dash_time >= int(0.25 * 1 / delta):
			state_machine.is_dashing = false
			dash_time = 0
	
	if actor.is_on_floor && actor.velocity.y >= 0:
			has_dashed = false

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

func enter_state(actor):
	super.enter_state(actor)
	has_dashed = false
	actor.set_animation_state("dash")

func exit_state():
	state_machine.is_dashing = false
	has_dashed = false
	super.exit_state()
