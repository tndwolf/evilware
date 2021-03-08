extends Node2D
class_name Cell


enum Corruption {
	NONE,
	LOW,
	MEDIUM,
	HIGH
}


enum Type {
	INVALID,
	FLOOR,
	ABYSS,
	WALL
}

const CORRUPTION_COLOR = [
	Color.blue,
	Color.lightgreen,
	Color.goldenrod,
	Color.lightcoral
]


var cell_type = Type.INVALID setget set_cell_type, get_cell_type
var _color_shift = randf() * 0.2
var corruption = Corruption.NONE setget set_corruption, get_corruption
var _entities = []
var grid_position = -Vector2.ONE setget set_grid_position, get_grid_position
var in_los = false setget set_in_los, get_in_los
var model = null setget set_model, get_model
onready var _tween = $Tween


func _ready():
	modulate = _get_visible_color()


func blocks_los() -> bool:
	return cell_type == Type.WALL


func entities() -> Array:
	return _entities


func get_cell_type() -> int:
	return cell_type


func get_corruption() -> int:
	return corruption


func get_grid_position() -> Vector2:
	return grid_position


func get_in_los() -> bool:
	return in_los


func get_model() -> Node2D:
	return model


func _get_visible_color() -> Color:
	var res = Color.white
	match cell_type:
		Type.ABYSS:
			res = Color.transparent
		Type.FLOOR:
			res = CORRUPTION_COLOR[corruption].lightened(_color_shift)
		Type.INVALID:
			res = Color.transparent
		Type.WALL:
			res = CORRUPTION_COLOR[corruption].darkened(0.2 + _color_shift)
	return res


func hide():
	_tween.stop_all()
	var start = modulate
	var end = Color(start.r, start.g, start.b, 0.0)
	_tween.interpolate_property(self, 'modulate', start, end, Config.MOVE_DURATION/4)
	_tween.start()
	for entity in _entities:
		entity.hide()


func is_empty() -> bool:
	return _entities.empty()


func is_walkable() -> bool:
	return cell_type == Type.FLOOR


func move_in(entity:Node):
	if !entity in _entities:
		_entities.append(entity)


func move_out(entity:Node):
	_entities.erase(entity)


func set_cell_type(value:int):
	if cell_type != value:
		cell_type = value
		match value:
			Type.ABYSS:
				z_index = -10
				$Sprite.frame = 6
			Type.FLOOR:
				z_index = -10
				$Sprite.frame = 5
			Type.INVALID:
				z_index = -10
				$Sprite.frame = 6
			Type.WALL:
				z_index = 0
				$Sprite.frame = randi() % 4


func set_corruption(value:int):
	if corruption != value:
		corruption = value
		if in_los:
			show()
#		match value:
#			Corruption.LOW:
#				modulate = Color.lightgreen


func set_grid_position(value:Vector2):
	grid_position = value
	position = value * Config.CELL_SIZE


func set_in_los(value:bool):
	if in_los != value:
		in_los = value
		if !_tween:
			visible = in_los
		if in_los:
			visible = true
			show()
		else:
			hide()


func set_model(value:Node2D):
	if model != null:
		pass
	model = value
	model.position = grid_position * Config.CELL_SIZE


func show():
	_tween.stop_all()
	var start = modulate
	var end = _get_visible_color()
	_tween.interpolate_property(self, 'modulate', start, end, Config.MOVE_DURATION/4)
	_tween.start()
	for entity in _entities:
		entity.show()


func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		GM.player.mind.on_click(event, grid_position)