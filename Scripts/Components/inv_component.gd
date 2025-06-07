@icon("res://Assets/IconGodotNode/node/icon_gem.png")
extends Node
class_name inventory_component

@export var minor_souls_count : int = 0
@export var major_souls_count : int = 0

@export var upgrades : Array[BaseBulletStrategy] = []

@onready var body : CharacterBody2D = owner

func soul_quota(quota : int) -> bool:
	if minor_souls_count >= quota: return true
	else: return false

func apply_upgrades(item : Node2D):
	if !item: return false
	
	for strategy in upgrades:
		strategy.apply_upgrade(item)

func drop_inv():
	for i in minor_souls_count:
		soul_manager.spawn_minor_soul(body.get_nearby_position(100), get_tree().current_scene)
