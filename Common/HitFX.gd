extends Node2D

func _ready():
	$AnimatedSprite2D.frame = 0
	$AnimatedSprite2D.playing = true

func _on_animated_sprite_2d_animation_finished():
	queue_free()
