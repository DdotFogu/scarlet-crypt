@icon("res://Assets/IconGodotNode/node/icon_sword.png")
extends Node2D
class_name weapon_component

@export_category("Refrences")
@export var inventory_component : inventory_component

@export_category("Projectile Vars")
@export var spawn_marker : Marker2D
@onready var body : CharacterBody2D = owner

func fire_projectile(projectile : String):
	var instance_projectile = Global.projectile_attacks[projectile].instantiate()
	instance_projectile.global_position = spawn_marker.global_position
	var velocity_component = instance_projectile.get_node("VelocityComponent")
	if velocity_component: velocity_component.set_direction(body.global_position.direction_to(get_global_mouse_position()))
	
	inventory_component.apply_upgrades(instance_projectile)
	
	get_tree().current_scene.add_child(instance_projectile)
