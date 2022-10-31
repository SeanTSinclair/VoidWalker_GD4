extends Area2D
class_name Projectile

@export var lifetime : float = 8.0
@export var speed : float = 500.0

var direction : Vector2 = Vector2.ZERO

func _ready():
	rotation = position.angle_to(direction)	
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _physics_process(delta):
	position += direction * speed * delta
