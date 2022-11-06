extends Area2D

@onready var raycast = $RayCast2D

@export var fall_speed : float = 500.0

var triggered : bool = false

func _process(delta):
	if raycast.is_colliding():
		triggered = true
		
	if triggered: 
		position.y += fall_speed * delta

func _on_body_entered(body):
	if triggered:
		queue_free()
