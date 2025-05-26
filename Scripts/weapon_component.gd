extends Node2D

var scythe_can_attack := true
var combo : int = 0

var lamp_can_attack := true
var soul_projectile_scene = preload("res://soul_projectile.tscn")

@onready var scythe_cooldown: Timer = $Scythe/Cooldown
@onready var scythe_hitbox: Hitbox = $Scythe/Hitbox

@onready var lamp_cooldown: Timer = $Lamp/Cooldown
@onready var lamp: Node2D = $Lamp
@onready var lamp_weapon_sprite: Sprite2D = $Lamp/weapon_sprite
@onready var firing_position: Marker2D = $Lamp/firing_position

@onready var combo_cooldown: Timer = $Scythe/ComboCooldown

@onready var state_machine: Node = $"../state_machine"
@onready var inventory_component: Node = $"../inventory_component"

func _process(delta: float) -> void:
	# Tween lamp node to correct position	
	var direction = get_parent().input_direction
	
	#var rot_tween = get_tree().create_tween()
	var lamp_tween = get_tree().create_tween()
	if direction.x == 1:
		lamp_tween.tween_property(lamp, "position:x", 0 + -100, 0.2)
		lamp_tween.parallel().tween_property(lamp, "rotation_degrees", 30, 0.2)
	elif direction.x == -1:
		lamp_tween.tween_property(lamp, "position:x", 0 + 100, 0.2)
		lamp_tween.parallel().tween_property(lamp, "rotation_degrees", -30, 0.2)
	elif direction.x == 0:
		lamp_tween.tween_property(lamp, "rotation_degrees", 0, 0.2)
	
	# Tween lamp sprite to correct position
	var tween = get_tree().create_tween()
	tween.tween_property(lamp_weapon_sprite, "position:x", 75 * -direction.x, 0.5)
	
	# Attack logic
	if lamp_can_attack:
		if Input.is_action_pressed("pc_lamp") && inventory_component.minor_souls_count > 0:
			inventory_component.minor_souls_count -= 1
			
			#apply cam shake
			var current_cam = get_viewport().get_camera_2d()
			if current_cam.has_node("CameraShake"):
				current_cam.get_node("CameraShake").apply_shake(1)
			
			# spawn projectile
			var spawned_bullet := soul_projectile_scene.instantiate()
			var mouse_direction := get_global_mouse_position() - firing_position.global_position
			
			get_tree().root.add_child(spawned_bullet)
			spawned_bullet.global_position = firing_position.global_position
			spawned_bullet.angle = mouse_direction.angle()
			
			lamp_can_attack = false
			lamp_cooldown.start()
	
	if scythe_can_attack:
		if Input.is_action_pressed("pc_scythe"):
			# Combo logic
			combo_cooldown.start()
			if combo_cooldown.is_stopped() == false:
				if combo < 3:
					combo += 1
				match combo:
					1:
						state_machine.current_state.Transitioned.emit(state_machine.current_state, "attack_one")
						scythe_cooldown.wait_time = 0.4
						combo_cooldown.wait_time = 1
						scythe_hitbox.rebounce = true
					2:
						state_machine.current_state.Transitioned.emit(state_machine.current_state, "attack_two")
						scythe_cooldown.wait_time = 0.5
						scythe_hitbox.rebounce = true
					3:
						state_machine.current_state.Transitioned.emit(state_machine.current_state, "attack_three")
						scythe_cooldown.wait_time = 1
						scythe_hitbox.rebounce = true
						combo = 0
			
			scythe_can_attack = false
			scythe_cooldown.start()

# Reset attack ability
func _on_cooldown_timeout() -> void:
	scythe_can_attack = true

# Reset Combo
func _on_combo_cooldown_timeout() -> void:
	scythe_hitbox.rebounce = false
	combo = 0

func _on_cooldown_timeout_lamp() -> void:
	lamp_can_attack = true
