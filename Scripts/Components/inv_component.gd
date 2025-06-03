@icon("res://Assets/IconGodotNode/node/icon_gem.png")
extends Node
class_name inventory_component

@export var minor_souls_count : int = 0
@export var major_souls_count : int = 0

@export var upgrades : Array[BaseBulletStrategy] = []

var body : CharacterBody2D

func _ready() -> void:
	body = owner

func apply_upgrades(item : CharacterBody2D):
	for strategy in upgrades:
			strategy.apply_upgrade(item)

func drop_inv():
	for i in minor_souls_count:
		soul_manager.spawn_minor_soul(body.global_position, get_tree().current_scene)
