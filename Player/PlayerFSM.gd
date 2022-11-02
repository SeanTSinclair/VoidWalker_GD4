extends StateMachine

const JUMP_BUFFER : float = 0.2
const COYOTE_TIME : float = 0.2

@onready var player = owner
@onready var coyote_timer = $CoyoteTimer
@onready var jump_buffer_timer = $JumpBufferTimer

var is_dashing : bool = false
var dash_count : int = 0
var is_on_floor : bool = false
var can_jump : bool = true

func _ready():
	initialize()
	set_state(states.idle, states.idle)
	
func _physics_process(delta):
	super._physics_process(delta)
	
	var input_axis = get_input_axis()
	is_on_floor = player.is_on_floor()
	
	set_player_orientation(input_axis)
	
func set_player_orientation(input_axis):
	if input_axis.x < 0:
		player.set_flipped(true)
	elif input_axis.x > 0:
		player.set_flipped(false)
		
func facing_direction() -> Vector2:
	return Vector2.LEFT if player.sprite.flip_h else Vector2.RIGHT

func get_input_axis() -> Vector2:
	var input_axis = Vector2.ZERO
	input_axis.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	input_axis.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	return input_axis.normalized()
