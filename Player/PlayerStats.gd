extends Resource
class_name PlayerStats

signal health_changed

# Movement
@export var move_speed : float = 300.0
@export var run_speed : float = 350.0
@export var friction : float = 300.0
@export var roll_speed : float = 500.0

# Dash
@export var dash_speed : float = 800.0
@export var max_dashes : int = 3

# Jump
@export var jump_height : float = 200.0
@export var time_to_reach_peak : float = 0.4
@export var time_to_descent : float = 0.5

# Character
@export var health : int = 3 : 
	set(value): 
		health = value
		emit_signal("health_changed")
@export var max_health : int = 3
@export var i_frame_duration : float = 0.25

func heal(amount):
	self.health = min(self.health + amount, max_health)
