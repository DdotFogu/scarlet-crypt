extends PointLight2D

@export var scale_factor : float = 1.0
@export var time_scale : float = 1.0
@onready var min_scale : float = texture_scale
var time : float

func _ready() -> void:
	scale_factor = Global.rng.randf_range(scale_factor - 0.2, scale_factor + 0.2)
	
	set_process(false)
	await get_tree().create_timer(Global.rng.randf_range(0.0, 1.0)).timeout
	set_process(true)

func _process(delta: float) -> void:
	time += delta * time_scale
	texture_scale = get_sine()

func get_sine():
	if sin(time * 1) * scale_factor < min_scale: return min_scale + abs(sin(time * 1) * scale_factor)
	return sin(time * 1) * scale_factor
