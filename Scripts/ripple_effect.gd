@icon("res://Assets/IconGodotNode/node/icon_liquid.png")
extends Node2D

@export var ripple_start_size : Vector2 = Vector2(0.4, 0.4)
@export var ripple_end_size : Vector2 = Vector2(0.7, 0.7) 
@export var ripple_speed : float = 1.0
@export var ripple_texture : Texture = preload("res://Assets/Sprites/Particles/FullCircle.png")

var sprite_array : Array

var in_ripple : bool = false

func _ready() -> void:
	#Create ripple sprites needed for later use in ripple func
	var ripple_sprite = Sprite2D.new()
	ripple_sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	ripple_sprite.texture = ripple_texture
	ripple_sprite.z_index = 1
	ripple_sprite.modulate.a = 0
	add_child(ripple_sprite)
	
	sprite_array.append(ripple_sprite)
	
	$DropetParticle.finished.connect(ripple)

#this stupid func doesn't work, fucking shitty dev
func ripple():
	print("diddy")
	#Check if a ripple isn't already in progress, if so then stop the new func process
	if in_ripple == true: return
	in_ripple = true
	
	#creating a duped array so I can erase values but still have all of them in the same array
	var array = sprite_array.duplicate()
	var ripple = array.pick_random()
	ripple.modulate.a = 255
	ripple.scale = ripple_start_size
	
	array.erase(ripple)
	
	#animate the ripple sprite to achieve effect
	var tween2 = ripple.create_tween()
	tween2.tween_property(ripple, "modulate:a", 0, ripple_speed)
	var tween = ripple.create_tween()
	tween.tween_property(ripple, "scale", ripple_end_size, ripple_speed)
	
	await get_tree().create_timer(ripple_speed).timeout
	
	in_ripple = false
