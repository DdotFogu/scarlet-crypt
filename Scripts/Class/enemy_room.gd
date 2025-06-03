extends base_room
class_name enemy_room

@export_category("Enemy Generation")
@export var queued_enemies : Array[PackedScene]
@export var enemy_tilemap : TileMapLayer # used for determining enemy spawn position

var room_enemies : Array[CharacterBody2D]

func _ready() -> void:
	super()
	SignalBus.Enetered_Room.connect(spawn_enemies)

func spawn_enemies(index : int):
	#DevConsole.output_text(str(index) + " =? " + str(room_index))
	if index == data.room_index:
		if enemy_tilemap:
			for enemy_scene in queued_enemies:
				var enemy_instance = enemy_scene.instantiate()
				var instance_pos : Vector2i = get_random_avaible_tile(enemy_tilemap)
				enemy_instance.global_position = enemy_tilemap.map_to_local(instance_pos)
				add_child(enemy_instance)
				
				room_enemies.append(enemy_scene)
			
			queued_enemies.clear()
	else:
		return
