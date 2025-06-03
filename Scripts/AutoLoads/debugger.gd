extends Node

var character_array : Array[CharacterBody2D]

func update_character_data():
	for character in character_array:
		if character:
			if character.has_node("debug"):
				var debug_text = character.get_node("debug")
				debug_text.text = ""
				
				var character_name = character.name
				debug_text.text += character_name + "\n"
				
				if character.has_node("HealthComponent"):
					var character_hp = character.get_node("HealthComponent").health
					debug_text.text += "HP: " + str(character_hp) + "\n"
				if character.has_node("StateMachine"):
					var charcter_state = character.get_node("StateMachine").current_state
					if charcter_state: debug_text.text += "State: " + charcter_state.name + "\n"
				var character_position = character.global_position
				debug_text.text += "Position: " + str(character_position) + "\n"
				var character_velocity = character.velocity
				debug_text.text += "Velocity: " + str(character_velocity) + "\n"
			else:
				var debug_text = Label.new()
				debug_text.name = "debug"
				debug_text.visible = false
				debug_text.position.y += 100
				debug_text.label_settings = LabelSettings.new()
				debug_text.label_settings.font_size = 32
				debug_text.theme = preload("res://Resource/Themes/dev_theme.tres")
				character.add_child(debug_text)
