extends State
class_name stun

@onready var body : CharacterBody2D = owner
var timer : Timer
@onready var health_component = $"../../HealthComponent"

func _ready() -> void:
	timer = Timer.new()
	timer.one_shot = true
	timer.timeout.connect(timeout)
	add_child(timer)

func enter():
	if health_component.last_attack.stun_time <= 0: Transitioned.emit(self, "idle", true)
	
	timer.wait_time = health_component.last_attack.stun_time
	timer.start()

func exit():
	body.reset_detection()

func timeout():
	Transitioned.emit(self, "idle", true)

func physics_update(_delta):
	body.velocity = body.velocity.lerp(Vector2.ZERO, body.stat_sheet.friction)
	body.move_and_slide()
