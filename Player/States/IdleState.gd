extends State

const FRICTION = 300.0

func state_logic(delta):
	actor.set_animation_state("idle")
	actor.velocity.x = move_toward(actor.velocity.x, 0, FRICTION)
