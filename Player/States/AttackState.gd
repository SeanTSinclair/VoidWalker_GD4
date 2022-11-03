extends State

var states = null

@onready var stats : PlayerStats = preload("res://Player/PlayerStats.tres")

@onready var jump_gravity : float = ((-2.0 * stats.jump_height) / (stats.time_to_reach_peak * stats.time_to_reach_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * stats.jump_height) / (stats.time_to_reach_peak * stats.time_to_reach_peak)) * -1.0

var attack_sequence : int = 0
var max_attacks_in_sequence : int

var attack_ended : bool = true
var next_attack_queued : bool = false

var dash_queued : bool = false

var attacks : Array = []

func _physics_process(delta):
	if next_attack_queued && attack_ended:
		attack_ended = false
		next_attack_queued = false
		actor.velocity.x += state_machine.facing_direction().x * 200
		actor.set_animation_state(attacks[attack_sequence].get_meta("animation_name"))
		attack_sequence += 1
	
	if actor != null:
		if !state_machine.is_on_floor:
			actor.apply_gravity(delta)
		else: 
			actor.velocity = actor.velocity.move_toward(Vector2.ZERO, stats.friction)

func queue_next_attack():
	next_attack_queued = true
	
func end_current_attack():
	attack_ended = true

func check_transitions():
	super.check_transitions()
	
	if states == null:
		states = state_machine.states
	
	if Input.is_action_just_pressed("primary_attack") && attack_sequence < max_attacks_in_sequence:
		queue_next_attack()
	
	if Input.is_action_just_pressed("dash"):
		dash_queued = true
		get_tree().create_timer(.1).connect("timeout", Callable(self, "reset_dash_timer"))
	
	if attack_ended && !next_attack_queued:
		if dash_queued:
			set_state(states.dash)
		else: 
			set_state(states.idle)


func enter_state(actor):
	super.enter_state(actor)
	attacks = get_children()
	max_attacks_in_sequence = attacks.size()
	queue_next_attack()
	

func exit_state():
	super.exit_state()
	attack_ended = true
	next_attack_queued = false
	attack_sequence = 0
	
func reset_dash_timer():
	dash_queued = false
	
func get_gravity() -> float:
	return jump_gravity if actor.velocity.y < 0.0 else fall_gravity
