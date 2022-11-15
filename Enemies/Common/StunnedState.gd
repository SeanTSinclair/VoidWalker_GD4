extends State

@onready var timer = $Timer
@export var stun_duration : float = 3.0

var stun_finished : bool = false

func enter_state(parent):
	super.enter_state(parent)
	actor.set_animation_state("stunned")
	timer.start(stun_duration)
	actor.velocity = Vector2.ZERO
	stun_finished = false
	
func exit_state():
	actor.is_stunned = false
	super.exit_state()
	stun_finished = false
	
func state_logic(delta):
	super.state_logic(delta)
	actor.apply_gravity(delta)
	
func check_transitions():
	super.check_transitions()
	if stun_finished:
		if state_machine.target != null:
			set_state(state_machine.states.chase)
		else: 
			set_state(state_machine.states.wander)

func _on_timer_timeout():
	stun_finished = true
