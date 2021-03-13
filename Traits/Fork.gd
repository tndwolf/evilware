extends Trait


func on_death(entity:Entity, params:Dictionary={}) -> Dictionary:
	for cell in Map.query().burst(entity.grid_position, 10).collect():
		for e in cell.entities():
			if e.is_character() and e.mind.target == entity:
				e.mind.target = null
	return params


func on_added(entity:Entity, params:Dictionary={}):
	pass
