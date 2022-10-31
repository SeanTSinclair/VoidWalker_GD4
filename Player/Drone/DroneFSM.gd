extends StateMachine

func _ready():
	initialize()
	set_state(states.idle)
	
func _physics_process(delta):
	super._physics_process(delta)
	
