extends Trait


func on_added(entity:Entity, params:Dictionary={}):
	pass


func on_damage(actor:Entity, target:Entity, value:int, skill:Skill, params:Dictionary={}) -> int:
	if true:#randi() % 2 == 0:
		return 0 if teleport(target) else value
	else:
		return value


func teleport(target:Entity) -> bool:
	var cell = Map.query().burst(target.grid_position, 3).random(true)
	if cell:
		GM.teleport(target, cell.grid_position)
		return true
	else:
		return false
