extends Trait


func on_death(entity:Entity, params:Dictionary={}) -> Dictionary:
	var split_rate = int(entity.meta['split_rate'])
	if randi() % split_rate == 0:
		var to_spawn = 2
		var cells = Map.query().burst(entity.grid_position, 1).collect()
		cells.shuffle()
		for c in cells:
			if c.is_empty() and c.is_walkable():
				spawn_new(c, split_rate)
				to_spawn -= 1
			if to_spawn == 0:
				break
	return params


func on_added(entity:Entity, params:Dictionary={}):
	entity.meta['split_rate'] = 3


func spawn_new(at_cell:Cell, split_rate:int):
	if at_cell:
		var new_gen = GM.spawn_at('bug', at_cell.grid_position)
		if split_rate < 20:
			new_gen.meta['split_rate'] = split_rate * 2
		else:
			new_gen.meta['split_rate'] = 1000000
