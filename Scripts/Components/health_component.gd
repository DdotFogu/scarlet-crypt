extends Node
class_name health_component

var health : int
var last_attack : Attack

@export var sprite_animation : AnimationPlayer
@export var character_body : CharacterBody2D

func _ready() -> void:
	health = character_body.stat_sheet.health

func take_damage(attack:Attack):
	#apply cam shake
	var current_cam = get_viewport().get_camera_2d()
	if current_cam.has_node("CameraShake"):
		current_cam.get_node("CameraShake").apply_shake(15)
	
	#play hurt animation
	if sprite_animation:
		sprite_animation.play("Hurt")
	
	last_attack = attack
	
	# Reduce health
	health -= attack.damage
	
	# Find direction of killer and apply knockback
	var direction = attack.killer.position.direction_to(character_body.global_position)
	character_body.velocity += direction * attack.knockback_force * 80
	
	PopupManager.spawn_dmg_popup(attack, character_body)
	
	if health <= 0:
		die()
	else:
		var particles = particle_manager.spawn_particle(["hit dust"], character_body)
		for particle in particles:
			particle.direction = direction

func die():
	Debugger.character_array.erase(self)
	
	if sprite_animation:
		sprite_animation.play("Death")
	
	await get_tree().create_timer(0.3).timeout
	var particles = particle_manager.spawn_particle(["death dust"], get_tree().current_scene, character_body.global_position)
	
	# apply camera shake
	var current_cam = get_viewport().get_camera_2d()
	if current_cam.has_node("CameraShake"):
		current_cam.get_node("CameraShake").apply_shake(15)
	
	character_body.queue_free()
