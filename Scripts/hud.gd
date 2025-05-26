extends CanvasLayer

@export var bbcode : String

@export var transition_animation : AnimationPlayer

func _process(_delta: float) -> void:
	%FPS.text = bbcode
	%FPS.text += "FPS "
	%FPS.text += str(Engine.get_frames_per_second())

func change_scene(scene_path : String):
	transition_animation.play("Transition_One")
	await transition_animation.animation_finished
	transition_animation.play_backwards("Transition_One")
	get_tree().change_scene_to_file(scene_path)
