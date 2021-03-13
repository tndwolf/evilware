extends Skill


func describe(cell:Cell):
	if cell.is_empty():
		return '> Memory Address (%s)\n> %s' % [
			_describe_corruption_level(cell),
			_describe_corruption(cell)
		]
	else:
		var e = cell.entities()[0]
		return '> %s\n> %s' % [
			e.meta.get('name', e.name),
			_describe_entity(e)
		]


func _describe_corruption_level(cell) -> String:
	match cell.corruption:
		Cell.Corruption.LOW:
				return 'LOW corruption'
		Cell.Corruption.MEDIUM:
				return 'MEDIUM corruption'
		Cell.Corruption.HIGH:
				return 'HIGH corruption'
	return 'Uncorrupted'


func _describe_corruption(cell) -> String:
	match cell.corruption:
		Cell.Corruption.LOW:
				return 'Reduce damage and robustness by 1'
		Cell.Corruption.MEDIUM:
				return 'Reduce damage and robustness by 2'
		Cell.Corruption.HIGH:
				return 'Reduce damage and robustness by 4'
	return 'Freely accessible'


func _describe_entity(entity:Entity) -> String:
	var descr = entity.meta.get('description', 'Data Unavailable')
	descr += '.\n'
	for t in entity._traits:
		if !t in ['Mob', 'Player']:
			descr += t + ' '
#		if t in ['Weakened', 'Stunned']:
#			descr += '%s(%d ticks) ' % [t, entity.meta.get(t, -1)]
	if 'corruption' in entity.meta and entity.meta['corruption'] > 0:
		descr += 'Corrupted(%d) ' % [entity.meta['corruption']]
	return descr


#func get_aoe(actor:Entity, coords:Vector2) -> MapQuery:
#	return Map.query().burst(coords, 2)


func on_purchased(entity:Entity):
	pass
#	entity.hacking += 1


func on_used(actor:Entity, area:MapQuery) -> bool:
	UI.show_message(describe(area.first()))
	return false
#	for cell in area.collect():
#		for entity in cell.entities():
#			if entity.faction != actor.faction:
#				GM.add_trait(entity, 'Weakened')
