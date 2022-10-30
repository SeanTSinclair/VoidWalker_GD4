extends State

const SPEED = 300.0

var input_axis = Vector2.ZERO

func state_logic(delta):
	actor.set_animation_state("walk")
	input_axis = state_machine.get_input_axis()
	actor.velocity.x = input_axis.x * SPEED
