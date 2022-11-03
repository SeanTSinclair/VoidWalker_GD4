extends Node
class_name Attack

signal attacking(animation, duration)

@export var attack_duration = 2.0
@export var ranged : bool = false
@export var animation_name : String

func attack():
	emit_signal("attacking", animation_name, attack_duration)
