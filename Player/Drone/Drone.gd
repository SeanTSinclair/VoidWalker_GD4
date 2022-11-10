extends CharacterBody2D

@export var player : CharacterBody2D
@export var min_vertical_position : float = 60.0
@export var max_vertical_position : float = 90.0
@export var move_speed : float = 100.0
@export var friction : float = 80.0

@onready var animation = $AnimatedSprite2D
@onready var weapon = $Weapon
@onready var projectile_spawn = $ProjectileSpawnPosition

var is_being_controlled : bool = false

func _physics_process(delta):
	if player == null: return
	if !is_being_controlled:
		set_vertical_position()
	else:
		var input_vector = get_input_axis()
		velocity = input_vector * move_speed
	move_and_slide()

func remote_control():
	is_being_controlled = true
	
func remove_remote_control():
	is_being_controlled = false

func attack():
	weapon.shoot(projectile_spawn.global_position, direction_to_mouse())

func set_vertical_position():
	var vertical_distance_to_player = player.position.y - position.y
	if vertical_distance_to_player > max_vertical_position:
		velocity.y = move_speed
	elif vertical_distance_to_player < min_vertical_position:
		velocity.y = -move_speed
	else:
		velocity.y = move_toward(velocity.y, 0, friction)
	
func set_animation_state(state):
	animation.play(state)
	
func direction_to_mouse() -> Vector2:
	return (get_global_mouse_position() - global_position).normalized()
	
func direction_to_player() -> Vector2:
	if player == null: return Vector2.ZERO
	return position.direction_to(player.position)

func distance_to_player() -> float:
	if player == null: return 0.0
	return position.distance_to(player.position)

func get_input_axis() -> Vector2:
	var input_axis = Vector2.ZERO
	input_axis.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	input_axis.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	return input_axis.normalized()

