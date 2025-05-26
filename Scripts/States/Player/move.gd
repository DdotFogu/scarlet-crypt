extends State
class_name move

@onready var player: CharacterBody2D = $"../.."
@onready var sprite_body: AnimatedSprite2D = $"../../sprite_body"

func enter():	
	sprite_body.play("Walk")

func physics_update(delta):
	player.velocity = player.velocity.lerp(player.input_direction.normalized() * player.stat_sheet.speed * 5, player.stat_sheet.acceleration)
	player.move_and_slide()

func update(delta):
	if player.velocity.x > 0:
		sprite_body.flip_h = false
	elif player.velocity.x < 0:
		sprite_body.flip_h = true
	
	if player.input_direction.length() == 0:
		Transitioned.emit(self, "idle")
