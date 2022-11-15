extends State

func enter_state(parent):
	super.enter_state(parent)
	actor.set_animation_state("idle")
	actor.has_spotted_player = false
	actor.player_in_range = false
	
func exit_state():
	super.exit_state()

func state_logic(delta):
	super.state_logic(delta)
	if !actor.is_on_floor():
		actor.apply_gravity(delta)
	actor.velocity.x = move_toward(actor.velocity.x, 0, actor.stats.friction)
	
func check_transitions():
	super.check_transitions()
	if actor.can_see_player():
		actor.has_spotted_player = true
		set_state(state_machine.states.chase)
	elif state_machine.is_wandering:
		set_state(state_machine.states.wander)
		
	
