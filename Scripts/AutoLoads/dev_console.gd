extends CanvasLayer

@onready var input: LineEdit = $Input
@onready var output: VBoxContainer = $Output

var last_cmd 

func _ready() -> void:
	visible = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("dev_console"):
		visible = !visible
		
		if visible == true:
			get_tree().paused = true
			input.edit()
		else:
			get_tree().paused = false
			input.unedit()

func zoom(zoom_float : float = 0.2):
	Global.current_camera.zoom = Vector2(zoom_float, zoom_float)

func teleport():
	output_text("Teleported Player To " + str(get_tree().current_scene.get_global_mouse_position()))
	Global.player.global_position = get_tree().current_scene.get_global_mouse_position()

func view_collision(enabled : bool = true):
	get_tree().set_debug_collisions_hint(enabled)

func char_data(enabled : bool = true):
	for character in Debugger.character_array:
		if character != null and character.has_node("debug"):
			var debug_text = character.get_node("debug")
			if enabled:
				debug_text.visible = true
			else:
				debug_text.visible = false

func spawn(spawn_name : String, amount : int = 1):
	var spawn_dict : Dictionary = {
	"npc" : preload("res://Scene/Characters/NPC/base_character.tscn"),
	"skeleton" : preload("res://Scene/Characters/NPC/Enemies/Skeleton.tscn"), 
	"minor soul" : preload("res://Scene/Pickups/MinorSoul.tscn")
	}
	spawn_name = spawn_name.to_lower()
	
	var instance = spawn_dict[spawn_name.to_lower()].instantiate()
	
	var spawn_position = get_tree().current_scene.get_global_mouse_position()
	instance.global_position = spawn_position
	
	var count : int = 0
	for i in amount:
		count += 1
		get_tree().current_scene.add_child(instance)
	
	output_text("Spawned " + str(count) + " " + str(spawn_name))

func again():
	if last_cmd != null:
		_on_text_edit_text_submitted(last_cmd)
	else:
		output_text("No command to repeat")

func echo(val): 
	return val

func reload() -> void:
	visible = !visible
	input.unedit()
	get_tree().paused = false
	get_tree().reload_current_scene()

func clear() -> void:
	for child in output.get_children():
		child.queue_free()

func tile_data(enabled : bool = true) -> void:
	var tile_data_node = get_tree().current_scene.get_node("Player").get_node("TileDataComponent")
	
	if enabled == true:
		output_text("Showing Tile Data")
		for node in tile_data_node.spot_array:
			node["Scene"].visible = true
	else:
		output_text("Hiding Tile Data")
		for node in tile_data_node.spot_array:
			node["Scene"].visible = false

func _on_text_edit_text_submitted(command: String) -> void:
	if command != "again()" && command != "":
		last_cmd = command
	input.text = ""
	
	var output_text = Label.new()
	output_text.theme = load("res://Assets/Themes/dev_theme.tres")
	output_text.process_mode = Node.PROCESS_MODE_ALWAYS
	output.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	
	output.add_child(output_text)
	
	var expression = Expression.new()
	var parse_error = expression.parse(command)
	if parse_error != OK:
		output_text.text = expression.get_error_text()
	
	var execute_result = expression.execute([], self)
	if expression.has_execute_failed():
		output_text.text = expression.get_error_text()
	elif execute_result != null:
		if not execute_result is Object:
			output_text.text = str(execute_result)

func output_text(text : String):
	var output_text = Label.new()
	output_text.theme = load("res://Assets/Themes/dev_theme.tres")
	output_text.text = text
	output_text.process_mode = Node.PROCESS_MODE_ALWAYS
	output.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	
	output.add_child(output_text)
