extends Trait


func on_added(entity:Entity, params:Dictionary={}):
	entity.meta['split_rate'] = 4


func on_round(entity:Entity):
	var split_rate = int(entity.meta['split_rate'])
	if entity.mind.target and randi() % split_rate == 0:
		var cell = Map.query().burst(entity.grid_position, 1).random(true)
		if cell and cell.is_empty():
			var new_gen = GM.spawn_at('worm', cell.grid_position)
			if split_rate < 20:
				new_gen.meta['split_rate'] = split_rate * 2
			else:
				new_gen.meta['split_rate'] = 1000000
