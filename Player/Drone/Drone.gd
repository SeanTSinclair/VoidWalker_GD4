extends CharacterBody2D

@export var player : CharacterBody2D
@export var min_vertical_position : float = 60.0
@export var max_vertical_position : float = 90.0
@export var move_speed : float = 200.0
@export var friction : float = 80.0

@onready var animation = $AnimatedSprite2D
@onready var weapon = $Weapon
@onready var projectile_spawn = $ProjectileSpawnPosition
@onready var indicator = $Indicator
@onready var camera = $Camera2D

var is_being_controlled : bool = false

func _ready():
	if player != null:
		player.drone = self

func _physics_process(_delta):
	if player == null: return
	if !is_being_controlled:
		set_vertical_position()
	move_and_slide()

func move(direction):
	velocity = direction * move_speed
	
func rotate_indicator():
	indicator.rotation = position.angle_to_point(get_global_mouse_position())

func set_is_controlled(is_controlled):
	is_being_controlled = is_controlled

func attack():
	weapon.shoot(projectile_spawn.global_position, direction_to_mouse())
	
func camera_active(is_active):
	camera.current = is_active

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

