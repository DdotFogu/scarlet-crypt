extends State
class_name attack_three

@onready var player: CharacterBody2D = $"../.."
@onready var sprite_body: AnimatedSprite2D = $"../../sprite_body"
@onready var hitbox: Hitbox = $"../../weapon_component/Scythe/Hitbox"

func enter():
	hitbox.visible = true
	player.velocity = Vector2.ZERO
	
	sprite_body.play("Attack_One")
	
	await get_tree().create_timer(0.3).timeout
	
	hitbox.get_node("CollisionShape2D").disabled = false
	
	var direction : Vector2 = player.global_position.direction_to(player.get_global_mouse_position())
	$"../../weapon_component/Scythe".rotation =  direction.angle()
	
	player.velocity += direction * hitbox.knockback_force * 60
	
	await get_tree().create_timer(0.5).timeout
	Transitioned.emit(self, "idle")

func exit():
	hitbox.visible = false
	hitbox.get_node("CollisionShape2D").disabled = true

func physics_update(delta):
	player.velocity = player.velocity.move_toward(Vector2.ZERO, player.stat_sheet.friction * 130)
	player.move_and_slide()
