extends State

@export var lost_player_chase_duration : float = 3.0
@export var max_distance_to_target : float = 400.0
@export var attack_range : float = 5.0

@onready var lost_player_timer = $LostPlayerTimer

var has_given_up : bool = false

func enter_state(parent):
	super.enter_state(parent)
	lost_player_timer.connect("timeout", Callable(self, "return_check"))
	actor.set_animation_state("move")
	call_deferred("test")
	
func exit_state():
	super.exit_state()
	lost_player_timer.disconnect("timeout", Callable(self, "return_check"))
	has_given_up = false

func state_logic(delta):
	super.state_logic(delta)
	actor.move_towards_point(actor.target.global_position)
	
func check_transitions():
	super.check_transitions()
	if has_given_up:
		set_state(state_machine.states.retreat)
	elif actor.distance_to_target() < attack_range:
		set_state(state_machine.states.attack)
	elif actor.is_dead: 
		set_state(state_machine.states.dead)

func return_check():
	if actor.distance_to_target() > max_distance_to_target:
		has_given_up = true
