extends Trait


func on_added(entity:Entity, params:Dictionary={}):
	pass


func on_round(entity:Entity):
	if randi() % 3 == 0:
		var cell = Map.query().burst(GM.player.grid_position, 1).random(true)
		if cell:
			GM.teleport(entity, cell.grid_position, true)
