extends BaseEffectStrategy

var remaning_time

func apply_effect(target : CharacterBody2D):
	super(target)
	
	remaning_time = lifetime
	var status_component = target.get_node("StatusComponent")
	var target_health : health_component = target.get_node("HealthComponent")
	while remaning_time > 0:
		await target.get_tree().create_timer(0.5).timeout
		remaning_time -= 0.5
		
		var attack = Attack.new()
		attack.damage = 5
		attack.knockback_force = 0
		attack.stun_time = 0
		
		if !target: return
		else: target_health.take_damage(attack)
	
	status_component.status_effects.erase(self)
