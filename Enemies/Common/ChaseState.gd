extends State

const CHASE_RANGE : float = 500.0
const COMBAT_RANGE : float = 150.0

func enter_state(actor):
	super.enter_state(actor)
	actor.set_animation_state("run")
	
func exit_state():
	super.exit_state()

func state_logic(delta):
	super.state_logic(delta)
	actor.apply_gravity(delta)
	if state_machine.target != null:
		actor.move_towards_point(state_machine.target.global_position, actor.stats.chase_speed)
	
func check_transitions():
	super.check_transitions()
	if state_machine.target == null:
		set_state(state_machine.states.wander)
	elif actor.position.distance_to(state_machine.target.global_position) < COMBAT_RANGE:
		set_state(state_machine.states.combat)
	
