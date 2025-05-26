extends BaseCharacter
class_name Player

var input_direction : Vector2

func get_input():
	var input = Vector2.ZERO
	if Input.is_action_pressed('pi_right'):
		input.x += 1
	if Input.is_action_pressed('pi_left'):
		input.x -= 1
	if Input.is_action_pressed('pi_down'):
		input.y += 1
	if Input.is_action_pressed('pi_up'):
		input.y -= 1
	return input

func _ready() -> void:
	super()

func _physics_process(_delta):
	input_direction = get_input()
	
	velocity.x = clamp(velocity.x, -stat_sheet.speed_cap, stat_sheet.speed_cap)
	velocity.y = clamp(velocity.y, -stat_sheet.speed_cap, stat_sheet.speed_cap)
