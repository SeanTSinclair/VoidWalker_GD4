extends State

func enter_state(parent):
	super.enter_state(parent)
	actor.set_animation_state("idle")
	state_machine.input_enabled(false)
	actor.camera_active(false)
	actor.drone.camera_active(true)
	actor.drone.set_is_controlled(true)
	actor.connect("take_damage", Callable(self, "cancel_state"))

	
func exit_state():
	actor.drone.set_is_controlled(false)
	actor.camera_active(true)
	actor.drone.camera_active(false)
	super.exit_state()
	state_machine.input_enabled(true)
	
func check_transitions():
	super.check_transitions()
	if Input.is_action_just_pressed("control_drone"):
		cancel_state()
	
func cancel_state():
	set_state(state_machine.states.idle)
