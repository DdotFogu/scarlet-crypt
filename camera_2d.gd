extends Camera2D

@export var player: CharacterBody2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func change_room(room, direction : Vector2i):
	print(room.room_index)
	
	player.velocity = Vector2.ZERO
	player.speed = 0
	
	await cam_transition()
	
	for point in room.creation_points:
		if point["dir"] == -direction:
			var new_player_pos = point["scene"].global_position
			
			if direction.x != 0:
				new_player_pos.x += 25 * direction.x
			elif direction.y != 0:
				new_player_pos.y += 25 * -direction.y
			
			player.position = new_player_pos
			break
	
	player.speed = player.default_speed
	position = room.global_position + room.map_to_local(room.get_used_rect().size) / 2

func cam_transition():
	animation_player.play("transition one close")
	await get_tree().create_timer(0.3).timeout
