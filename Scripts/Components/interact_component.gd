@icon("res://Assets/IconGodotNode/node/icon_event.png")
extends Node2D
class_name interact_component

signal interacted

@onready var target_detection : Area2D = get_node("Target_Detection")

func _process(delta: float) -> void:
	if target_detection.get_overlapping_bodies().size() > 0 && !Global.in_dialouge && Input.is_action_just_pressed("pi_interact"):
		Global.player.get_node("InputComponent").active = false
		Global.in_dialouge = true
		interacted.emit()
