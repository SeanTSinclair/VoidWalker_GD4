extends State

@export var invulnerable_duration : float = 0.5

var can_roll_attack : bool = true
var has_queued_attack : bool = false
var has_queued_jump : bool = false
var is_finished : bool = false
var roll_direction : Vector2 = Vector2.ZERO

func enter_state(parent):
	super.enter_state(parent)
	can_roll_attack = true
	has_queued_attack = false
	has_queued_jump = false
	is_finished = false
	actor.is_dodging = true
	get_tree().create_timer(invulnerable_duration).connect("timeout", Callable(actor, "reset_dodge"))
	if state_machine.get_input_axis().x == 0:
		roll_direction = state_machine.facing_direction()
	else:
		roll_direction = state_machine.get_input_axis()
	state_machine.input_enabled(false)
	actor.velocity.x = roll_direction.x * actor.stats.roll_speed
	actor.set_animation_state("roll")
	
func exit_state():
	state_machine.input_enabled(true)

func state_logic(delta):
	super.state_logic(delta)
	actor.apply_gravity(delta)
	actor.velocity.x = move_toward(actor.velocity.x, 0, 4)
	
func check_transitions():
	super.check_transitions()
	
	if Input.is_action_just_pressed("primary_attack") && can_roll_attack:
		has_queued_attack = true
	if Input.is_action_just_pressed("jump") && can_roll_attack:
		has_queued_jump = true
	
	if has_queued_attack && is_finished: 
		set_state(state_machine.states.roll_attack)
	elif has_queued_jump && is_finished: 
		set_state(state_machine.states.jump)
	elif is_finished:
		set_state(state_machine.states.idle)

func prevent_roll_attack():
	can_roll_attack = false

func roll_ended():
	is_finished = true
