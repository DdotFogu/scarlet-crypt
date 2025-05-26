extends health_component

func die():
	super()
	for i in 3:
		soul_manager.spawn_minor_soul(get_parent().global_position, get_parent())
