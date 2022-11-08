extends StateMachine

@onready var player = owner

var is_dashing : bool = false
var dash_count : int = 0
var is_on_floor : bool = false
var can_jump : bool = true
var can_air_attack : bool = true
var is_taking_damage : bool = false
var is_reading_input : bool = true

func _ready():
	initialize()
	set_state(states.idle, states.idle)
	
func _physics_process(delta):
	super._physics_process(delta)
	
	var input_axis = get_input_axis()
	is_on_floor = player.is_on_floor()
	
	set_player_orientation(input_axis)
	set_deferred("is_taking_damage", false)
	
func set_player_orientation(input_axis):
	if input_axis.x < 0:
		player.set_flipped(true)
	elif input_axis.x > 0:
		player.set_flipped(false)
		
func facing_direction() -> Vector2:
	return Vector2.LEFT if player.sprite.flip_h else Vector2.RIGHT
	
func input_enabled(enabled):
	is_reading_input = enabled

func get_input_axis() -> Vector2:
	var input_axis = Vector2.ZERO
	if is_reading_input:
		input_axis.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
		input_axis.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	return input_axis.normalized()
