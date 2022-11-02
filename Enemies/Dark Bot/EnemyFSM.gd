extends StateMachine
class_name EnemyFSM

@onready var wander_timer = $WanderTimer

var is_wandering : bool = false
var target = null

func _ready():
	initialize()
	call_deferred("set_state", states.idle, states.idle)
	wander_timer.start(randf_range(1.0,4.0))
	
func _on_wander_timer_timeout():
	wander_timer.start(randf_range(1.0,4.0))
	is_wandering = randi_range(0, 10) > 5
