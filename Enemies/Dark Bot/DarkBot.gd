extends CharacterBody2D

@onready var sprite = $Sprite2D
@onready var stats = preload("res://Enemies/Dark Bot/DarkBotStats.tres")
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree["parameters/playback"]
@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var start_position : Vector2 = position

var facing_direction = Vector2.RIGHT

func _physics_process(delta):
	move_and_slide()

func apply_gravity(delta):
	velocity.y += gravity * delta
	
func set_facing_direction(direction):
	if direction == Vector2.LEFT:
		sprite.flip_h = true
		sprite.offset = Vector2(-53, 0)
	elif direction == Vector2.RIGHT:
		sprite.flip_h = false
		sprite.offset = Vector2(0, 0)
	facing_direction = direction
	
func direction_to(target) -> Vector2:
	return (target - global_position).normalized()
	
func set_animation_state(state):
	state_machine.travel(state)
