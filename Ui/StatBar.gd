extends Panel


var maximum = 32 setget set_maximum, get_maximum
var value = 16 setget set_value, get_value


func _ready():
	_update()


func get_maximum()->int:
	return maximum


func get_value()->int:
	return value


func set_maximum(value:int):
	if value > 0:
		maximum = value
		_update()


func set_value(new_value:int):
	value = clamp(new_value, 0, maximum)
	$Bar.visible = value > 0
	_update()


func _update():
	hint_tooltip = '%s %d/%d' % [name, value, maximum]
	$Bar.rect_size = Vector2(rect_size.x * value/maximum, rect_size.y)
#	print('%d/%d -> %s/%s' % [value, maximum, $Bar.rect_size, rect_size])
