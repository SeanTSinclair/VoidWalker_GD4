extends Node
class_name State

@export var state_name : String

var actor = null
var state_machine = null

func state_logic(delta):
	pass
	
func check_transitions():
	pass
	
func set_state(state):
	state_machine.set_state(state)
	
func enter_state(actor):
	self.actor = actor
	
func exit_state():
	actor = null
