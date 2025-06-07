extends Node

var rng = RandomNumberGenerator.new()
var current_camera : Camera2D
var dungeon_generation : dungeon_generation
var y_sort : Node2D
var player : Player
var GameInfo : CanvasLayer
var projectile_attacks : Dictionary = {"soul" : preload("res://Scene/Projectiles/SoulProjectile.tscn")}

func _process(delta: float) -> void:
	if get_tree().current_scene != null: y_sort = get_tree().current_scene.get_node("Ysort")
	current_camera = get_viewport().get_camera_2d()

func camera_transition():
	var animation_player = TransitionUi.get_node("AnimationPlayer")
	animation_player.play("Fade")
	await animation_player.animation_finished
	animation_player.play_backwards("Fade")
	
	return true

func change_scene(scene_path : String):
	get_tree().change_scene_to_file(scene_path)
