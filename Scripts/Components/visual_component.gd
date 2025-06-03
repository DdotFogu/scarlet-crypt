@icon("res://Assets/IconGodotNode/node_2D/icon_character.png")
extends Node2D
class_name visual_component

@export_category("Refrences")
@export var sprite : Node2D
@export var sprite_animator : AnimationPlayer

@export_category("Particles")
@export var death_particle : Array[String] = ["death dust"]
@export var hit_particle : Array[String] = ["hit dust"]

var body : CharacterBody2D

func _ready() -> void:
	body = get_parent()

func play_animation(animation_name : String) -> bool:
	if sprite_animator.has_animation(animation_name) : 
		sprite_animator.play(animation_name)
	else: return false
	
	await sprite_animator.animation_finished
	return true

func spawn_particle(particles : Array[String], parent : Node = get_tree().current_scene, spawn_position : Vector2 = Vector2.ZERO, amount : int = 1):
	var new_particles = particle_manager.spawn_particle(particles, parent, spawn_position, amount)
	return new_particles

func spawn_hit_particle():
	await get_tree().create_timer(0.05).timeout
	var new_particles = spawn_particle(hit_particle, body)
	for particles in new_particles:
		particles.direction = body.velocity.normalized()

func spawn_death_particle():
	var new_particles = spawn_particle(death_particle, get_tree().current_scene, body.global_position, 1)
	for particles in new_particles:
		particles.direction = -body.velocity.normalized()


func _physics_process(delta: float) -> void:
	if !sprite: return
	
	if body.velocity.x > 0:
		sprite.flip_h = false
	elif body.velocity.x < 0:
		sprite.flip_h = true
