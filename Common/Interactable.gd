extends Area2D
class_name Interactable

@onready var interaction_icon = $InteractionIcon

func interact(actor):
	pass

func set_interaction_visibility(visible):
	interaction_icon.visible = visible
