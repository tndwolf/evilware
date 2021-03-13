extends Action


func attempt(actor:Entity, params:Dictionary) -> bool:
	var direction = params.get('direction', null)
	var target = params.get('target', null)
	if direction and target:
		var start_cell = Map.at(actor.grid_position)
		var end_cell = Map.at(actor.grid_position + direction)
		Map.at(actor.grid_position).move_out(actor)
		actor.animate_move(direction)
		end_cell.move_in(actor)
		Map.update_fov(actor.grid_position)
		
		Map.at(target.grid_position).move_out(target)
		target.animate_move(-direction)
		start_cell.move_in(target)
#		if end_cell.in_los:
#			actor.show()
		return true
	else:
		return false
