@icon("res://Assets/IconGodotNode/color/icon_weapon.png")
class_name Hitbox
extends Area2D

signal enemy_hit

@export_category("Hitbox")
@export var killer : CharacterBody2D # Who did the damage in the event
@export var damage : int
@export var knockback_force : int
@export var stun_time : float
@export var status_effects : Array[BaseEffectStrategy] = []
@export var target_group : String = "Enemy"
@export var rebounce : bool = false # apply knockback to the kill in event if true

func _init() -> void:
	collision_layer = 8
	collision_mask = 0

func set_rotation_to_velocity():
	rotation = killer.velocity.angle()
	return rotation

func set_rotation_to_mouse():
	rotation = global_position.direction_to(get_global_mouse_position()).angle()
