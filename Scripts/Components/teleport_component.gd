@icon("res://Assets/IconGodotNode/node/icon_path_follow.png")
extends Node2D
class_name teleport_trigger_component

@export var triggers := [{
	"Area2D" : null,
	"Connections" : []
	}]


func teleport(emitter : NodePath) -> void:
	if !emitter: return 
	
	get_tree().paused = true
	await Global.camera_transition()
	get_tree().paused = false
	
	print(triggers.find(emitter))
