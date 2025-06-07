extends Button

func start_game():
	await Global.camera_transition()
	Global.change_scene("res://play test.tscn")
