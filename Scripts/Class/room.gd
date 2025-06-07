@icon("res://Assets/IconGodotNode/node/icon_map.png")
extends Node2D
class_name base_room

@export_category("Room Generation")
@export var creation_points : Array[Dictionary]
@export var wall_tilemap : TileMapLayer
@export var index : Label
var data : room_data

var connected_rooms : Array[base_room]

func _ready() -> void:
	if index:
		index.text = str(data.room_index)

func get_random_avaible_tile(tilemap : TileMapLayer) -> Vector2i:
	var tile_cells = tilemap.get_used_cells()
	tile_cells.shuffle()
	return tile_cells.pick_random()

func create_doors(directions : Array):
	for point in creation_points:
		for direction in directions:
			if point["dir"] == Vector2i(direction):
				wall_tilemap.set_cell(point["pos"], -1, Vector2i(1, 0), 0)
				wall_tilemap.set_cell(Vector2(point["pos"].x + abs(direction.y), point["pos"].y + abs(direction.x)))
				
				var door_area2D = preload("res://Scene/Dungeon Rooms/door_collision.tscn").instantiate()
				door_area2D.position = wall_tilemap.map_to_local(point["pos"])
				
				add_child(door_area2D)
				
				point["scene"] = door_area2D
				
				if point["dir"] == Vector2i(0, 1) or point["dir"] == Vector2i(0, -1):
					door_area2D.rotation_degrees = 90
					door_area2D.position.x += 160
				
				var connecting_room = null
				for room in connected_rooms:
					for room_point in room.creation_points:
						if room_point["dir"] == direction:
							connecting_room = room
				
				if connecting_room: door_area2D.body_entered.connect(func(_body): Global.dungeon_generation.change_room(connecting_room, direction, _body.global_position))
				break
			else:
				pass
