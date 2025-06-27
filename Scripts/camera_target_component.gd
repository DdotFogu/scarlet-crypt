@icon("res://Assets/IconGodotNode/node/icon_visibility.png")
extends Area2D
class_name camera_target_component

@export var cam_zoom := Vector2(0.2,0.2)
@export var cam_time := 1.0
@export var pauses := false
@onready var cam_target_point := self

func change_camera_target(body: CharacterBody2D) -> void:
	var camera_component = get_viewport().get_camera_2d()
	if cam_target_point: 
		if pauses: body.velocity = Vector2.ZERO
		
		get_tree().create_tween().tween_property(camera_component, "zoom", cam_zoom, 1).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
		await camera_component.change_target(cam_target_point, cam_time, pauses)
	else: await camera_component.change_target(Global.player)
