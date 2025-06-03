@icon("res://Assets/IconGodotNode/node/icon_hitbox.png")
class_name HurtBox
extends Area2D

signal hurtbox_hit(attack : Attack)

@onready var body : CharacterBody2D = owner

func _init() -> void:
	collision_layer = 0
	collision_mask = 8

func _ready() -> void:
	area_entered.connect(hitbox_entered)

func hitbox_entered(Myhitbox : Hitbox) -> void:
	if Myhitbox == null:
		return
	
	var target_group = Myhitbox.target_group
	if !body.is_in_group(target_group):
		print(str(target_group) + " =? " + str(body.name))
		return
	
	if Myhitbox is projectile_hitbox:
		Myhitbox.enemy_hit.connect(Myhitbox.decrease_pierce)
	Myhitbox.enemy_hit.emit()
	
	var attack = Attack.new()
	attack.stun_time = Myhitbox.stun_time
	attack.damage = Myhitbox.damage
	attack.killer = Myhitbox.killer
	attack.knockback_force = Myhitbox.knockback_force
	attack.rebounce = Myhitbox.rebounce
	
	hurtbox_hit.emit(attack)
