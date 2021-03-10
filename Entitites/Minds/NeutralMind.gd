extends Mind

var target = null


func run() -> bool:
	on_round()
	var res = true
	var direction = Vector2.ZERO
#	if !target and _entity.faction == Entity.Faction.ENEMY:
#		if Map.in_los(_entity.grid_position):
#			target = GM.player
#	else:
#		direction = (target.grid_position - _entity.grid_position).normalized().round()
#		var dx = randi() % 3 -1
#		var dy = randi() % 3 -1
	direction = Vector2(randi() % 3 - 1, randi() % 3 - 1)
	if direction.x != 0 or direction.y != 0:
		GM.try_action('Move', _entity, {'direction': direction})
	return res
