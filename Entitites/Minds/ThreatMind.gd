extends Mind


func _find_target():
	if crack == 'infect':
		for cell in Map.query().burst(_entity.grid_position, 6).collect():
			print('checking cell %s' % cell.grid_position)
			for e in cell.entities():
				print('checking entity %s' % e.name)
				if e.faction == Entity.Faction.PLAYER and e != GM.player:
					print('++++ new target found %s' % e.name)
					return e
		return GM.player
	else:
		return GM.player


func run() -> bool:
	on_round()
	var res = true
	var direction = Vector2.ZERO
	if !target and _entity.faction == Entity.Faction.ENEMY:
		if Map.in_los(_entity.grid_position):
			target = _find_target()
	if target:
		var path = Map.path_to(_entity.grid_position, target.grid_position)
		print('%s to %s via %s' % [_entity.grid_position, target.grid_position, path])
		if len(path) > 1:
			direction = (path[1] - _entity.grid_position).normalized().round()
#		direction = (target.grid_position - _entity.grid_position).normalized().round()
		else:
#			var dx = randi() % 3 -1
#			var dy = randi() % 3 -1
			direction = Vector2(randi() % 3 - 1, randi() % 3 - 1)
	if direction.x != 0 or direction.y != 0:
		GM.try_action('Move', _entity, {'direction': direction})
	return res
