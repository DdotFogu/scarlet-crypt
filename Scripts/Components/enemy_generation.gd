@icon("res://Assets/IconGodotNode/node/icon_skull.png")
extends Node
class_name enemy_generation

@export_category("Enemy Generation")
@export var queued_enemies : Array[PackedScene]
@export var enemy_tilemap : TileMapLayer # used for determining enemy spawn position

var room_enemies : Array[CharacterBody2D]
@onready var room : base_room = owner

func spawn_enemies(index : int):
	if index != room.data.room_index: return
	if !enemy_tilemap: return
	
	for enemy_scene in queued_enemies:
		var enemy_instance = enemy_scene.instantiate()
		var instance_pos : Vector2i = room.get_random_avaible_tile(enemy_tilemap)
		enemy_instance.global_position = enemy_tilemap.map_to_local(instance_pos) + enemy_tilemap.global_position
		Global.y_sort.add_child(enemy_instance)
		
		room_enemies.append(enemy_scene)
		
	queued_enemies.clear()
