extends CharacterBody2D
class_name NpcCharacterBase

@export var stat_sheet : StatSheet

func _ready() -> void:
	Debugger.character_array.append(self)

func get_nearby_position(radius : float):
	var rand_pos = global_position + Vector2(Global.rng.randf_range(-radius, radius), Global.rng.randf_range(-radius, radius))
	return rand_pos

func reset_detection():
	for child in get_children():
		if child is target_dectection:
			child.get_child(0).disabled = false
