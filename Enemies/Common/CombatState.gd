extends State

const MAX_DISTANCE = 200.0

@export var melee_distance = 20.0
@export var ranged_distance = 190.0
@export_range(0.0, 1.0) var ranged_attack_ratio = 0.5

var is_at_desired_range = false
var is_attacking_from_range = false
var can_attack = true
var attack_finished = true

var ranged_attacks : Array[Attack] = []
var melee_attacks : Array[Attack] = []

var distance_threshold = 20

func _ready():
	for child in get_children():
		if child is Attack:
			child.connect("attacking", Callable(self, "use_attack"))
			if child.ranged: 
				ranged_attacks.append(child)
			else: 
				melee_attacks.append(child)

func enter_state(actor):
	super.enter_state(actor)
	actor.player_in_range = true
	actor.target_ray.enabled = true
	decide_strategy()

func state_logic(delta):
	super.state_logic(delta)
	
	distance_based_checks()
	
	if !is_at_desired_range:
		move_to_desired_range()
	
	else:
		actor.slow_to_stop()
		actor.face_player()
		if can_attack:
			try_attack()
		elif !is_attacking_from_range && attack_finished:
			create_spacing()
	
func check_transitions():
	super.check_transitions()
	if state_machine.target == null:
		set_state(state_machine.states.wander)
		
	var distance_to_target = actor.distance_to(state_machine.target.global_position)
	if distance_to_target > MAX_DISTANCE:
		actor.player_in_range = false
		actor.has_spotted_player = false
		actor.target_ray.enabled = false
		set_state(state_machine.states.wander)
		
	elif actor.is_stunned: 
		set_state(state_machine.states.stunned)

func distance_based_checks():
	var distance = ranged_distance if is_attacking_from_range else melee_distance
	if actor.distance_to_player() > distance + distance_threshold \
	or actor.distance_to_player() < distance - distance_threshold:
		is_at_desired_range = true
	else: 
		is_at_desired_range = false

func move_to_desired_range():
	var desired_distance = ranged_distance if is_attacking_from_range else melee_distance
	var desired_move_direction = actor.direction_to_player() * -1
	var desired_x = desired_move_direction.x + (desired_distance * actor.facing_direction.x)
	var desired_y = actor.global_position.y
	
	actor.move_towards_point(Vector2(desired_x, desired_y), actor.stats.chase_speed)

func try_attack():
	var attack = null
	if is_attacking_from_range:
		attack = random_ranged_attack()
	else: 
		attack = random_melee_attack()
	if attack != null:
		attack.attack()
		attack_finished = false
		get_tree().create_timer(attack.attack_duration).connect("timeout", Callable(self, "attack_is_finished"))
		get_tree().create_timer(attack.attack_duration + randf_range(0.5, 2)).connect("timeout", Callable(self, "enable_attack"))

func create_spacing():
	var desired_move_direction = actor.direction_to_player() * -1
	var desired_x = desired_move_direction.x + (50 * actor.facing_direction.x)
	var desired_y = actor.global_position.y
	
	actor.move_towards_point(Vector2(desired_x, desired_y), actor.stats.chase_speed)

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
	
func attack_is_finished():
	attack_finished = true

func use_attack(animation, duration):
	actor.set_animation_state(animation)
	can_attack = false
