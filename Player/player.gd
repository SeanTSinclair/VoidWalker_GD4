extends CharacterBody2D

@onready var stats = preload("res://Player/PlayerStats.tres")
@onready var state_machine = $StateMachine
@onready var animation_manager = $AnimationManager
@onready var sprite = $Sprite2D

func set_flipped(is_flipped):
	if is_flipped: 
		sprite.flip_h = true
		sprite.offset = Vector2(-17, 0)
	else:
		sprite.flip_h = false
		sprite.offset = Vector2(17, 0)
		
func set_animation_state(state):
	animation_manager.set_animation_state(state)

func _physics_process(delta):
	move_and_slide()
