@icon("res://Assets/IconGodotNode/node/icon_bullet.png")
extends CharacterBody2D
class_name projectile_base

@export var stat_sheet : StatSheet
@export var lifetime : float = 10

@export_category("Refrences")
@export var velocity_component : velocity_component

func _ready() -> void:
	await get_tree().create_timer(lifetime).timeout
	queue_free()
