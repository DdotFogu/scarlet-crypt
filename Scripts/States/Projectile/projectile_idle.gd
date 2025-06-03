extends State
class_name projectile_idle

var body : projectile_base

func _ready() -> void:
	body = owner

func physics_update(delta):
	pass
