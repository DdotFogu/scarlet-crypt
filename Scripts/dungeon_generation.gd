extends Node2D

@export var room_amount : int 
var room_indexs : Array[Dictionary]
@export var room_scenes : Array[PackedScene]
@export var starting_room_scenes : Array[PackedScene]

@onready var player: Player = $"../Player"

func _ready() -> void:
	randomize()
	create_room_map()

func create_room_map():
	var previous_room : Node = null
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
				
				var has_direction : bool = false
				for door in previous_room.creation_points:
					if door["dir"] == Vector2i(-direction):
						has_direction = true
				
				if has_direction == false:
					continue
				
				new_room_pos = previous_room_pos + (direction * (160 * 5))
				var new_room_rect = Rect2(new_room_pos * 10, Vector2(320, 320)) # Adjusted for room size
				var overlap : bool = false
				
				for room in room_indexs:
					var tile_rect = room["scene"].wall_tilemap.get_used_rect().size * 10
					var room_rect = Rect2(room["scene"].position, tile_rect)
					if new_room_rect.intersects(room_rect):
						overlap = true
						break

				if not overlap:
					break
				
				attempts += 1
				if attempts > 50:
					print("Failed to find a non-overlapping position.")
					return
		
		var room_tilemap = room_scenes.pick_random().instantiate()
		if i == 0:
			room_tilemap = starting_room_scenes.pick_random().instantiate()
		else:
			pass
		room_tilemap.position = new_room_pos * 10
		room_tilemap.room_index = i
		room_indexs.append({"scene" : room_tilemap, "index" : i})
		
		var size : Vector2 = room_tilemap.wall_tilemap.get_used_rect().size
		
		if i == 0:
			if player != null:
				player.global_position += to_global(room_tilemap.wall_tilemap.get_used_rect().size) * 80
		
		var door_directions : Array = [Vector2i(-direction.x, direction.y)]
		add_child(room_tilemap)
		
		#create doors
		if room_tilemap.room_index != 0:
			room_tilemap.create_doors(door_directions)
		if previous_room != null:
			door_directions = [Vector2i(direction.x, -direction.y)]
			
			previous_room.create_doors(door_directions)
			previous_room.connected_rooms.append({"dir" : Vector2i(direction.x, -direction.y), "scene" : room_tilemap, "position" : room_tilemap.global_position})
			
			if i != 0:
				room_tilemap.connected_rooms.append({"dir" : Vector2i(-direction.x, direction.y), "scene" : previous_room, "position" : previous_room.global_position})
		
		#create enemies 
		if room_tilemap.room_index != 0:
			for I in randi_range(2, 4):
				room_tilemap.room_enemies.append(preload("res://Skeleton.tscn"))
		
		previous_room_pos = new_room_pos
		previous_room = room_tilemap

func change_room(connecting_room, direction, player_pos):
	SignalBus.Enetered_Room.emit(connecting_room.room_index)
	
	get_tree().paused = true
	
	print(" -> " + str(connecting_room.room_index))
	
	Hud.get_node("Transitions/AnimationPlayer").play("Transition_One")
	await Hud.get_node("Transitions/AnimationPlayer").animation_finished
	Hud.get_node("Transitions/AnimationPlayer").play_backwards("Transition_One")
	
	get_tree().paused = false
	
	var pos : Vector2
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
