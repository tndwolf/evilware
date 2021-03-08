extends Node


func attempt(actor:Entity, params:Dictionary) -> bool:
	var res = false
	var direction = params.get('direction', Vector2.ZERO)
	var end_cell = Map.at(actor.grid_position + direction)
	var target = get_target(end_cell, actor)
	if target:
		params['target'] = target
		if target.is_character() and target.faction != actor.faction:
			return GM.try_action('Crack', actor, params)
		elif target.is_character():
			return GM.try_action('Talk', actor, params)
		elif actor == GM.player:
			return GM.try_action('Use', actor, params)
	elif end_cell.is_walkable():
		Map.at(actor.grid_position).move_out(actor)
		actor.animate_move(direction)
		end_cell.move_in(actor)
		if actor == GM.player:
			Map.update_fov(actor.grid_position)
		if end_cell.in_los:
			actor.show()
		res = true
	elif direction.x != 0 and direction.y != 0:
		params['direction'] = Vector2(direction.x, 0)
		res = GM.try_action('Move', actor, params)
		if !res:
			params['direction'] = Vector2(0, direction.y)
			res = GM.try_action('Move', actor, params)
	return res


func get_target(cell:Cell, actor:Entity):
	var res = null
	for entity in cell.entities():
		res = entity
		break
	return res
