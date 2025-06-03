@icon("res://Assets/IconGodotNode/node/icon_door.png")
extends Node2D
class_name dungeon_generation

@export_category("Generation Vars")
@export var main_path_count : int 
@export var branching_paths_count : int
@export var branch_chance : float

@export_category("Other")
@export var generation_time : float = 0.1
@export var generation_spacing : float = 4800

@export_category("Room Scenes")
@export var enemy_room_scenes : Array[PackedScene]
@export var treasure_rooms : Array[PackedScene]
@export var starting_room_scenes : Array[PackedScene]

@onready var player: Player = $"../Player"

var room_data_array : Array[room_data]

signal generation_completed

func _ready() -> void:
	Global.dungeon_generation = self
	
	randomize()
	
	var room_path = create_new_path(main_path_count)
	for room in room_path:
		if room.scene is enemy_room:
			for i in range(2, 4):
				room.scene.queued_enemies.append(preload("res://Scene/Characters/NPC/Enemies/Skeleton.tscn"))
	create_rooms(room_path)
	
	await get_tree().create_timer(generation_time * main_path_count).timeout
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

func create_new_path(room_count: int = 0, previous_room: base_room = null) -> Array[room_data]:
	randomize()
	var room_path: Array[room_data]
	var previous_room_pos = previous_room.position if previous_room else Vector2.ZERO

	for i in range(room_count):
		var direction : Vector2
		var new_room_pos : Vector2
		var attempts = 0

		if i != 0 or previous_room != null:
			while true:
				direction = Vector2(randi_range(-1, 1), randi_range(-1, 1))
				if direction.x != 0 and direction.y != 0:
					continue

				var has_direction := false
				for door in previous_room.creation_points:
					if door["dir"] == Vector2i(-direction):
						has_direction = true
				if not has_direction:
					continue

				new_room_pos = previous_room_pos + direction * generation_spacing
				var new_room_rect = Rect2(new_room_pos, Vector2(320, 320))
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

		var room_instance = enemy_room_scenes.pick_random().instantiate()
		if i == 0 and room_data_array.is_empty():
			room_instance = starting_room_scenes.pick_random().instantiate()

		room_instance.position = new_room_pos

		var new_data := room_data.new()
		new_data.scene = room_instance
		new_data.room_index = room_data_array.size()
		new_data.scene_position = new_room_pos
		new_data.dir = Vector2i(direction)
		new_data.previous_room = previous_room

		room_instance.data = new_data

		room_path.append(new_data)
		room_data_array.append(new_data)

		previous_room_pos = new_room_pos
		previous_room = room_instance

	return room_path

func create_branching_paths():
	var rooms_remaining = branching_paths_count
	var available_rooms = room_data_array.duplicate()

	while rooms_remaining > 0:
		for room in available_rooms:
			if rooms_remaining <= 0:
				break
			var chance = Global.rng.randf_range(1, 100)
			if chance <= branch_chance:
				var branch_count = randi_range(1, rooms_remaining)
				rooms_remaining -= branch_count
				if branch_count <= 0:
					break
				var room_path = create_new_path(branch_count, room.scene)
				create_rooms(room_path)
				available_rooms.erase(room)

func change_room(connecting_room: base_room, direction, player_pos):
	SignalBus.Enetered_Room.emit(connecting_room.data.room_index)
	
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
		player.position = pos
