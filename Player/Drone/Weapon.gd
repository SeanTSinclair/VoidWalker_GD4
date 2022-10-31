extends Node
class_name DroneWeapon

@export var projectile : PackedScene
@export var fire_delay : float = 1.0

var can_shoot : bool = true

func shoot(from, towards):
	if can_shoot: 
		var instanced_projectile = projectile.instantiate()
		instanced_projectile.position = from
		instanced_projectile.direction = towards
		get_tree().root.add_child(instanced_projectile)
		can_shoot = false
		await get_tree().create_timer(fire_delay).timeout
		can_shoot = true
