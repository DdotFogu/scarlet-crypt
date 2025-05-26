extends Node2D
class_name base_room

@export_category("Room Generation")
@export var creation_points : Array[Dictionary]
@export var wall_tilemap : TileMapLayer

var room_index : int 
var connected_rooms : Array[Dictionary]
var dungeon_generation

func _ready() -> void:
	dungeon_generation = get_node("/root/main/dungeon_generation")

func get_random_avaible_tile(tilemap : TileMapLayer) -> Vector2i:
	var tile_cells = tilemap.get_used_cells()
	tile_cells.shuffle()
	return tile_cells.pick_random()

func create_doors(directions : Array):
	await get_tree().create_timer(1).timeout
	for point in creation_points:
		for direction in directions:
			if point["dir"] == direction:
				#print(str(point["dir"]) + " = " + str(direction) + " : " + str(room_index))
				wall_tilemap.set_cell(point["pos"], -1, Vector2i(1, 0), 0)
				wall_tilemap.set_cell(Vector2(point["pos"].x + abs(direction.y), point["pos"].y + abs(direction.x)))
				
				var door_area2D = preload("res://door_collision.tscn").instantiate()
				door_area2D.position = wall_tilemap.map_to_local(point["pos"])
				
				add_child(door_area2D)
				
				point["scene"] = door_area2D
				
				if point["dir"] == Vector2i(0, 1) or point["dir"] == Vector2i(0, -1):
					door_area2D.rotation_degrees = 90
					door_area2D.position.x += 160
				
				var connecting_room = null
				for room in connected_rooms:
					if room["dir"] == direction:
						connecting_room = room["scene"]
				
				door_area2D.get_node("Label").text = str(connecting_room.room_index)
				#print(str(room_index) + " -> " + str(connecting_room.room_index))
				door_area2D.body_entered.connect(func(_body): dungeon_generation.change_room(connecting_room, direction, _body.global_position))
				break
			else:
				pass
				#print(str(point["dir"]) + " != " + str(direction) + " : " + str(room_index))
	
	#print(str(room_index) + "'s connected rooms : " + str(connected_rooms))
