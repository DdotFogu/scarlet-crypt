class_name PopupManager

static var popupscene := preload("res://Scene/Cosmetics/popup.tscn")

static func spawn_dmg_popup(attack: Attack, parent: Node):
	var popup = popupscene.instantiate()

	# Get RichTextLabel and update text
	var rich_text = popup.get_child(0)  # Adjust to match your scene
	if rich_text is RichTextLabel:
		rich_text.text += str(attack.damage)  # Example BBCode for styling
	else:
		printerr("Popup does not contain a RichTextLabel node!")

	# Set popup's position at parent and defer the update
	popup.global_position = parent.global_position + Vector2(0, -50)
	parent.get_tree().current_scene.add_child(popup)

	# Store initial position before tweening
	var start_pos = popup.global_position
	var side_offset = 50 * get_side_relation(parent, attack.killer)

	# Create a tween for animations
	var pos_tween = popup.create_tween()
	var scale_tween = popup.create_tween()

	# Small scale-up effect for emphasis
	popup.scale = Vector2(0, 0)  # Start slightly smaller
	pos_tween.tween_property(popup, "scale", Vector2(0.4, 0.4), 0.25).set_trans(Tween.TRANS_BACK)
	
	scale_tween.tween_property(popup, "global_position", popup.global_position + Vector2(get_side_relation(parent, attack.killer), -60), 0.25).set_trans(Tween.TRANS_BACK)

	await popup.get_tree().create_timer(0.25).timeout  

	# Check if popup is still valid before applying tweens
	if not is_instance_valid(popup):
		printerr("Popup was freed before tweening!")
		return
	else:
		pass
	
	var tween2 = popup.create_tween()
	
	# Drift down and fade out
	tween2.parallel().tween_property(
		popup, "global_position",
		popup.global_position + Vector2(0, 20), 
		0.5
	).set_trans(Tween.TRANS_QUAD)

	tween2.parallel().tween_property(
		popup, "modulate:a", 
		0, 
		0.5
	).set_trans(Tween.TRANS_LINEAR)

	# Cleanup: Remove popup after animation
	pos_tween.tween_callback(popup.queue_free)

static func spawn_status_popup(text : String, parent: Node):
	var popup = popupscene.instantiate()

	# Get RichTextLabel and update text
	var rich_text = popup.get_child(0)  # Adjust to match your scene
	if rich_text is RichTextLabel:
		rich_text.text += text # Example BBCode for styling
	else:
		printerr("Popup does not contain a RichTextLabel node!")

	# Set popup's position at parent and defer the update
	popup.global_position = parent.global_position + Vector2(0, -50)
	parent.get_tree().current_scene.add_child(popup)

	# Store initial position before tweening
	var start_pos = popup.global_position

	# Create a tween for animations
	var pos_tween = popup.create_tween()
	var scale_tween = popup.create_tween()

	# Small scale-up effect for emphasis
	popup.scale = Vector2(0, 0)  # Start slightly smaller
	pos_tween.tween_property(popup, "scale", Vector2(0.4, 0.4), 0.25).set_trans(Tween.TRANS_BACK)
	
	scale_tween.tween_property(popup, "global_position", popup.global_position, -60).set_trans(Tween.TRANS_BACK)

	await popup.get_tree().create_timer(0.25).timeout  

	# Check if popup is still valid before applying tweens
	if not is_instance_valid(popup):
		printerr("Popup was freed before tweening!")
		return
	else:
		pass
	
	var tween2 = popup.create_tween()
	
	# Drift down and fade out
	tween2.parallel().tween_property(
		popup, "global_position",
		popup.global_position - Vector2(0, 40), 
		0.5
	).set_trans(Tween.TRANS_QUAD)

	tween2.parallel().tween_property(
		popup, "modulate:a", 
		0, 
		0.5
	).set_trans(Tween.TRANS_LINEAR)

	# Cleanup: Remove popup after animation
	pos_tween.tween_callback(popup.queue_free)

static func get_side_relation(object_1: Node2D, object_2: Node2D) -> int:
	if !object_2: return Global.rng.randi_range(0, 1)
	
	if object_1.global_position.x > object_2.global_position.x:
		return 1  # Object 1 is on the right
	elif object_1.global_position.x < object_2.global_position.x:
		return -1  # Object 1 is on the left
	else:
		return 0  # They are aligned
