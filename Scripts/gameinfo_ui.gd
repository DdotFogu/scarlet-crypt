extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	Global.GameInfo = self

func play_item_text(title : String, subtitle : String):
	$ItemText/Title.text = "[shake rate=10.0 level=5 connected=1][center][color=Gray][font='E:/OneDrive/Documents/Godot Games/scarlet-crypt/Assets/Fonts/Vaticanus-G3yVG.ttf'][font_size=80]" + title
	$ItemText/Subtitle.text = "[shake rate=10.0 level=5 connected=1][center][color=Gray][font='E:/OneDrive/Documents/Godot Games/scarlet-crypt/Assets/Fonts/Vaticanus-G3yVG.ttf'][font_size=80]" + subtitle
	
	animation_player.play("Default")
