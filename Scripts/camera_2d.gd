@icon("res://Assets/IconGodotNode/node/icon_camera_grid.png")
extends Camera2D

# Camera Follow Vars
@export var target : Node2D
@export var sens : float = 1

func _physics_process(delta: float) -> void:
	var target_position = target.global_position
	global_position = global_position.lerp(target_position, sens)
