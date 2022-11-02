extends Node
class_name State

@export var state_name : String

var actor = null
var state_machine = null

func state_logic(delta):
	if actor == null || state_machine == null:
		return
	
func check_transitions():
	if actor == null || state_machine == null:
		return
	
func set_state(state):
	state_machine.set_state(self, state)
	
func enter_state(actor):
	self.actor = actor
	
func exit_state():
	actor = null
