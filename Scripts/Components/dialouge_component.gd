@icon("res://Assets/IconGodotNode/node/icon_dialog.png")
extends Node2D
class_name dialouge_component

@export var DialogueTimeline : DialogicTimeline

func start_timeline() -> void:
	Dialogic.start_timeline(DialogueTimeline)
