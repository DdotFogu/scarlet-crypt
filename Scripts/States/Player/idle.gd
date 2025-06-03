extends State
class_name idle

@onready var body : CharacterBody2D = owner
@onready var input_component : input_component = owner.get_node("InputComponent")

func physics_update(delta):	
	body.velocity = body.velocity.lerp(Vector2.ZERO, body.stat_sheet.friction)
	body.move_and_slide()

func update(delta):
	if input_component.get_input().length() > 0:
		Transitioned.emit(self, "move")
