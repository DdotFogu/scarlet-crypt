extends State
class_name move

@onready var body : CharacterBody2D = owner
@onready var input_component : input_component = owner.get_node("InputComponent")

func physics_update(delta):
	print(input_component.get_input())
	body.velocity = body.velocity.lerp(input_component.get_input().normalized() * body.stat_sheet.speed * 5, body.stat_sheet.acceleration)
	body.move_and_slide()

func update(delta):
	if input_component.get_input().length() == 0 or input_component.active == false:
		Transitioned.emit(self, "idle")
