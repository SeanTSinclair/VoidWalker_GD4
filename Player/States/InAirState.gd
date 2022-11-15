extends State

const SPEED = 300.0
const MAX_SPEED = 500.0
const COYOTE_TIME : float = 0.2
const JUMP_BUFFER : float = 0.2

@onready var coyote_timer = $CoyoteTimer
@onready var jump_buffer_timer = $JumpBufferTimer

var states = null

func enter_state(parent):
	super.enter_state(parent)
	if state_machine.previous_state != state_machine.states.jump:
		coyote_timer.start(COYOTE_TIME)

func state_logic(delta):
	super.state_logic(delta)
	var input_axis = state_machine.get_input_axis()
	actor.velocity.x += input_axis.x * SPEED
	actor.velocity.x = clamp(actor.velocity.x, -MAX_SPEED, MAX_SPEED)
	
	var vertical_velocity = actor.velocity.normalized().y
	if vertical_velocity < -0.1:
		actor.set_animation_state("jump_up")
	elif vertical_velocity > -0.1 && vertical_velocity < 0.1 && !actor.is_on_floor():
		actor.set_animation_state("jump_apex")
	elif vertical_velocity > 0.1:
		actor.set_animation_state("fall")
		
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer.start(JUMP_BUFFER)
	
	if !state_machine.is_on_floor && !state_machine.is_dashing:
		actor.apply_gravity(delta)
	
func check_transitions():
	super.check_transitions()
	if states == null:
		states = state_machine.states
	var is_on_floor = state_machine.is_on_floor
	
	if is_on_floor:
		state_machine.dash_count = 0
		if jump_buffer_timer.time_left == 0:
			actor.set_animation_state("land")
			set_state(states.idle)
		else: 
			set_state(states.jump)
	elif Input.is_action_just_pressed("dash") && state_machine.dash_count < actor.stats.max_dashes:
		state_machine.dash_count += 1
		set_state(states.dash)
	elif Input.is_action_just_pressed("primary_attack"):
		if state_machine.get_input_axis().y > 0.5 && state_machine.can_air_attack:
			set_state(states.air_attack)
		else: 
			set_state(states.attack)
	elif Input.is_action_just_pressed("jump") && coyote_timer.time_left != 0:
		set_state(states.jump)
	elif Input.is_action_just_pressed("block"):
		set_state(states.block)
