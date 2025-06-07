@icon("res://Assets/IconGodotNode/node/icon_sword.png")
extends Node2D
class_name player_weapon_component

@export_category("Refrences")
@export var inventory_component : inventory_component

@export_category("Scyth Vars")
@export var scyth_hitbox : Hitbox
@export var scythe_anim_player : AnimationPlayer

@export_category("Projectile Vars")
@export var spawn_marker : Marker2D

@onready var body : CharacterBody2D = owner

func fire_projectile(projectile : String):
	if !inventory_component.soul_quota(1): return
	inventory_component.minor_souls_count -= 1
	
	var instance_projectile = Global.projectile_attacks[projectile].instantiate()
	instance_projectile.global_position = spawn_marker.global_position
	var velocity_component = instance_projectile.get_node("VelocityComponent")
	if velocity_component: velocity_component.set_direction(body.global_position.direction_to(get_global_mouse_position()))
	
	inventory_component.apply_upgrades(instance_projectile)
	
	get_tree().current_scene.add_child(instance_projectile)

func swing_sycth():
	if scythe_anim_player.is_playing(): return
	inventory_component.apply_upgrades(scyth_hitbox)
	scythe_anim_player.play("attack")
