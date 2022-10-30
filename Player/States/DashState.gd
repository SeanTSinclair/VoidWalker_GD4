extends State

var dash_time = 0
var has_dashed : bool = false

func state_logic(delta):
	if state_machine.is_dashing:
		dash_time += 1
		if dash_time >= int(0.25 * 1 / delta):
			state_machine.is_dashing = false
			dash_time = 0
	if actor.is_on_floor && actor.velocity.y >= 0:
			has_dashed = false

func enter_state(actor):
	super.enter_state(actor)
	actor.set_animation_state("dash")
	if !has_dashed:
		if Input.is_action_just_pressed("dash"):
			actor.velocity = state_machine.get_input_axis() * actor.stats.dash_speed
			Input.start_joy_vibration(0, 1, .4, 0.2)
			state_machine.is_dashing = true
			has_dashed = true

func exit_state():
	state_machine.is_dashing = false
	has_dashed = false
	super.exit_state()
