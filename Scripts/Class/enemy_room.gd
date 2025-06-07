@icon("res://Assets/IconGodotNode/node/icon_map.png")
extends base_room
class_name enemy_room

@export_category("Refrences")
@export var enemy_component : enemy_generation

func _ready() -> void:
	SignalBus.Enetered_Room.connect(enemy_component.spawn_enemies)
