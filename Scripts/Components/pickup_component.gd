extends target_dectection
class_name pickup_component

@export var minor_souls_count : int = 0
@export var major_souls_count : int = 0

@export var upgrades : Array[BaseBulletStrategy] = []

@onready var body : CharacterBody2D = owner

func _ready() -> void:
	super()

func pickup_item():
	var target_inv : inventory_component = target.get_node("InventoryComponent")
	if !target or !inventory_component: return
	if minor_souls_count > 0:
		for i in minor_souls_count:
			target_inv.minor_souls_count += 1
	
	if major_souls_count > 0:
		for i in major_souls_count:
			target_inv.major_souls_count += 1
	
	if upgrades.size() > 0:
		for upgrade in upgrades:
			if target_inv.upgrades.has(upgrade): break
			target_inv.upgrades.append(upgrade)
			
			if Global.GameInfo: Global.GameInfo.play_item_text(upgrade.upgrade_text, upgrade.flavor_text)
	
	body.queue_free()
