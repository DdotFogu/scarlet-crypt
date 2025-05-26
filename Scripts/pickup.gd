extends Area2D
class_name Pickup

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(_body: Node2D) -> void:
	owner.queue_free()
