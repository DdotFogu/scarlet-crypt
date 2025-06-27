@icon("res://Assets/IconGodotNode/color/icon_teleporter.png")
extends Area2D
class_name teleport_trigger

signal teleport_complete

@onready var teleport_marker = get_node("Teleport_Position")

func teleport(body : Node2D):
	get_tree().paused = true
	await Global.camera_transition()
	get_tree().paused = false
	
	body.velocity = Vector2.ZERO
	body.global_position = teleport_marker.global_position
	
	teleport_complete.emit()
