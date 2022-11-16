extends Area2D

signal invincibility_started
signal invincibility_ended

var invincible : bool = false

@onready var timer = $Timer
@onready var collision_shape = $CollisionShape2D

func set_invincible(value: bool):
	invincible = value
	if invincible:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")
		
func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)

func _on_timer_timeout():
	self.invincible = false

func _on_invincibility_started():
	set_deferred("monitorable", false) # Set deferred could mean that another collision could occurr before the monitoring property is changed 
	collision_shape.set_deferred("disabled", true)

func _on_invincibility_ended():
	monitorable = true
	collision_shape.disabled = false
