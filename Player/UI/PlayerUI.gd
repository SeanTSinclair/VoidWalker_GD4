extends Control

@onready var stats = preload("res://Player/PlayerStats.tres")
@onready var health_bar = $CanvasLayer/TopRow/HealthBar

func _ready():
	stats.connect("health_changed", Callable(self, "update_hp"))
	update_hp()
	
func update_hp():
	health_bar.display_health(stats.health, stats.max_health)
