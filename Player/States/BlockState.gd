extends State

@export var counter_duration : float = 0.5
var has_blocked : bool = false

func enter_state(parent):
	super.enter_state(parent)
	actor.set_animation_state("blocking")
	actor.is_blocking = true
	actor.is_countering = true
	state_machine.input_enabled(false)
	get_tree().create_timer(counter_duration).connect("timeout", Callable(self, "reset_counter"))

func reset_counter():
	if actor != null:
		actor.is_countering = false

func exit_state():
	actor.is_blocking = false
	actor.is_countering = false
	state_machine.input_enabled(true)
	super.exit_state()
	has_blocked = false

func state_logic(delta):
	super.state_logic(delta)
	actor.slow_to_stop()
	actor.apply_gravity(delta)
	if state_machine.is_taking_damage:
		has_blocked = true
		actor.set_animation_state("block")
	
func check_transitions():
	super.check_transitions()
	if Input.is_action_just_released("block"):
		set_state(state_machine.states.idle)
	elif has_blocked:
		set_state(state_machine.states.idle)
