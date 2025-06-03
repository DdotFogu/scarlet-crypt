@icon("res://Assets/IconGodotNode/color/icon_particle.png")
extends Node
class_name knockback_component

var body : CharacterBody2D

func _ready() -> void:
	body = get_parent()

func apply_knockback(attack : Attack):
	var attack_direction = attack.killer.global_position.direction_to(body.global_position)
	
	body.velocity = attack_direction * attack.knockback_force 
	
	if attack.rebounce: 
		attack.killer.velocity = -attack_direction * attack.knockback_force * 0.5
