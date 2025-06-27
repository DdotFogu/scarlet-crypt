@icon("res://Assets/IconGodotNode/node/icon_camera_grid.png")
extends Camera2D
class_name camera_component

# Camera Follow Vars
@export var target : Node2D
@export var sens : float = 2

func _ready() -> void:
	change_target(target)

func change_target(new_target : Node, speed : float = sens, do_pause : bool = false):
	target = new_target
	
	if !target: return
	
	var target_position = target.global_position
	
	
	if do_pause: get_tree().paused = true
	var pos_tween = create_tween()
	await pos_tween.tween_property(self, "global_position", target_position, speed).finished
	if do_pause: get_tree().paused = false
	
	return true
