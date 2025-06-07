@icon("res://Assets/IconGodotNode/node/icon_camera_grid.png")
extends Camera2D
class_name camera_component

# Camera Follow Vars
@export var target : Node2D
@export var sens : float = 1

func _ready() -> void:
	change_target(target)

func change_target(new_target : Node):
	target = new_target
	
	if !target: return
	
	var target_position = target.global_position
	
	var pos_tween = create_tween()
	await pos_tween.tween_property(self, "global_position", target_position, sens).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT).finished
	
	return true
