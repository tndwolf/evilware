extends Control


export var color:Color = Color.white


func _ready():
	$Border.color = color
	$Sprite.modulate = color


func set_icon(icon_id:int):
	$Sprite.frame = icon_id


func set_progress(value:int, max_value:int):
	$TextureProgress.max_value = max_value
	$TextureProgress.value = value
