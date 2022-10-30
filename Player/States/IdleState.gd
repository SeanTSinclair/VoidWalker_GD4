extends State

func state_logic(delta):
	actor.set_animation_state("idle")
	actor.velocity.x = move_toward(actor.velocity.x, 0, actor.stats.friction)
