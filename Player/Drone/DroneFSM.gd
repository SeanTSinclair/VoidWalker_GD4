extends StateMachine

func _ready():
	initialize()
	set_state(states.idle, states.idle)
