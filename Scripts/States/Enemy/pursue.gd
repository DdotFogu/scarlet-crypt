extends State
class_name pursue

@export var body : CharacterBody2D
@export var sprite_animation : AnimationPlayer
@export var area_range : pursure_range
var target : CharacterBody2D

func physics_update(_delta):
	var direction : Vector2
	
	if body.los_check(target.global_position):
		
		direction = body.global_position.direction_to(target.global_position)
	elif target:
		var tile_data_array = target.get_node("tile_data").spot_array.duplicate()
		var tile_data_distance : Array[Dictionary]
		
		for index in tile_data_array:
			if index["LOS"] == false:
				continue
			tile_data_distance.append({"Scene" : index["Scene"], "Distance" : body.global_position.distance_to(index["Pos"]), "LOS" : index["LOS"]})
		
		var valid_pos : Vector2
		
		tile_data_distance.sort_custom(func(a, b): return a.Distance < b.Distance)
		if tile_data_distance.size() > 0:
			valid_pos = tile_data_distance[0]["Scene"].global_position
		
		if valid_pos:
			direction = body.global_position.direction_to(valid_pos)
		else:
			print("DID NOT FIND VALID SPOT")
	
	if target == null:
		print("Target Isn't Valid, Going Idle!")
		Transitioned.emit(self, "idle")
	
	body.velocity = body.velocity.lerp(direction.normalized() * body.stat_sheet.speed * 5, body.stat_sheet.acceleration)
	body.move_and_slide()

func enter():
	sprite_animation.play("Walk")

func update(delta):
	if body.velocity.x > 0:
		sprite_animation.get_parent().flip_h = false
	elif body.velocity.x < 0:
		sprite_animation.get_parent().flip_h = true
