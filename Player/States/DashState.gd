extends State

func enter_state(actor):
	super.enter_state(actor)
	if !actor.has_dashed:
		if Input.is_action_just_pressed("dash"):
			actor.velocity = actor.get_input_axis() * actor.stats.DASH_SPEED
			Input.start_joy_vibration(0, 1, .4, 0.2)
			actor.is_dashing = true
			actor.has_dashed = true
