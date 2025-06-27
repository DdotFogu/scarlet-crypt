extends Node

@export var max_distance : float = 1000 

func _process(delta: float) -> void:
	var distance = get_parent().global_position.distance_to(Global.player.global_position)
	
	if distance > max_distance: get_parent().modulate.a = 0
	else: get_parent().modulate.a = 255 / (distance * 0.01) 
