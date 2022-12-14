extends Node
class_name State

@export var state_name : String
@export var unlocked : bool = true

var actor = null
var state_machine = null

func state_logic(_delta):
	if actor == null || state_machine == null:
		return
	
func check_transitions():
	if actor == null || state_machine == null:
		return
	
func set_state(state):
	state_machine.set_state(self, state)
	
func enter_state(parent):
	self.actor = parent
	
func exit_state():
	actor = null
