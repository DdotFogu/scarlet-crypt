@icon("res://Assets/IconGodotNode/node/icon_lever.png")
extends Node
class_name input_component

@export var active : bool = true

#Mouse Events
signal event_m1
signal event_m2

func get_input():
	var input = Vector2.ZERO
	if !active : return input
	
	if Input.is_action_pressed('pi_right'):
		input.x += 1
	if Input.is_action_pressed('pi_left'):
		input.x -= 1
	if Input.is_action_pressed('pi_down'):
		input.y += 1
	if Input.is_action_pressed('pi_up'):
		input.y -= 1
	return input

func _input(event: InputEvent) -> void:
	if !active : return
	if event.is_action_pressed("pi_m2"): event_m2.emit()
	if event.is_action_pressed("pi_m1"): event_m1.emit()
