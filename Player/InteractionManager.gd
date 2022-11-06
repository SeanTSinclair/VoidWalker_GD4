extends Node2D

var interaction_objects : Array[Interactable] = []
var selected_interactable : Interactable = null

func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		if selected_interactable != null:
			selected_interactable.interact(owner)
			update_selected()
			
func update_selected():
	if selected_interactable != null:
		selected_interactable.set_interaction_visibility(false)
		
	if interaction_objects.size() == 1:
		selected_interactable = interaction_objects[0]
		selected_interactable.set_interaction_visibility(true)
	elif interaction_objects.size() > 1:
		selected_interactable = get_closest_interactable()
		selected_interactable.set_interaction_visibility(true)
		
func get_closest_interactable() -> Interactable:
	var nearest = interaction_objects[interaction_objects.size()]
	for interactable in interaction_objects:
		if interactable.position.distance_to(position) < nearest.position.distance_to(position):
			nearest = interactable
	return nearest

func _on_interaction_area_area_entered(area):
	if area is Interactable:
		interaction_objects.append(area)
		update_selected()

func _on_interaction_area_area_exited(area):
	interaction_objects.remove_at(interaction_objects.find(area))
	if area == selected_interactable:
		selected_interactable.set_interaction_visibility(false)
		selected_interactable = null
	update_selected()
