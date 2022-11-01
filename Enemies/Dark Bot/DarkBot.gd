extends CharacterBody2D

@onready var stats = preload("res://Enemies/Dark Bot/DarkBotStats.tres")
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree["parameters/playback"]
@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var start_position : Vector2 = position

func _physics_process(delta):
	move_and_slide()

func apply_gravity(delta):
	velocity.y += gravity * delta
	
func direction_to(target) -> Vector2:
	return (target - global_position).normalized()
	
func set_animation_state(state):
	state_machine.travel(state)
