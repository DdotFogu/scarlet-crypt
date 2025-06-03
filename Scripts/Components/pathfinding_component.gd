@icon("res://Assets/IconGodotNode/node/icon_search.png")
extends Node
class_name pathfinding_component

var los = ShapeCast2D.new()
var body : CharacterBody2D

# Fallback memory
var last_direction
var fallback_position: Vector2
var using_fallback: bool = false

func _ready() -> void:
	body = get_parent()
	
	los.shape = CircleShape2D.new()
	los.shape.radius = 5
	add_child(los)

func los_check(target_pos : Vector2, new_global_position : Vector2 = owner.global_position, mask : int = 1):
	los.visible = true
	los.global_position = new_global_position
	los.collision_mask = mask
	
	los.target_position = target_pos - get_parent().global_position
	los.force_shapecast_update()
	
	if !los.get_collider(0) != null:
		return los.get_collider(0) == null
	else:
		return false

func direction_to_target(target : Node2D, dir_array := [Vector2(1, 0), Vector2(-1, 0), Vector2(0, -1), Vector2(0, 1)]):
	var target_direction = body.global_position.direction_to(target.global_position).normalized()
	
	if !los_check(target.global_position):
		if !using_fallback:
			using_fallback = true
			
			var tile_data_array = target.get_node("TileDataComponent").spot_array.duplicate()
			var tile_data_distance: Array[Dictionary]
			for index in tile_data_array:
				var pos = index["Pos"]
				if !index["LOS"]:
					continue
				if los_check(pos): # Optional realtime verification
					continue
				
				tile_data_distance.append({
					"Pos": pos,
					"Distance": body.global_position.distance_to(pos), 
					"TargetDistance" : target.global_position.distance_to(pos),
				})
			
			for tile in tile_data_distance:
				tile["Difference"] = abs(tile["TargetDistance"] - tile["Distance"])
			
			# Step 2: Sort by smallest difference
			tile_data_distance.sort_custom(func(a, b): return a.Difference < b.Difference)
			
			# Step 3: Keep only the top third
			var keep_count = tile_data_distance.size() / 5
			tile_data_distance = tile_data_distance.slice(0, keep_count)
			
			tile_data_distance.sort_custom(func(a, b): return a.Distance < b.Distance)
			
			if tile_data_distance.size() > 0:
				fallback_position = tile_data_distance[0]["Pos"]
			else:
				print("DID NOT FIND VALID SPOT")
	
		# Use fallback direction if active
		if using_fallback:
			target_direction = body.global_position.direction_to(fallback_position).normalized()
	else:
		# Reset fallback when LOS to target is restored
		using_fallback = false
		fallback_position = Vector2.ZERO
	
	var intrest_vector: Array[Dictionary] = []
	for dir in dir_array:
		intrest_vector.append({
			"Direction": dir,
			"Intrest": dir.dot(target_direction)
		})
	intrest_vector.sort_custom(func(a, b): return a.Intrest > b.Intrest)
	
	var threshold: float = 0.1
	var direction = intrest_vector[0]
	if last_direction:
		if abs(direction["Intrest"] - last_direction["Intrest"]) < threshold:
			direction = last_direction
	last_direction = direction
	
	return direction
