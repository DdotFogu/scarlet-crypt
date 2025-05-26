extends State
class_name lamp_fire

@onready var player: Player = $"../.."

func physics_update(_delta):
	player.move_and_slide()

func update(_delta):
	Transitioned.emit(self, "idle")
