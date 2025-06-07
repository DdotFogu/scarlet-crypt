extends State
class_name scythe_attack

@onready var body: CharacterBody2D = owner

@export var launch_force : float 
@export var friction : float

func enter():
	body.velocity = Vector2.ZERO
	
	var direction : Vector2 = body.global_position.direction_to(body.get_global_mouse_position())
	
	body.velocity += direction * launch_force
	
	await get_tree().create_timer(0.5).timeout
	Transitioned.emit(self, "idle")

func physics_update(delta):
	body.velocity = body.velocity.move_toward(Vector2.ZERO, friction)
	body.move_and_slide()
