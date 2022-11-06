extends CharacterBody2D

signal dead
signal take_damage(current_health)

@onready var stats = preload("res://Player/PlayerStats.tres")
@onready var animation_manager = $AnimationManager
@onready var sprite = $Sprite2D
@onready var hitbox = $Hitbox

@onready var jump_gravity : float = ((-2.0 * stats.jump_height) / (stats.time_to_reach_peak * stats.time_to_reach_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * stats.jump_height) / (stats.time_to_reach_peak * stats.time_to_reach_peak)) * -1.0

func set_flipped(is_flipped):
	if is_flipped: 
		sprite.flip_h = true
		sprite.offset = Vector2(-17, 0)
		hitbox.scale.x = -1
	else:
		sprite.flip_h = false
		sprite.offset = Vector2(17, 0)
		hitbox.scale.x = 1
		
func set_animation_state(state):
	animation_manager.set_animation_state(state)

func _physics_process(delta):
	move_and_slide()
	
func apply_gravity(delta):
	velocity.y += get_gravity() * delta

func get_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity

func _on_hurtbox_area_entered(area):
	stats.health -= area.damage
	Input.start_joy_vibration(0, 1, .4, 0.2)
	emit_signal("take_damage", stats.health)
	if stats.health <= 0:
		emit_signal("dead")
		print("I am dead now")
