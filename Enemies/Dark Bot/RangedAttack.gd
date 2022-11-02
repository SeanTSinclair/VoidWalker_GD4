extends Attack

func attack(performed_by):
	performed_by.set_animation_state("shoot")
