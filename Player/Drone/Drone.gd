extends CharacterBody2D

@export var player : CharacterBody2D
@export var min_vertical_position : float = 60.0
@export var max_vertical_position : float = 90.0
@export var vertical_move_speed : float = 100.0
@export var vertical_friction : float = 80.0

@onready var animation = $AnimatedSprite2D
@onready var weapon = $Weapon
@onready var projectile_spawn = $ProjectileSpawnPosition

func _physics_process(delta):
	if player == null: return
	set_vertical_position()
	if Input.is_action_just_pressed("secondary_attack"):
		attack()
	move_and_slide()

func attack():
	weapon.shoot(projectile_spawn.global_position, direction_to_mouse())

func set_vertical_position():
	var vertical_distance_to_player = player.position.y - position.y
	if vertical_distance_to_player > max_vertical_position:
		velocity.y = vertical_move_speed
	elif vertical_distance_to_player < min_vertical_position:
		velocity.y = -vertical_move_speed
	else:
		velocity.y = move_toward(velocity.y, 0, vertical_friction)
	
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
