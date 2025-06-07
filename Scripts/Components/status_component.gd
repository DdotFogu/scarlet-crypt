@icon("res://Assets/IconGodotNode/node/icon_liquid.png")
extends Node2D
class_name status_component 

@export var inital_status_effects : Array[BaseEffectStrategy] = []
@onready var body = owner

var status_effects : Array[BaseEffectStrategy] = []

func _ready() -> void:
	apply_status(inital_status_effects)

func apply_status(status_array : Array[BaseEffectStrategy]):
	for status in status_array:
		if status_effects.has(status): 
			status_effects[status_effects.find(status)].remaning_time = status.lifetime
			return
		else: PopupManager.spawn_status_popup(status.status_string, body)
		
		status_effects.append(status)
		status_effects[status_effects.find(status)].apply_effect(body)
