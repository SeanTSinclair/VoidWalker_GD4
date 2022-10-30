extends Node

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree["parameters/playback"]

func set_animation_state(state):
	state_machine.travel(state)

func process_player_behaviour(velocity, is_dashing, is_on_floor):
	if velocity.x != 0: 
		state_machine.travel("walk")
		
	if velocity.x == 0:
		state_machine.travel("idle")
		
	if is_dashing: 
		state_machine.travel("dash")
		
	if !is_on_floor:
		var player_velocity = velocity.normalized().y
		if player_velocity > 0 && state_machine.get_current_node() != "jump_up":
			state_machine.travel("fall")
		elif player_velocity < 0:
			state_machine.travel("jump_up")
		elif player_velocity > 0:
			state_machine.travel("jump_apex")
