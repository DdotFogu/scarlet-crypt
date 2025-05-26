class_name Bullet
extends CharacterBody2D

@export var hurtbox : Hitbox

@export var speed := 150.0
@export var max_pierce := 1

var current_pierce_count := 0
var angle : float
var direction : Vector2

func _ready():
	if hurtbox:
		hurtbox.hit_enemy.connect(on_enemy_hit)

func _physics_process(delta: float) -> void:
	direction = Vector2.RIGHT.rotated(angle)
	
	velocity = direction*(speed * 5)
	
	var collision := move_and_collide(velocity*delta)
	
	if collision:
		var collider = collision.get_collider()
		
		if collider.is_in_group("Wall"):
			var new_particles = particle_manager.spawn_particle(["soul debris", "dust"], get_tree().current_scene, global_position, 3)
			
			for particle in new_particles:
				particle.direction = -direction
			
			queue_free()

func on_enemy_hit():
	current_pierce_count += 1
	
	if current_pierce_count >= max_pierce:
		var new_particles = particle_manager.spawn_particle(["soul debris", "dust"], get_tree().current_scene, global_position, 3)
		
		for particle in new_particles:
			particle.direction = -direction
		
		queue_free()
