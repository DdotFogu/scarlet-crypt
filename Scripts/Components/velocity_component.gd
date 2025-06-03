@icon("res://Assets/IconGodotNode/node/icon_projectile.png")
extends Node
class_name velocity_component

@export var health_component : health_component

var body : CharacterBody2D
var direction := Vector2(1, 0)

func _ready() -> void:
	body = get_parent()

func set_direction(new_direction : Vector2):
	direction = new_direction
	return direction

func set_speed(new_speed):
	body.stat_sheet.speed = new_speed
	return body.stat_sheet.speed

func set_maxspeed(new_speed):
	body.stat_sheet.speed_cap = new_speed
	return body.stat_sheet.speed_cap

func _physics_process(delta: float) -> void:
	body.velocity = body.velocity.lerp(direction * body.stat_sheet.speed_cap, body.stat_sheet.acceleration)
	body.move_and_slide()
	
	var collision = body.get_slide_collision(0)
	if collision:
		var attack = Attack.new()
		attack.killer = get_parent()
		attack.damage = 999
		
		health_component.take_damage(attack, true)
