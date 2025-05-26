extends State
class_name Idle

@export var body: CharacterBody2D
@export var sprite_animation : AnimationPlayer

func physics_update(_delta):
	body.velocity = body.velocity.lerp(Vector2.ZERO, body.stat_sheet.friction)
	body.move_and_slide()

func enter():
	sprite_animation.play("Idle")
