extends Skill


func on_purchased(entity:Entity):
	entity.hacking += 1


func on_used(actor:Entity, area:MapQuery):
	var target = area.first(true)
	if target.is_empty():
		var fork = GM.spawn_at('fork', target.grid_position)
		for cell in Map.query().fov().collect():
			for entity in cell.entities():
				if entity.is_character() and entity.faction == Entity.Faction.ENEMY:
					entity.mind.target = fork
		return true
	else:
		return false
