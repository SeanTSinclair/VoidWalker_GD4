extends State

const MAX_DISTANCE = 300.0

@export var melee_distance = 20.0
@export var ranged_distance = 250.0
@export_range(0.0, 1.0) var ranged_attack_ratio = 0.5

var is_at_desired_range = false
var is_attacking_from_range = false
var can_attack = true

var ranged_attacks : Array[Attack] = []
var melee_attacks : Array[Attack] = []

func _ready():
	for child in get_children():
		if child is Attack:
			if child.ranged: 
				ranged_attacks.append(child)
			else: 
				melee_attacks.append(child)

func enter_state(actor):
	super.enter_state(actor)
	decide_strategy()
	
func exit_state():
	super.exit_state()

func state_logic(delta):
	super.state_logic(delta)
	distance_based_checks()
	if is_at_desired_range && can_attack:
		var attack = null
		if is_attacking_from_range:
			attack = random_ranged_attack()
		else: 
			attack = random_melee_attack()
			# Create spacing between AI and player
		if attack != null:
			attack.attack()
	
func check_transitions():
	super.check_transitions()
	if state_machine.target == null:
		set_state(state_machine.states.wander)
		
	var distance_to_target = actor.distance_to(state_machine.target.global_position)
	if distance_to_target > MAX_DISTANCE:
		set_state(state_machine.states.wander)

func distance_based_checks():
	var distance_to_target = actor.distance_to(state_machine.target.global_position) # The target is null? why
	var desired_position = Vector2.ZERO
	var target_position = state_machine.target.global_position
	
	if distance_to_target < melee_distance:
		is_attacking_from_range = false
		
	if is_attacking_from_range:
		var closer_than_preferable = distance_to_target < ranged_distance -20 && distance_to_target > melee_distance
		if closer_than_preferable:
			is_at_desired_range = false
			desired_position = Vector2((actor.direction_to(target_position).x * -1) + ranged_distance, target_position.y)
		else:
			is_at_desired_range = true
	else:
		var further_away_than_preferable = distance_to_target > melee_distance
		if further_away_than_preferable:
			desired_position = Vector2(actor.direction_to(target_position).x + melee_distance * -1, target_position.y)
		else:
			is_at_desired_range = true
	if desired_position != Vector2.ZERO && !is_at_desired_range:
		actor.move_towards_point(desired_position, actor.stats.chase_speed)
	else:
		actor.slow_to_stop()
		actor.set_facing_direction(actor.direction_to(state_machine.target.global_position))
	
func decide_strategy():
	if ranged_attacks.size() > 0 && melee_attacks.size() > 0:
		is_attacking_from_range = randf_range(0, 9) * ranged_attack_ratio >= 2.5
	elif ranged_attacks.size() > 0:
		is_attacking_from_range = true
	elif melee_attacks.size() > 0: 
		is_attacking_from_range = false

func random_melee_attack() -> Attack:
	return melee_attacks[randi_range(0, melee_attacks.size()-1)]

func random_ranged_attack() -> Attack:
	return ranged_attacks[randi_range(0, ranged_attacks.size()-1)]

func enable_attack():
	can_attack = true

func _on_gun_attacking(animation, duration):
	actor.set_animation_state(animation)
	get_tree().create_timer(duration).connect("timeout", Callable(self, "enable_attack"))
	can_attack = false

func _on_blade_attacking(animation, duration):
	actor.set_animation_state(animation)
	get_tree().create_timer(duration).connect("timeout", Callable(self, "enable_attack"))
	can_attack = false
