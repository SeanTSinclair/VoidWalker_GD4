extends State

@onready var timer = $CombatDecisionTimer

@export var close_distance = 80.0
@export var avoid_distance = 150.0
@export var aggro_distance = 200.0
@export var decision_delay_min = 0.4
@export var decision_delay_max = 2.5

var is_avoiding : bool = false
var is_attacking : bool = false
var is_at_preferred_range : bool = false
var is_at_ranged_distance : bool = false
var can_use_ranged : bool
var can_use_melee : bool

var ranged_attacks : Array[Attack] = []
var melee_attacks : Array[Attack] = []

var distance_to_target : float = 0.0

func _ready():
	for child in get_children():
		if child is Attack:
			if child.ranged: 
				ranged_attacks.append(child)
			else: 
				melee_attacks.append(child)

func enter_state(actor):
	super.enter_state(actor)
	is_avoiding = random_true_false()
	can_use_ranged = ranged_attacks.size() > 0
	can_use_melee = melee_attacks.size() > 0
	timer.start(randf_range(decision_delay_min, decision_delay_max))
	
func exit_state():
	super.exit_state()

func state_logic(delta):
	super.state_logic(delta)
	distance_to_target = actor.distance_to(state_machine.target.global_position)
	print(str(is_avoiding) + str(distance_to_target))
	
	if !is_attacking && !is_at_preferred_range:
		spacing_movement()
			
	if is_at_preferred_range:
		actor.set_facing_direction(actor.direction_to(state_machine.target.global_position))
		if timer.time_left == 0:
			var should_attack = random_true_false()
			if should_attack:
				random_ranged_attack().attack(actor)
				timer.start(randf_range(decision_delay_min, decision_delay_max))
	#			if is_at_ranged_distance:
				
	
func spacing_movement():
	if is_avoiding && distance_to_target <= avoid_distance:
		var target_position = state_machine.target.global_position
		var desired_position = Vector2(target_position.x - (avoid_distance * actor.facing_direction.x), target_position.y)
		actor.move_towards_point(desired_position, actor.stats.chase_speed)
		actor.set_animation_state("run")
	elif !is_avoiding && distance_to_target >= close_distance:
		var target_position = state_machine.target.global_position
		var desired_position = Vector2(target_position.x - (close_distance * actor.facing_direction.x), target_position.y)
		actor.move_towards_point(desired_position, actor.stats.chase_speed)
		actor.set_animation_state("run")
	else: 
		is_at_preferred_range = true
		actor.set_animation_state("idle")

func random_melee_attack() -> Attack:
	return melee_attacks[randi_range(0, melee_attacks.size()-1)]

func random_ranged_attack() -> Attack:
	return ranged_attacks[randi_range(0, ranged_attacks.size()-1)]

func check_transitions():
	super.check_transitions()
	if distance_to_target > aggro_distance:
		set_state(state_machine.states.chase)

func random_true_false():
	return randi_range(0, 10) % 2 == 0

func _on_combat_decision_timer_timeout():
	is_avoiding = random_true_false()
	is_at_preferred_range = false
