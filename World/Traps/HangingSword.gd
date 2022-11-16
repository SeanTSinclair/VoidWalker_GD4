extends Node2D

@onready var animated_sprite = $AnimatedSprite2D

var is_falling : bool = false
var is_stuck : bool = false
var fall_speed : float = 600.0

func _physics_process(delta):
	if is_falling && !is_stuck:
		position.y += fall_speed * delta

func _on_player_detected(_body):
	set_deferred("disabled", $PlayerDetection/CollisionShape2D)
	animated_sprite.animation = "snap"
	animated_sprite.connect("animation_finished", Callable(self, "snap_finished"))
	
func snap_finished():
	is_falling = true
	animated_sprite.animation = "fall"

func _on_hitbox_body_entered(body):
	if body is TileMap:
		is_falling = false
		is_stuck = true
		animated_sprite.animation = "stuck"
		$PlayerDetection.disconnect("body_entered", Callable(self, "_on_player_detected"))
		$Hitbox.queue_free()

func _on_visible_on_screen_notifier_2d_screen_entered():
	animated_sprite.playing = true

func _on_visible_on_screen_notifier_2d_screen_exited():
	if is_stuck: 
		queue_free()
	else: 
		animated_sprite.playing = false
