extends BaseEffectStrategy

func apply_effect(target : CharacterBody2D):
	super(target)
	
	var target_health : health_component = target.get_node("HealthComponent")
	while lifetime > 0:
		await target.get_tree().create_timer(0.5).timeout
		lifetime -= 0.5
		
		var attack = Attack.new()
		attack.damage = 5
		attack.knockback_force = 0
		attack.stun_time = 0
		target_health.take_damage(attack)
	
	erase_icon()
