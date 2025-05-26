extends base_room
class_name enemy_room

@export_category("Enemy Generation")
@export var room_enemies : Array[PackedScene]
@export var enemy_tilemap : TileMapLayer # used for determining enemy spawn position

func _ready() -> void:
	super()
	SignalBus.Enetered_Room.connect(spawn_enemies)

func spawn_enemies(index : int):
	print(str(index) + " =? " + str(room_index))
	if index == room_index:
		if enemy_tilemap:
			print(room_enemies)
			for enemy_scene in room_enemies:
				var enemy_instance = preload("res://Skeleton.tscn").instantiate()
				var instance_pos : Vector2i = get_random_avaible_tile(enemy_tilemap)
				enemy_instance.global_position = enemy_tilemap.map_to_local(instance_pos)
				add_child(enemy_instance)
	else:
		return
