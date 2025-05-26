class_name HurtBox
extends Area2D

@export var state_machine : Node
@export var body : CharacterBody2D

func _init() -> void:
	collision_layer = 0
	collision_mask = 8

func _ready() -> void:
	area_entered.connect(on_area_entered)

func on_area_entered(Myhitbox : Hitbox) -> void:
	if Myhitbox == null:
		return
	
	var target_group = Myhitbox.target_group
	if body.is_in_group(target_group):
		Myhitbox.hit_enemy.emit()
		
		var hp_component = owner.get_node("health_component")
		if hp_component.has_method("take_damage"):
			
			var attack = Attack.new()
			attack.stun_time = Myhitbox.stun_time
			attack.damage = Myhitbox.damage
			attack.killer = Myhitbox.killer
			attack.knockback_force = Myhitbox.knockback_force
			
			hp_component.take_damage(attack)
			
			state_machine.current_state.Transitioned.emit(state_machine.current_state, "stun")
			
			if Myhitbox.rebounce == true:
				attack.killer.velocity = -attack.killer.velocity * 0.5
