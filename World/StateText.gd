extends Label

func _on_state_machine_state_changed(new_state):
	text = new_state.state_name
