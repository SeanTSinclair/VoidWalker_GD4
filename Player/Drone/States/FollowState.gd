extends State

var speed = 350
var stopping_distance = 100

func enter_state(actor):
	super.enter_state(actor)
	actor.set_animation_state("idle")

func state_logic(delta):
	super.state_logic(delta)
	if actor.distance_to_player() > stopping_distance:
		actor.velocity = actor.direction_to_player() * speed
	
func check_transitions():
	super.check_transitions()
	if actor.distance_to_player() < stopping_distance:
		set_state(state_machine.states.idle)
