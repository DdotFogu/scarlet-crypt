extends Node

signal Enetered_Room(room_index : int)
signal Spawn_Particle(particle : Array[String], parent : Node2D, spawnpos : Vector2, amount : int)

func _ready() -> void:
	Spawn_Particle.connect(particle_manager.spawn_particle)
