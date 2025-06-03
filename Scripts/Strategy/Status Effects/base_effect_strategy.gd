extends Resource
class_name BaseEffectStrategy

@export var icon : Texture2D
@export var lifetime : float
var icon_node : Sprite2D

func apply_effect(target : CharacterBody2D):
	pass

func erase_icon():
	if icon_node: icon_node.queue_free()
