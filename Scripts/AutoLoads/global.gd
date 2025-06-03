extends Node

var rng = RandomNumberGenerator.new()
var current_camera : Camera2D
var dungeon_generation : Node
var player : Player
var projectile_attacks : Dictionary = {"soul" : preload("res://Scene/Projectiles/SoulProjectile.tscn")}

func _process(delta: float) -> void:
	current_camera = get_viewport().get_camera_2d()

func camera_transition():
	get_tree().paused = true
	
	Hud.get_node("Transitions/AnimationPlayer").play("Transition_One")
	await Hud.get_node("Transitions/AnimationPlayer").animation_finished
	Hud.get_node("Transitions/AnimationPlayer").play_backwards("Transition_One")
	
	return true

func change_scene(scene_path : String):
	get_tree().change_scene_to_file(scene_path)
