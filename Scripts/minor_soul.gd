extends CharacterBody2D

@export var friction : float

func _physics_process(_delta: float) -> void:
	velocity = velocity.lerp(Vector2.ZERO, friction)
	
	move_and_collide(velocity)
