@icon("res://Assets/IconGodotNode/node/icon_map.png")
extends Node2D
class_name base_room

@export_category("Room Generation")
@export var creation_points : Array[Dictionary]
@export var wall_tilemap : TileMapLayer
@export var index : Label
var data : room_data

var connected_rooms : Array[base_room]

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
				
				var connecting_room = null
				for room in connected_rooms:
					for room_point in room.creation_points:
						if room_point["dir"] == direction:
							connecting_room = room
				
				if point["door"]: get_node(point["door"]).visible = true
				if connecting_room and point["door"]: get_node(point["door"]).get_node("DoorCollision").body_entered.connect(func(_body): Global.dungeon_generation.change_room(connecting_room, direction, _body.global_position))
				break
			else:
				pass
