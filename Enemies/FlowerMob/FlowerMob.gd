extends CharacterBody2D

@export var move_speed : float = 180.0
@export var jump_velocity : float = 635.0
@export var health : int = 1

@onready var animator = $AnimatedSprite2D
@onready var state_machine = $FlowerFSM
@onready var alert_icon = $AlertIcon
@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var hurtbox = $Hurtbox
@onready var hitbox_collision = $Hitbox/CollisionShape2D

var spawn_position : Vector2
var target : CharacterBody2D = null
var is_dead : bool = false

func _ready():
	spawn_position = global_position

func _physics_process(delta):
	apply_gravity(delta)
	if is_on_wall() && is_on_floor(): # Todo: detect wall in facing direction further away and compare with target y location.
		jump()
	move_and_slide()

func move_towards_point(point):
	velocity.x = global_position.direction_to(point).x * move_speed

func jump():
	velocity.y -= jump_velocity

func distance_to_target():
	return 0 if target == null else global_position.distance_to(target.global_position)
	
func direction_to_target():
	return Vector2.ZERO if target == null else global_position.direction_to(target.global_position)
	
func distance_to_spawn():
	return global_position.distance_to(spawn_position)
	
func direction_to_spawn():
	return global_position.direction_to(spawn_position)
	
func apply_gravity(delta):
	velocity.y += gravity * delta
	
func set_animation_state(state):
	animator.animation = state

func attack():
	hitbox_collision.disabled = false
	await get_tree().create_timer(.2).timeout
	hitbox_collision.disabled = true

func _on_player_detected(body):
	if target == null:
		target = body
		alert_icon.visible = true
		await get_tree().create_timer(.3).timeout
		alert_icon.visible = false

func _on_take_damage(area):
	health -= area.damage
	is_dead = health <= 0
	if is_dead: 
		hurtbox.disconnect("area_entered", Callable(self, "_on_take_damage"))
	_play_damage_effect()

func _play_damage_effect():
	var old_animation = animator.animation
	
	set_animation_state("hit")
	
	if is_dead:
		set_animation_state("death")
	else: 
		set_animation_state(old_animation)
