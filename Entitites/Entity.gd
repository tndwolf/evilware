extends Sprite
class_name Entity


enum Faction {
	PLAYER,
	ENEMY
}


var faction = Faction.ENEMY
var grid_position = -Vector2.ONE setget set_grid_position, get_grid_position
var hacking = 0
var integrity = 1 setget set_integrity, get_integrity
var _max_integrity = 1
var meta = {}
var mind = null setget set_mind, get_mind
var robustness = 0
var security = 0
var _traits = []
onready var _tween = $Tween


func animate_attack(target:Entity) -> Tween:
	if $Camera2D:
		$Camera2D.current = false
		var timer = get_tree().create_timer(Config.ATTACK_DURATION)
		timer.connect("timeout", $Camera2D, 'make_current')
	var start = position
	var end = (position + target.position) / 2.0
	var dx = end.x - start.x
	if dx > 0:
		flip_h = false
#		scale = Vector2(-1.0, 1.0)
	elif dx < 0:
		flip_h = true
#		scale = Vector2(-1.0, 1.0)
	_tween.interpolate_property(self, 'position', start, end, Config.ATTACK_DURATION/2)
	_tween.interpolate_property(self, 'position', end, start, Config.ATTACK_DURATION/2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, Config.ATTACK_DURATION/2)
	_tween.start()
	return _tween


func animate_move(by:Vector2) -> Tween:
	grid_position += by
	var start = position
	var end = grid_position * Config.CELL_SIZE
	_tween.interpolate_property(self, 'position', start, end, Config.MOVE_DURATION)
	_tween.start()
	if by.x > 0:
		flip_h = false
#		scale = Vector2.ONE
	elif by.x < 0:
		flip_h = true
#		scale = Vector2(-1.0, 1.0)
	return _tween


func get_grid_position() -> Vector2:
	return grid_position


func get_integrity() -> int:
	return integrity


func get_mind():
	return mind


func hide():
	visible = false
#	var start = modulate
#	var end = Color(start.r, start.g, start.b, 0.0)
#	_tween.interpolate_property(self, 'modulate', start, end, Config.MOVE_DURATION/2)
#	_tween.start()


func initialize(template:Dictionary) -> Entity:
	for meta_tag in template.get('meta', {}):
		meta[meta_tag] = template['meta'][meta_tag]
	_max_integrity = template.get('integrity', 1)
	integrity = _max_integrity
	faction = template.get('faction', Faction.ENEMY)
	if 'mind' in template:
		set_mind(template['mind'].new())
	for trait_id in template.get('traits', []):
		GM.add_trait(self, trait_id)
	match faction:
		Faction.ENEMY:
			self_modulate = Config.COLOR_THREATS
		Faction.PLAYER:
			self_modulate = Config.COLOR_FRIENDLY
	return self


func is_character() -> bool:
	return mind != null


func is_idle() -> bool:
	return !_tween.is_active()


func run() -> bool:
	if mind:
		return mind.run_or_skip()
	else:
		return true


func set_grid_position(value:Vector2):
	grid_position = value
	position = value * Config.CELL_SIZE


func set_integrity(value:int):
	if integrity != value:
		integrity = clamp(value, 0, _max_integrity)
		if integrity == 0:
			GM.kill(self)


func set_mind(value):
	mind = value
	mind._entity = self


func show():
	visible = true
#	var start = modulate
#	var end = Color(start.r, start.g, start.b, 1.0)
#	_tween.interpolate_property(self, 'modulate', start, end, Config.MOVE_DURATION/2)
#	_tween.start()
