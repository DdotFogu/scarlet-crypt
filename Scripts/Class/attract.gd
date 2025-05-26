extends Area2D
class_name Attract

@export var target: Node2D
var do_attract: bool = false
var pos_tween: Tween = null

func _ready() -> void:
	await get_tree().create_timer(0.7).timeout
	$CollisionShape2D.disabled = false

func _process(_delta: float) -> void:
	if do_attract:
		pos_tween = get_tree().create_tween()
		pos_tween.tween_property(get_parent(), "global_position", target.get_node("collision_body").global_position, 2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		pos_tween.tween_callback(_on_tween_complete)

func _on_tween_complete():
	pos_tween = null

func _on_body_entered(body: Node2D) -> void:
	if body == target:
		do_attract = true

func _on_body_exited(body: Node2D) -> void:
	if body == target:
		do_attract = false
		if pos_tween:
			pos_tween.kill()
			pos_tween = null
