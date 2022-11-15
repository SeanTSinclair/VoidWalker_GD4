extends State

func enter_state(parent):
	super.enter_state(parent)
	actor.indicator.visible = true
	
func exit_state():
	actor.indicator.visible = false
	super.exit_state()

func state_logic(delta):
	super.state_logic(delta)
	actor.move(get_input_axis())
	actor.rotate_indicator()
	if Input.is_action_just_pressed("primary_attack"):
		actor.attack()
	
func check_transitions():
	super.check_transitions()
	if !actor.is_being_controlled:
		set_state(state_machine.states.follow)

func get_input_axis() -> Vector2:
	var input_axis = Vector2.ZERO
	input_axis.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	input_axis.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	return input_axis.normalized()
