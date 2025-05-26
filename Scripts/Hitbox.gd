class_name Hitbox
extends Area2D

signal hit_enemy

@export var killer : CharacterBody2D # Who did the damage in the event
@export var damage : int
@export var knockback_force : int
@export var stun_time : float
@export var target_group : String = "Enemy"

@export var rebounce : bool = false # apply knockback to the kill in event if true

func _init() -> void:
	collision_layer = 8
	collision_mask = 0
