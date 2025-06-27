extends Node2D

var essence_array : Array[Dictionary]

func _ready() -> void:
	create_field(false)
	Dialogic.signal_event.connect(_on_dialogic_signal)

func _on_dialogic_signal(argument):
	if argument == "start_attraction": 
		start_attraction()
		%AnimationPlayer.play("shake")

func create_field(attract : bool = true):
	for i in 80:
		var essence = preload("res://Scene/Cosmetics/soul_opening.tscn").instantiate()
		
		var spawn_pos = Vector2(randf_range(%Min_pos.position.x, %Max_pos.position.x), randf_range(%Min_pos.position.y, %Max_pos.position.y))
		while spawn_pos.distance_to(%PlayerAlt.global_position) < 100:
			spawn_pos = Vector2(randf_range(%Min_pos.position.x, %Max_pos.position.x), randf_range(%Min_pos.position.y, %Max_pos.position.y))
		essence.position = spawn_pos
		
		add_child(essence)
		essence_array.append({"Distance" : essence.global_position.distance_to(%PlayerAlt.global_position), "Scene" : essence})
	
	essence_array.sort_custom(func(a, b): return a.Distance < b.Distance)
	if attract: start_attraction()

func start_attraction():
	var i : int = 0
	
	for essence in essence_array:
		i += 1
		if i == 60: 
			i = 0
			essence_array.clear()
			create_field()
			return 
		
		var pos_tween = get_tree().create_tween()
		pos_tween.tween_property(essence["Scene"], "position", %PlayerAlt.global_position, 1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
		await get_tree().create_timer(0.1).timeout

func scene_change():
	await Global.camera_transition("Fade White")
	Global.change_scene("res://Scene/Dungeon Rooms/Waking Sewer.tscn")
