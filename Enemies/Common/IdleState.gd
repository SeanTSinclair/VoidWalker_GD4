extends State

func enter_state(actor):
	super.enter_state(actor)
	actor.set_animation_state("idle")
	
func exit_state():
	super.exit_state()

func state_logic(delta):
	super.state_logic(delta)
	if !actor.is_on_floor():
		actor.apply_gravity(delta)
	actor.velocity.x = move_toward(actor.velocity.x, 0, actor.stats.friction)
	
func check_transitions():
	super.check_transitions()
	if state_machine.is_wandering:
		set_state(state_machine.states.wander)
	if state_machine.target != null:
		set_state(state_machine.states.chase)
	
