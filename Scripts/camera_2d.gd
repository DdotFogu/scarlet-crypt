extends Camera2D

# Camera Follow Vars
@export var target : Player
@export var sensitivity := 0.1


func _physics_process(delta: float) -> void:
	var target_position = target.global_position
	position = position.lerp(target_position, 0)
