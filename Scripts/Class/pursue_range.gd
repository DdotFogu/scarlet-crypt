@icon("res://Assets/IconGodotNode/node/icon_event.png")
extends Area2D
class_name target_dectection

@export var pathfinding : pathfinding_component

signal target_detected
signal target_left

var target : CharacterBody2D
var check_timer : Timer

var overwrite_target_left : bool = false

func _ready() -> void:
	body_entered.connect(target_body_entered)
	body_exited.connect(target_body_exited)
	
	check_timer = Timer.new()
	check_timer.wait_time = 0.1
	check_timer.timeout.connect(do_check)
	check_timer.autostart = false
	add_child(check_timer)

func do_check():
	if target == null:
		return
	
	if pathfinding.los_check(target.global_position):
		overwrite_target_left = true
		
		target_detected.emit()
		check_timer.stop()
		
		get_child(0).disabled = true
	else:
		pass

func target_body_entered(target_body):
	target = target_body
	check_timer.start()

func target_body_exited(target_body):
	if overwrite_target_left: 
		overwrite_target_left = false
		return
	
	get_child(0).disabled = false
	target_left.emit()
	check_timer.stop()
