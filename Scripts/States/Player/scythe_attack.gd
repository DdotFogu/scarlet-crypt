extends State
class_name scythe_attack

@onready var player: CharacterBody2D = $"../.."

@export var launch_force : float 
@export var hitbox: Hitbox

func enter():
	hitbox.visible = true
	player.velocity = Vector2.ZERO
	
	await get_tree().create_timer(0.1).timeout
	
	hitbox.get_node("CollisionShape2D").disabled = false
	
	var direction : Vector2 = player.global_position.direction_to(player.get_global_mouse_position())
	$"../../WeaponComponent".rotation =  direction.angle()
	
	player.velocity += direction * hitbox.knockback_force * 30
	
	await get_tree().create_timer(0.5).timeout
	Transitioned.emit(self, "idle")

func exit():
	hitbox.visible = false
	hitbox.get_node("CollisionShape2D").disabled = true

func physics_update(delta):
	player.velocity = player.velocity.move_toward(Vector2.ZERO, player.stat_sheet.friction * 130)
	player.move_and_slide()
