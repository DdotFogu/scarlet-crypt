extends State
class_name follow

var body : CharacterBody2D

@export var pathfinding : pathfinding_component
@export var detector : target_dectection
@export var test_arrow : Sprite2D
@export var dir_array := [Vector2(1, 0), Vector2(-1, 0), Vector2(0, -1), Vector2(0, 1)]

func _ready() -> void:
	body = get_parent().get_parent()

func physics_update(delta: float) -> void:
	var target = detector.target
	
	if !target:
		return
	
	var direction = pathfinding.direction_to_target(target)
	
	if test_arrow:
		match direction["Direction"]:
			Vector2(1, 0):
				test_arrow.rotation_degrees = 0
			Vector2(-1, 0):
				test_arrow.rotation_degrees = 180
			Vector2(0, -1):
				test_arrow.rotation_degrees = -90
			Vector2(0, 1):
				test_arrow.rotation_degrees = 90
				
	body.velocity = body.velocity.lerp(direction["Direction"] * body.stat_sheet.speed * 5, body.stat_sheet.acceleration)
	body.move_and_slide()

func enter():
	Entered.emit()
	
	if test_arrow:
		test_arrow.visible = true

func exit():
	if test_arrow:
		test_arrow.visible = false
