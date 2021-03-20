extends Trait


func on_round(entity:Entity):
	if Map.at(entity.grid_position).in_los and randi() % 4 == 0:
		var cell = Map.query().burst(GM.player.grid_position, 1).random(true)
		if cell:
			GM.teleport(entity, cell.grid_position, true)
