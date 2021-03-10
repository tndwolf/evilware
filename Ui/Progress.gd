extends Control


export var color:Color = Color.white


func _ready():
	$Border.color = color


func set_progress(value:int, max_value:int):
	return
#	$TextureProgress.max_value = max_value
#	$TextureProgress.value = value
