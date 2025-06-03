@icon("res://Assets/IconGodotNode/color/icon_heart.png")
extends Node
class_name health_component

signal took_damage
signal death

signal change_states(state_name : String)

var health : int
var last_attack : Attack

@export var visual_component : visual_component
@onready var body : CharacterBody2D = owner

func _ready() -> void:
	health = body.stat_sheet.health

func take_damage(attack:Attack, hideDamage : bool = false):
	last_attack = attack
	
	# Reduce health
	health -= attack.damage
	
	if !hideDamage : PopupManager.spawn_dmg_popup(attack, body)
	
	if attack.damage > 0:
		if attack.stun_time > 0: change_states.emit()
		
		if visual_component: visual_component.play_animation("hurt")
		
		took_damage.emit()
	
	if health <= 0:
		die()

func die():
	Debugger.character_array.erase(owner)
	
	if visual_component: await visual_component.play_animation("death")
	
	death.emit()
	body.queue_free()
