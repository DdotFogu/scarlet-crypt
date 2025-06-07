extends BaseBulletStrategy

@export var effect_to_apply : BaseEffectStrategy

func apply_upgrade(item : Node2D):
	if item is not Hitbox: return
	if item.status_effects.has(effect_to_apply): return
	
	super(item)
	item.status_effects.append(effect_to_apply)
