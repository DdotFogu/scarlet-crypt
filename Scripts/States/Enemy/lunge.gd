extends State
class_name lunge

@export var body : BaseCharacter
@export var launch_force : float
@export var hitbox : Hitbox
@export var sprite_animation : AnimationPlayer
var target : CharacterBody2D

func enter():
	sprite_animation.play("Anticipate")
	await sprite_animation.animation_finished
	
	#check if isn't im stun after attack delay
	if body.in_stun() == false:
		sprite_animation.play("Attack")
		
		var direction : Vector2 = body.global_position.direction_to(target.global_position)
		
		if direction.x > 0:
			sprite_animation.get_parent().flip_h = false
		elif direction.x < 0:
			sprite_animation.get_parent().flip_h = true
		
		hitbox.rotation =  direction.angle()
		hitbox.get_node("AnimationPlayer").play("attack")
		
		direction = body.global_position.direction_to(target.global_position)
		body.velocity += direction.normalized() * launch_force
		
		await sprite_animation.animation_finished
		Transitioned.emit(self, "idle")

func exit():
	hitbox.get_node("AnimationPlayer").play("RESET")

func physics_update(delta: float) -> void:
	body.velocity = body.velocity.lerp(Vector2.ZERO, body.stat_sheet.friction)
	body.move_and_slide()
