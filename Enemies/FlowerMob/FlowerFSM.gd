extends StateMachine

func _ready():
	initialize()
	call_deferred("set_state", states.idle, states.idle)

