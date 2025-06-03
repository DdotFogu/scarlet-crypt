@icon("res://Assets/IconGodotNode/node/icon_liquid.png")
extends Node2D
class_name status_component 

@export var inital_status_effects : Array[BaseEffectStrategy] = []
@onready var body = owner

var status_effects : Array[BaseEffectStrategy] = []

func _ready() -> void:
	for status in inital_status_effects:
		apply_status(status)

func apply_status(status : BaseEffectStrategy):
	if status_effects.has(status): 
		status.erase_icon()
		status_effects.erase(status)
	
	status_effects.append(status)
	status.apply_effect(body)
	add_icon(status)

func add_icon(status : BaseEffectStrategy):
	var icon_sprite = Sprite2D.new()
	icon_sprite.texture = status.icon
	icon_sprite.scale = Vector2(2.5, 2.5)
	icon_sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	add_child(icon_sprite)
	
	status.icon_node = icon_sprite
