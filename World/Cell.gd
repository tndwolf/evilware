class_name Cell
extends Node2D


# Corruption level of the cell
enum Corruption {
	NONE,
	LOW,
	MEDIUM,
	HIGH
}


# Type of Cell 
enum Type {
	INVALID,
	FLOOR,
	ABYSS,
	WALL
}


# Reference to what would be the Cell color, by its Corruption level
var CORRUPTION_COLOR = [
	Config.COLOR_NO_CORRUPTION,
	Config.COLOR_LOW_CORRUPTION,
	Config.COLOR_MED_CORRUPTION,
	Config.COLOR_HIGH_CORRUPTION
]


var cell_type = Type.INVALID setget set_cell_type, get_cell_type
var corruption = Corruption.NONE setget set_corruption, get_corruption
var corruption_resist = 0
var grid_position = -Vector2.ONE setget set_grid_position, get_grid_position
var in_los = false setget set_in_los, get_in_los
var model = null setget set_model, get_model

var _color_shift = randf() * 0.2
var _entities = []
onready var _tween = $Tween


func _ready():
	modulate = _get_visible_color()


# Returns true if this Cell blocks Line of Sight
func blocks_los() -> bool:
	return cell_type == Type.WALL


# Returns a list of entities on this Cell
func entities() -> Array:
	return _entities


# Returns the Cell type as a Cell.Type enum
func get_cell_type() -> int:
	return cell_type


# Return the corruption level as a Cell.Corruption enum
func get_corruption() -> int:
	return corruption


# Returns the Cell coordinates on the map
func get_grid_position() -> Vector2:
	return grid_position


# Returs true if the Cell is in Line of Sight
func get_in_los() -> bool:
	return in_los


# Returs the in-game Cell representation
func get_model() -> Node2D:
	return model


# Returns the modulate color for the Cell'model based on its Type and
# Corruption level
func _get_visible_color() -> Color:
	var res = Color.white
	match cell_type:
		Type.ABYSS:
			res = Color.transparent
		Type.FLOOR:
			res = CORRUPTION_COLOR[corruption].lightened(0.2 + _color_shift)
		Type.INVALID:
			res = Color.transparent
		Type.WALL:
			res = CORRUPTION_COLOR[corruption].darkened(0.2 + _color_shift)
	return res


# Makes the cell semi-transparent, to indicate it is not within Line of Sight.
# Entities on the Cell are hidden too.
func hide():
	_tween.stop_all()
	var start = modulate
	var end = _get_visible_color() * Color(1, 1, 1, 0.25)
	_tween.interpolate_property(self, 'modulate', start, end, Config.MOVE_DURATION/4)
	_tween.start()
	for entity in _entities:
		entity.hide()


# Return true if no Entities are on top of this Cell
func is_empty() -> bool:
	return _entities.empty()


# Returns true if Entities can Move onto this Cell
func is_walkable() -> bool:
	return cell_type == Type.FLOOR


# Sets an object as contained by this Cell, updating its Line of Sight status.
# It does not 'translate' the Entity itself.
func move_in(entity:Node):
	if !entity in _entities:
		_entities.append(entity)
		update_corruption(entity)
		if !in_los:
			entity.hide()


# Removes an Entity from this cell
func move_out(entity:Node):
	_entities.erase(entity)


# Sets the Cell type as a Cell.Type enum
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

# Sets the Cell's corruption level as a Cell.Corruption enum
func set_corruption(value:int):
	if corruption != value:
		if value > corruption and corruption_resist > 0:
			corruption_resist -= 1
		else:
			corruption = value
			if in_los:
				show()
		for e in _entities:
			update_corruption(e)


# Sets the Cell coordinates on the map
func set_grid_position(value:Vector2):
	grid_position = value
	position = value * Config.CELL_SIZE


# Sets the Cell to be inside or outside the Field of View. It updates also
# the visibility of the contained Entities.
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


# Sets the Cell in-game representation
func set_model(value:Node2D):
	if model != null:
		pass
	model = value
	model.position = grid_position * Config.CELL_SIZE


# Makes the cell opaque, to indicate it is within Line of Sight.
# Entities on the Cell are revealed too.
# It can also be used to update the color after a change of Type/Corruption
func show():
	_tween.stop_all()
	var start = modulate
	var end = _get_visible_color()
	_tween.interpolate_property(self, 'modulate', start, end, Config.MOVE_DURATION/4)
	_tween.start()
	for entity in _entities:
		entity.show()


# Updates an Entity based on the current Cell Corruption.
# For the Player Entity it means adding a visual FX and setting its Corruption
# score.
func update_corruption(entity):
	if entity == GM.player:
		var fx:CPUParticles2D = entity.get_node('CorruptionFX')
		var tot_corruption = clamp(int(corruption) - entity.security, 0, 5)
		match tot_corruption:
			Corruption.NONE:
				entity.meta['corruption'] = 0
				fx.visible = false
			Corruption.LOW:
				entity.meta['corruption'] = 1
				fx.color = Config.COLOR_LOW_CORRUPTION
				fx.visible = true
			Corruption.MEDIUM:
				entity.meta['corruption'] = 2
				fx.color = Config.COLOR_MED_CORRUPTION
				fx.visible = true
			Corruption.HIGH:
				entity.meta['corruption'] = 4
				fx.color = Config.COLOR_HIGH_CORRUPTION
				fx.visible = true


# Input signal endpoint
func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		GM.player.mind.on_click(event, grid_position)
