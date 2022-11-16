extends State

@export var min_attack_delay : float = 2.0

var can_attack : bool = true

func enter_state(parent):
	super.enter_state(parent)
	can_attack = false
	actor.attack()
	actor.set_animation_state("attack")
	actor.animator.connect("animation_finished", Callable(self, "attack_finished"))
	await get_tree().create_timer(min_attack_delay).timeout
	print("Can attack again!")
	can_attack = true
	
func exit_state():
	super.exit_state()
	actor.animator.disconnect("animation_finished", Callable(self, "attack_finished"))

func attack_finished():
	set_state(state_machine.states.chase)
