@icon("res://Assets/IconGodotNode/node/icon_grid.png")
extends TileMapLayer
class_name tile_data

@onready var target_body : CharacterBody2D = owner
var _target_tile_pos := Vector2i.ZERO

var target_tile_pos:
	get: return _target_tile_pos
	set(value):
		if value != _target_tile_pos:
			_target_tile_pos = value
			check_target()

var los_raycast : ShapeCast2D
var spot_array : Array[Dictionary]
var texture := preload("res://Assets/Sprites/Particles/smoke.png")
	
const RADIUS := 5
const TOTAL_SPOTS := (RADIUS * 2 + 1) * (RADIUS * 2 + 1)

func _init() -> void:
	tile_set = TileSet.new()
	tile_set.tile_size = Vector2(160, 160)

func _ready() -> void:
	los_raycast = ShapeCast2D.new()
	los_raycast.visible = false
	los_raycast.shape = CircleShape2D.new()
	los_raycast.shape.radius = 70
	los_raycast.collision_mask = 1
	add_child(los_raycast)

	# Pre-instantiate all the Sprite2Ds
	for i in TOTAL_SPOTS:
		var spot = Sprite2D.new()
		spot.texture = texture
		spot.visible = false
		add_child(spot)
		spot_array.append({"Scene" : spot, "Pos" : Vector2(0,0), "LOS" : null})

func _process(delta: float) -> void:
	global_position = Vector2.ZERO
	
	target_tile_pos = local_to_map(target_body.global_position)

func check_target():
	var target_map_pos = local_to_map(target_body.position)
	var target_global_pos = map_to_local(target_map_pos)
	
	var i = 0
	for dx in range(-RADIUS, RADIUS + 1):
		for dy in range(-RADIUS, RADIUS + 1):
			if i >= spot_array.size():
				return
			
			var map_pos = target_map_pos + Vector2i(dx, dy)
			var world_pos = map_to_local(map_pos)
			var visible = los_check(world_pos, target_body.global_position)
			
			var spot = spot_array[i]
			spot["Scene"].global_position = world_pos
			if visible:
				spot["Scene"].modulate = Color.ORANGE
			else:
				spot["Scene"].modulate = Color.DIM_GRAY
			spot["Pos"] = spot["Scene"].global_position
			spot["LOS"] = visible
			i += 1

func los_check(position_from: Vector2, position_to: Vector2) -> bool:
	los_raycast.global_position = position_from
	los_raycast.target_position = position_to - position_from
	los_raycast.force_shapecast_update()
	
	return los_raycast.get_collider(0) == null
