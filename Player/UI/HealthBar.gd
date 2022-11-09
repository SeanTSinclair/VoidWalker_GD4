extends HBoxContainer

@onready var hp_icons : Array[Texture2D] = [
	preload("res://Player/UI/health_bar_icon_empty.png"),
	preload("res://Player/UI/health_bar_icon_low.png"),
	preload("res://Player/UI/health_bar_icon.png")]

@onready var hp_icon : PackedScene = preload("res://Player/UI/HPIcon.tscn")

func _ready():
	display_health(3, 3)

func display_health(current_health, max_health):
	clear_current_ui()
	var current_icon = 0
	var current_texture = hp_icons[2]
	while current_icon < max_health:
		if current_health / max_health <= 0.4:
			current_texture = hp_icons[1]
		
		if current_icon > current_health-1:
			current_texture = hp_icons[0]
		elif current_icon < max_health-1:
			current_texture = hp_icons[2]
		var icon = hp_icon.instantiate()
		icon.texture = current_texture
		add_child(icon)
		current_icon += 1
#
func clear_current_ui():
	for child in get_children():
		child.queue_free()
