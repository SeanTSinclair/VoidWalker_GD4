extends Resource
class_name PlayerStats


@export var friction : float = 300

# Dash
@export var dash_speed : float = 800
@export var max_dashes : int = 3

# Jump
@export var jump_height : float = 200
@export var time_to_reach_peak : float = 0.4
@export var time_to_descent : float = 0.5
