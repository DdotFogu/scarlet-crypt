extends CharacterBody2D
class_name BaseCharacter

@export var stat_sheet : StatSheet
@export var state_machine : Node

var walk_timer : Timer
var los = ShapeCast2D.new()

func _ready() -> void:
	Debugger.character_array.append(self)
	
	los.shape = CircleShape2D.new()
	los.shape.radius = 30
	add_child(los)
	
	walk_timer = Timer.new()
	walk_timer.autostart = true
	walk_timer.wait_time = 0.3
	walk_timer.timeout.connect(spawn_walk_dust)
	
	add_child(walk_timer)

func _process(_delta):
	var direction = velocity
	if direction == Vector2.ZERO:
		walk_timer.paused = true
	else:
		walk_timer.paused = false

func spawn_walk_dust():
	var direction = velocity.normalized()
	#var new_particles = particle_manager.spawn_particle(["walk dust"], get_tree().current_scene, global_position + Vector2(0, 70), 1)
	#
	#for particle in new_particles:
		#particle.direction = -direction

func los_check(target_pos : Vector2, mask : int = 1):
	los.visible = true
	los.collision_mask = mask
	
	los.target_position = target_pos - global_position
	los.force_shapecast_update()
	
	return los.get_collider(0) == null

func in_stun():
	if state_machine.current_state.name == "stun":
		return true
	else:
		return false
