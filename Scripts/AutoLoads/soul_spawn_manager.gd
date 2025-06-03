class_name soul_manager

static var minor_soul_scene := preload("res://Scene/Pickups/MinorSoul.tscn")

static func spawn_minor_soul(spawn_position : Vector2, parent : Node2D):
	randomize()
	var minor_soul = minor_soul_scene.instantiate()
	
	minor_soul.global_position = spawn_position
	
	parent.get_tree().root.add_child(minor_soul)
	
	var rnd_dir = Vector2(randf_range(-1, 1), randf_range(-1, 1))
	minor_soul.velocity = rnd_dir * 10
