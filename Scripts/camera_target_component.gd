@icon("res://Assets/IconGodotNode/node/icon_visibility.png")
extends Area2D
class_name camera_target_component

@onready var cam_target_point := $CameraPoint

func change_camera_target(body: Node2D) -> void:
	print("body enetered")
	
	var camera_component = get_viewport().get_camera_2d()
	if cam_target_point: await camera_component.change_target(cam_target_point)
	else: await camera_component.change_target(Global.player)
