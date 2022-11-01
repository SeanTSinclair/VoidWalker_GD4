extends State

@onready var wander_targets : Array[Vector2] = []

var target = null
var stopping_distance = 5

func _ready():
	for child in get_children():
		wander_targets.append(child.global_position)
		child.queue_free()

func enter_state(actor):
	super.enter_state(actor)
	actor.set_animation_state("run")
	wander_targets.shuffle()
	target = wander_targets[0]
	
func exit_state():
	super.exit_state()
	target = null

func state_logic(delta):
	super.state_logic(delta)
	actor.velocity.x = actor.direction_to(target).x * actor.stats.move_speed
	
func check_transitions():
	super.check_transitions()
	if actor.position.distance_to(target) <= stopping_distance:
		if state_machine.is_wandering:
			set_state(state_machine.states.wander)
		else:
			set_state(state_machine.states.idle)
