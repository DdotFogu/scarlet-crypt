@icon("res://Assets/IconGodotNode/node/icon_door.png")
extends Node2D
class_name exit_lift
@export var scene_to_load : PackedScene = preload("res://Scene/Worlds/Safe Place.tscn")
@onready var animation_player : AnimationPlayer = get_node("AnimationPlayer")

func exit(body: Node2D) -> void:
	body.get_node("InputComponent").active = false
	animation_player.play("exit")
	get_tree().create_tween().tween_property(body, "position:y", body.position.y - 320, animation_player.current_animation.length())
	await get_tree().create_timer(animation_player.current_animation.length() - 1).timeout
	
	await Global.camera_transition()
	Global.change_scene(scene_to_load.resource_path)
