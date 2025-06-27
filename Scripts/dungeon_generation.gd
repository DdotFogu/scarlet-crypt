@icon("res://Assets/IconGodotNode/node/icon_door.png")
extends Node2D
class_name dungeon_generation

@export_category("Generation Vars")
@export var main_path_data : path_data
@export var side_path_data : path_data
@export var branch_chance : float

@export_category("Other")
@export var camera_component : Camera2D
@export var generation_time : float = 0.1
@export var generation_spacing : float = 4800

@export_category("Room Scenes")
@export var enemy_room_scenes : Array[PackedScene]
@export var treasure_rooms : Array[PackedScene]
@export var boss_rooms : Array[PackedScene]
@export var starting_room_scenes : Array[PackedScene]

var room_data_array : Array[room_data]

signal generation_completed

func _ready() -> void:
	Global.dungeon_generation = self
	
	randomize()
	
	var room_path = create_new_path(main_path_data)
	create_rooms(room_path)
	
	await get_tree().create_timer(generation_time * main_path_data.room_count).timeout
	await create_branching_paths()
	generation_completed.emit()

func create_rooms(path: Array[room_data]):
	for room in path:
		await get_tree().create_timer(generation_time).timeout
		room.scene.global_position = room.scene_position
		add_child(room.scene)
		
		var direction = -room.dir
		if room.previous_room:
			room.previous_room.connected_rooms.append(room.scene)
			room.scene.connected_rooms.append(room.previous_room)
		
		direction = Vector2i(direction.x, -direction.y)
		
		room.scene.create_doors([direction])
		if room.previous_room:
			room.previous_room.create_doors([-direction])

func create_new_path(data : path_data, room_count : int = data.room_count, previous_room: base_room = null) -> Array[room_data]:
	randomize()
	var room_path: Array[room_data]
	var previous_room_pos = previous_room.position if previous_room else Vector2.ZERO

	for i in range(room_count):
		var direction_data : Array = [Vector2(0,0), Vector2(0,0)]
		if i != 0 or previous_room != null:
			direction_data = find_direction_without_overlap(previous_room)
		if direction_data: print(direction_data)
		
		var room_instance = enemy_room_scenes.pick_random().instantiate()
		if i == room_count - 1 and data.create_boss_room:room_instance = boss_rooms.pick_random().instantiate()
		if i == 0 and room_data_array.is_empty(): room_instance = starting_room_scenes.pick_random().instantiate()
		
		room_instance.position = direction_data[1]
		
		var new_data := room_data.new()
		new_data.scene = room_instance
		new_data.room_index = room_data_array.size()
		new_data.scene_position = direction_data[1]
		new_data.dir = Vector2i(direction_data[0])
		new_data.previous_room = previous_room
		
		room_instance.data = new_data
		
		room_path.append(new_data)
		room_data_array.append(new_data)
		
		previous_room_pos = direction_data[1]
		previous_room = room_instance
	
	if data.create_exit_room:
		var direction_data = find_direction_without_overlap(previous_room)
		var room_instance = preload("res://Scene/Worlds/exit_room_01.tscn").instantiate()
		
		room_instance.position = direction_data[1]
		
		var new_data := room_data.new()
		new_data.scene = room_instance
		new_data.room_index = room_data_array.size()
		new_data.scene_position = direction_data[1]
		new_data.dir = Vector2i(direction_data[0])
		new_data.previous_room = previous_room
		
		room_instance.data = new_data
		
		room_path.append(new_data)
		room_data_array.append(new_data)
	
	return room_path

func find_direction_without_overlap(root_room : Node2D):
	var direction : Vector2
	var new_pos : Vector2
	var attempts = 0
	
	while true:
		direction = Vector2(randi_range(-1, 1), randi_range(-1, 1))
		if direction.x != 0 and direction.y != 0:
			continue
		
		var has_direction := false
		for door in root_room.creation_points:
			if door["dir"] == Vector2i(-direction):
				has_direction = true
		if not has_direction:
			continue
		
		var root_room_pos = root_room.global_position if root_room else Vector2.ZERO
		new_pos = root_room_pos + direction * generation_spacing
		var new_room_rect = Rect2(new_pos, Vector2(320, 320))
		var overlap = false
		for existing in room_data_array:
			var tile_rect = existing.scene.wall_tilemap.get_used_rect().size
			var room_rect = Rect2(existing.scene.position, tile_rect)
			if new_room_rect.intersects(room_rect):
				overlap = true
				break
		if not overlap:
			break
		attempts += 1
		if attempts > 50:
			break
	
	return [direction, new_pos]

func create_branching_paths():
	var rooms_remaining = side_path_data.room_count
	var available_rooms = room_data_array.duplicate()

	while rooms_remaining > 0:
		for room in available_rooms:
			if room.scene is boss_room or room.scene is exit_room : continue
			if rooms_remaining <= 0: break
			
			var chance = Global.rng.randf_range(1, 100)
			if chance <= branch_chance:
				var branch_count = randi_range(1, rooms_remaining)
				rooms_remaining -= branch_count
				if branch_count <= 0: break
				var room_path = create_new_path(side_path_data, branch_count, room.scene)
				
				create_rooms(room_path)
				available_rooms.erase(room)

func change_room(connecting_room: base_room, direction, player_pos):
	var pos: Vector2
	for door in connecting_room.creation_points:
		if door["dir"] == -direction:
			pos = connecting_room.wall_tilemap.map_to_local(door["pos"]) + connecting_room.wall_tilemap.global_position
			if door["dir"].x != 0:
				pos.x -= 80 * door["dir"].x
				pos.y = player_pos.y
			if door["dir"].y != 0:
				pos.y += 100 * door["dir"].y
				pos.x = player_pos.x
	if pos != null:
		Global.player.position = pos
	
	SignalBus.Enetered_Room.emit(connecting_room.data.room_index)
