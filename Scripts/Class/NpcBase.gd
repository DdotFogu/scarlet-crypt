@icon("res://Assets/IconGodotNode/node/icon_character.png")
extends CharacterBody2D
class_name base_npc

@export var stat_sheet : StatSheet

func _ready() -> void:
	Debugger.character_array.append(self)

func _physics_process(_delta):
	if !stat_sheet : return
	velocity.x = clamp(velocity.x, -stat_sheet.speed_cap, stat_sheet.speed_cap)
	velocity.y = clamp(velocity.y, -stat_sheet.speed_cap, stat_sheet.speed_cap)

func get_nearby_position(radius : float):
	var rnd_pos : Vector2 = Vector2(Global.rng.randf_range(-150, 150), Global.rng.randf_range(-150, 150))
	if rnd_pos: return rnd_pos

func reset_detection():
	for child in get_children():
		if child is target_dectection:
			child.get_child(0).disabled = false
