extends State
class_name stun

@export var body: CharacterBody2D
@export var health_component: health_component

func enter():
	var timer = Timer.new()
	timer.wait_time = health_component.last_attack.stun_time
	timer.one_shot = true
	timer.timeout.connect(timeout)
	add_child(timer)
	
	timer.start()

func timeout():
	if body.get_node("pursure_range") != null:
		body.get_node("pursure_range").get_node("CollisionShape2D").disabled = false
	
	Transitioned.emit(self, "idle")

func physics_update(_delta):
	body.velocity = body.velocity.lerp(Vector2.ZERO, body.stat_sheet.friction)
	body.move_and_slide()
