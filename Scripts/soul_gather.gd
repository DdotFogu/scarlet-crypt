extends Pickup

func _ready() -> void:
	super()
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	super(body)
	get_tree().root.get_node("main").get_node("Player").get_node("inventory_component").minor_souls_count += 1
