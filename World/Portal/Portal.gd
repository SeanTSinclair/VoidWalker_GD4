extends Node2D

@export var reversible : bool = true
@export var start_offset : float = -100
@export var end_offset : float = 100

var start_portal_position : Vector2
var end_portal_position : Vector2

func _ready():
	start_portal_position = $StartPortal.global_position + Vector2(start_offset, 0)
	end_portal_position = $EndPortal.global_position + Vector2(end_offset, 0)

func _on_start_portal_body_entered(body):
	body.global_position = end_portal_position
	
func _on_end_portal_body_entered(body):
	if reversible:
		body.global_position = start_portal_position
