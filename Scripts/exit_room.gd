@icon("res://Assets/IconGodotNode/node/icon_map.png")
extends base_room
class_name exit_room

func exit(body: Node2D) -> void:
	body.get_node("InputComponent").active = false
	
	await Global.camera_transition()
	Global.change_scene("res://test_menu.tscn")
