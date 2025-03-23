extends TileMapLayer

@export var creation_points : Array[Dictionary]
var connected_rooms : Array[Dictionary]
var room_index : int
var dungeon_generation

func _ready() -> void:
	$Index.text = str(room_index)
	dungeon_generation = get_node("/root/main/dungeon_generation")

func create_doors(directions : Array):
	await get_tree().create_timer(1).timeout
	for point in creation_points:
		for direction in directions:
			if point["dir"] == direction:
				set_cell(point["pos"], -1, Vector2i(1, 0), 0)
				set_cell(Vector2(point["pos"].x + abs(direction.y), point["pos"].y + abs(direction.x)))
				
				var door_area2D = preload("res://door_collision.tscn").instantiate()
				door_area2D.position = map_to_local(point["pos"])
				add_child(door_area2D)
				
				point["scene"] = door_area2D
				
				var connecting_room = null
				for room in connected_rooms:
					if room["dir"] == direction:
						connecting_room = room["scene"]
				
				door_area2D.get_node("Label").text = str(connecting_room.room_index)
				door_area2D.body_entered.connect(func(_body): dungeon_generation.main_cam.change_room(connecting_room, direction))
				break
