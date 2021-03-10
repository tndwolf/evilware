extends Trait


func on_round(entity:Entity):
	if randi() % 3 == 0:
		var cell = Map.query().burst(entity.grid_position, 1).random()
		if cell:
			GM.spawn_at('worm', cell.grid_position)
