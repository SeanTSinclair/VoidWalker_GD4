extends Node
class_name Attack

signal finished

var ranged : bool = false

func attack(performed_by):
	pass
	
func attack_finished():
	emit_signal("finished")
