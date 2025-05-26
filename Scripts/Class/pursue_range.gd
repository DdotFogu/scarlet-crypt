extends Area2D
class_name pursure_range

@export var state_machine : Node
@export var state_to_iniate : State

var target : CharacterBody2D
var check_timer : Timer

func _ready() -> void:
	body_entered.connect(target_body_entered)
	body_exited.connect(target_body_exited)
	
	check_timer = Timer.new()
	check_timer.wait_time = 0.1
	check_timer.timeout.connect(do_check)
	check_timer.autostart = false
	add_child(check_timer)

func do_check():
	if target == null or get_parent().in_stun() == true:
		return
	
	if get_parent().los_check(target.global_position):
		if state_to_iniate is State and "target" in state_to_iniate:
			state_to_iniate.target = target
		else:
			print("STATE DOES NOT HAVE TARGET VAR OF " + str(get_parent()))
		state_machine.current_state.Transitioned.emit(state_machine.current_state, state_to_iniate.name)
		get_node("CollisionShape2D").disabled = true
		check_timer.stop()
	else:
		pass
		#print("NO LINE OF SIGHT")

func target_body_entered(target_body):
	if state_machine.current_state == state_to_iniate:
		return
	
	target = target_body
	check_timer.start()

func target_body_exited(target_body):
	check_timer.stop()
