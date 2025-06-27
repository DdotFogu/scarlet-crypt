@icon("res://Assets/IconGodotNode/node/icon_file.png")
extends Node2D

@export var scene_path : String = "res://Scene/Dungeon Rooms/HubWorld.tscn"
@export var pauses : bool = true
@export var transition_name : String = "Fade"

func change_scene():
	get_tree().paused = pauses
	await Global.camera_transition(transition_name)
	get_tree().paused = false
	Global.change_scene(scene_path)
