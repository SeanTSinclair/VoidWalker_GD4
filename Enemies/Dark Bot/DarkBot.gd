extends CharacterBody2D

@export var health : int = 3

@onready var sprite = $Sprite2D
@onready var stats = preload("res://Enemies/Dark Bot/DarkBotStats.tres")
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree["parameters/playback"]
@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var start_position : Vector2 = position
@onready var line_of_sight_ray : RayCast2D= $VisionCast
@onready var target_ray : RayCast2D = $TargetCast
@onready var alert_icon : Sprite2D = $AlertIcon

var facing_direction : Vector2 = Vector2.RIGHT
var player_in_range : bool = false
var has_spotted_player : bool = false
var player = null

func _physics_process(delta):
	move_and_slide()
	update_facing_direction()
	if target_ray.enabled: 
		target_ray.target_position = player.global_position

func apply_gravity(delta):
	velocity.y += gravity * delta
	
func move_towards_point(point, speed):
	velocity.x = direction_to(point).x * speed
	
func update_facing_direction():
	if velocity.x < 0:
		facing_direction = Vector2.LEFT
		sprite.flip_h = true
		sprite.offset = Vector2(-53, 0)
	elif velocity.x > 0:
		facing_direction = Vector2.RIGHT
		sprite.flip_h = false
		sprite.offset = Vector2(0, 0)
		
func set_facing_direction(direction):
	if direction.x < 0: 
		facing_direction = Vector2.LEFT
		sprite.flip_h = true
		sprite.offset = Vector2(-53, 0)
	else: 
		facing_direction = Vector2.RIGHT
		sprite.flip_h = false
		sprite.offset = Vector2(0, 0)
		
func face_player():
	if direction_to_player().x > 0:
		set_facing_direction(Vector2.RIGHT)
	elif direction_to_player().x < 0:
		set_facing_direction(Vector2.LEFT)
		
func can_see_player() -> bool:
	return line_of_sight_ray.is_colliding()
	
func distance_to_player() -> float:
	return position.distance_to(line_of_sight_ray.get_collision_point())
	
func angle_to_player() -> float:
	return rad_to_deg(position.angle_to_point(target_ray.get_collision_point()))
		
func direction_to_player() -> Vector2:
	return (player.global_position - global_position).normalized()
		
func slow_to_stop():
	velocity.x = move_toward(velocity.x, 0, stats.friction)
		
func direction_to(target) -> Vector2:
	return (target - global_position).normalized()
	
func distance_to(target) -> float:
	return global_position.distance_to(target)
	
func set_animation_state(state):
	state_machine.travel(state)
	
func indicate_alert():
	alert_icon.visible = true
	await get_tree().create_timer(.3).timeout
	alert_icon.visible = false

func _on_detection_area_body_entered(body):
	player_in_range = true
	target_ray.enabled = true
	player = body
	
func _on_detection_area_body_exited(body):
	player_in_range = false
	target_ray.enabled = false
	player = null

func _on_hurtbox_area_entered(area):
	health -= area.damage
	# Knockback
	if health <= 0: 
		queue_free()
