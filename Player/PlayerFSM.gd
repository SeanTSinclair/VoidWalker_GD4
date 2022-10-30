extends StateMachine

const DASH_SPEED = 800.0

@onready var player = owner

var dash_time : int = 0
var has_dashed : bool = false
var is_dashing : bool = false
var is_on_floor : bool = false

func _ready():
	initialize()
	set_state(states.idle)
	
func tick(delta):
	
	var input_axis = get_input_axis()
	is_on_floor = player.is_on_floor()
	
	set_player_orientation(input_axis)
		
	dash(delta, input_axis)

func transition_logic():
	if current_state == states.idle:
		idle_transitions()
	elif current_state == states.move:
		move_transitions()
	elif current_state == states.jump:
		jump_transitions()
	elif current_state == states.in_air:
		in_air_transitions()
	
	set_state(current_state)

func dash(delta, input_axis):
	if !has_dashed:
		if Input.is_action_just_pressed("dash"):
			player.velocity = input_axis * DASH_SPEED
			Input.start_joy_vibration(0, 1, .4, 0.2)
			is_dashing = true
			has_dashed = true
			
	if is_dashing:
		dash_time += 1
		if dash_time >= int(0.25 * 1 / delta):
			is_dashing = false
			dash_time = 0
	
	if is_on_floor && player.velocity.y >= 0:
		has_dashed = false

func idle_transitions():
	if !is_dashing && get_input_axis() != Vector2.ZERO:
		current_state = states.move
	if Input.is_action_just_pressed("jump") && is_on_floor:
		current_state = states.jump
	if !is_on_floor:
		current_state = states.in_air
	
func move_transitions():
	if !is_dashing && get_input_axis() == Vector2.ZERO:
		current_state = states.idle
	if Input.is_action_just_pressed("jump") && is_on_floor:
		current_state = states.jump
	if !is_on_floor:
		current_state = states.in_air
	
func jump_transitions():
	current_state = states.in_air
	
func in_air_transitions():
	pass
	
func set_player_orientation(input_axis):
	if input_axis.x < 0:
		player.set_flipped(true)
	elif input_axis.x > 0:
		player.set_flipped(false)

func get_input_axis() -> Vector2:
	var input_axis = Vector2.ZERO
	input_axis.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	input_axis.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	return input_axis.normalized()
