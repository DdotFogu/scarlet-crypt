extends base_npc

func _ready() -> void:
	$AnimationPlayer.speed_scale = randf_range(0.8, 1.2)
	await $AnimationPlayer.animation_finished
	await get_tree().create_timer(randf_range(0.0, 1.0)).timeout
	$AnimationPlayer.play("default")

func screen_exited() -> void:
	global_position = -global_position
