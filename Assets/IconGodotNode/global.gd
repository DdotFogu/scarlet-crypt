extends Node

var rng = RandomNumberGenerator.new()
var current_camera : Camera2D
var dungeon_generation : dungeon_generation
var y_sort : Node2D
var player : Player
var GameInfo : CanvasLayer
var in_dialouge : bool = false
var projectile_attacks : Dictionary = {"soul" : preload("res://Scene/Projectiles/SoulProjectile.tscn")}

func _ready() -> void:
	Dialogic.timeline_ended.connect(exit_dialouge)

func _process(delta: float) -> void:
	if get_tree().current_scene != null && get_tree().current_scene.get_node("Ysort") != null: y_sort = get_tree().current_scene.get_node("Ysort")
	current_camera = get_viewport().get_camera_2d()

func camera_transition(transition_name = "Fade"):
	var animation_player = TransitionUi.get_node("AnimationPlayer")
	animation_player.play(transition_name)
	await animation_player.animation_finished
	animation_player.play_backwards(transition_name)
	
	return true

func exit_dialouge():
	if Global.player: Global.player.get_node("InputComponent").active = true
	in_dialouge = false

func change_scene(scene_path : String):
	get_tree().change_scene_to_file(scene_path)

static func get_side_relation(object_1: Node2D, object_2: Node2D) -> int:
	if !object_2: return Global.rng.randi_range(0, 1)
	
	if object_1.global_position.x > object_2.global_position.x:
		return 1  # Object 1 is on the right
	elif object_1.global_position.x < object_2.global_position.x:
		return -1  # Object 1 is on the left
	else:
		return 0  # They are aligned
