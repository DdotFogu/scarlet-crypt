extends State
class_name lunge

@export var launch_force : float
@export var reset_delay : float
@export var detector : target_dectection

@export var visual_component : visual_component

var body : CharacterBody2D
var target : CharacterBody2D

signal lunged

func _ready() -> void:
	body = get_parent().get_parent()

func enter():
	if visual_component: await visual_component.play_animation("anticipate")
	if get_parent().in_stun() : return
	
	if visual_component: visual_component.play_animation("attack")
	
	lunged.emit()
	
	target = detector.target
	
	var direction : Vector2 = body.global_position.direction_to(target.get_nearby_position(150))
	
	direction = body.global_position.direction_to(target.global_position)
	body.velocity += direction.normalized() * launch_force
	
	# Reset set state after delay
	await get_tree().create_timer(reset_delay).timeout
	body.reset_detection()
	Transitioned.emit(self, "idle")

func physics_update(delta: float) -> void:
	body.velocity = body.velocity.lerp(Vector2.ZERO, body.stat_sheet.friction)
	body.move_and_slide()
