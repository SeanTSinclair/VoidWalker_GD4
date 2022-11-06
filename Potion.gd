extends Interactable

@export_enum(MINOR, COMMON, MAJOR) var potion_type = 0

@onready var sprite = $Sprite2D
@onready var potion_icons : Array = [
	preload("res://World/Items/Potions/minor_health.png"), 
	preload("res://World/Items/Potions/common_health.png"), 
	preload("res://World/Items/Potions/major_health.png")]

var heal_amount = 1

func _ready():
	sprite.texture = potion_icons[potion_type]
	heal_amount = potion_type+1

func interact(actor):
	if actor.has_method("heal"):
		actor.heal(heal_amount)
		queue_free()
