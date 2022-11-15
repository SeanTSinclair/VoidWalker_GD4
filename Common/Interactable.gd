extends Area2D
class_name Interactable

@onready var interaction_icon = $InteractionIcon

func interact(_actor):
	pass

func set_interaction_visibility(visibility):
	interaction_icon.visible = visibility
