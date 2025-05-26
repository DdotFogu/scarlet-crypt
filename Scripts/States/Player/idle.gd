extends State
class_name idle

@onready var player: CharacterBody2D = $"../.."
@onready var sprite_body: AnimatedSprite2D = $"../../sprite_body"

func enter():
	sprite_body.play("Idle")

func physics_update(delta):	
	player.velocity = player.velocity.lerp(Vector2.ZERO, player.stat_sheet.friction)
	player.move_and_slide()

func update(delta):
	if player.input_direction.length() > 0:
		Transitioned.emit(self, "move")
