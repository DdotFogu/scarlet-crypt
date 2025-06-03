extends Hitbox
class_name projectile_hitbox

@export_category("Projectile")
@export var health_component : health_component

func decrease_pierce():
	print("diddy blud")
	
	var attack = Attack.new()
	attack.damage = 1
	attack.killer = owner
	health_component.take_damage(attack, true)
