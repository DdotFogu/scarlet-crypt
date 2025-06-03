@icon("res://Assets/IconGodotNode/node/icon_follower.png")
extends Node
class_name attraction_component

@export var target_detection : target_dectection

var do_attraction : bool = false
var body : CharacterBody2D
var pos_tween: Tween = null

func _ready() -> void:
	body = owner

func change_attraction(enabled : bool = true):
	do_attraction = enabled

func _process(delta: float) -> void:
	if !do_attraction: 
		if pos_tween : pos_tween.kill()
		pos_tween = null
		return
	
	var target = target_detection.target
	
	pos_tween = get_tree().create_tween()
	pos_tween.tween_property(owner, "global_position", target.get_node("CollisionComponent").global_position, 5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	pos_tween.tween_callback(_on_tween_complete)

func _on_tween_complete():
	pos_tween = null
