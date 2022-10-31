extends Resource
class_name PlayerStats

# Movement
@export var move_speed : float = 300.0
@export var run_speed : float = 350.0
@export var friction : float = 300.0

# Dash
@export var dash_speed : float = 800.0
@export var max_dashes : int = 3

# Jump
@export var jump_height : float = 200.0
@export var time_to_reach_peak : float = 0.4
@export var time_to_descent : float = 0.5
