extends Node2D

@export var room_amount : int 
var room_indexs : Array[Dictionary]
@export var main_cam : Camera2D

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("reload scene"):
		get_tree().reload_current_scene()

func _ready() -> void:
	randomize()
	create_room_map()
	
	await get_tree().create_timer(2).timeout
	for room in room_indexs:
		pass

func create_room_map():
	var previous_room : TileMapLayer = null
	var previous_room_pos : Vector2

	for i in range(room_amount):
		var direction : Vector2
		var new_room_pos : Vector2
		var attempts = 0
		
		# Find a valid direction without overlap
		if i != 0:
			while true:
				direction = Vector2(randi_range(-1, 1), randi_range(-1, 1))
				if direction.x != 0 and direction.y != 0:
					continue
				
				new_room_pos = previous_room_pos + (direction * 50)
				var overlap : bool = false
				for room in room_indexs:
					var tile_rect = room["scene"].get_used_rect()
					if room["scene"].position.x <= new_room_pos.x and new_room_pos.x >= room["scene"].position.x + (tile_rect.size.x * 32):
						if room["scene"].position.y >= new_room_pos.y and new_room_pos.y >= room["scene"].position.y + (tile_rect.size.y * 32):
							overlap = true
							print("overlapping")
							break
				if overlap == false:
					break
				
				attempts += 1
				if attempts > 50:
					print("Failed to find a non-overlapping position.")
					return
		
		var room_tilemap = preload("res://dungeon_room_01.tscn").instantiate()
		room_tilemap.position = new_room_pos * 10
		room_tilemap.room_index = i
		room_indexs.append({"scene" : room_tilemap, "index" : i})
		
		var size : Vector2 = room_tilemap.get_used_rect().size
		if i == 0:
			main_cam.position = room_tilemap.position + room_tilemap.map_to_local(size/2)
		
		var door_directions : Array = [Vector2i(-direction.x,direction.y)]
		add_child(room_tilemap)
		room_tilemap.create_doors(door_directions)
		if previous_room != null:
			door_directions = [Vector2i(direction.x,-direction.y)]
			previous_room.create_doors(door_directions)
			
			previous_room.connected_rooms.append({"dir" : Vector2i(direction.x,-direction.y), "scene" : room_tilemap, "position" : room_tilemap.global_position})
			if i != 0:
				room_tilemap.connected_rooms.append({"dir" : Vector2i(-direction.x,direction.y), "scene" : previous_room, "position" : previous_room.global_position})
		
		previous_room_pos = new_room_pos
		previous_room = room_tilemap
