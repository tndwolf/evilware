extends Trait


func on_death(entity:Entity, params:Dictionary={}) -> Dictionary:
	if randi() % 3 == 0:
		var cells = Map.query().burst(entity.grid_position, 1).random_empty(2).collect()
		if len(cells) > 1:
			GM.spawn_at('bug', cells[1].grid_position)
		if len(cells) > 0:
			GM.spawn_at('bug', cells[0].grid_position)
	return params
