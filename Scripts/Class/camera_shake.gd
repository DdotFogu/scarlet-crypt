extends Node
class_name CameraShake

@export var shake_fade : float = 5.0

var rng = RandomNumberGenerator.new()

var shake_stregth : float = 0.0

func apply_shake(random_strength : float):
	shake_stregth = random_strength

func _process(delta: float) -> void:
	if shake_stregth > 0:
		shake_stregth = lerpf(shake_stregth,0,shake_fade * delta)
		
		get_parent().offset = random_offset()

func random_offset() -> Vector2:
	return Vector2(rng.randf_range(-shake_stregth, shake_stregth), rng.randf_range(-shake_stregth, shake_stregth))
