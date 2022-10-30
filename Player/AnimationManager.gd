extends Node

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree["parameters/playback"]

func set_animation_state(state):
	state_machine.travel(state)
